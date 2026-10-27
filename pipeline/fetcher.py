import argparse
import os
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from math import ceil
from pathlib import Path

import pandas as pd
import requests
from dotenv import load_dotenv
from requests.adapters import HTTPAdapter

# Ensure unbuffered standard output for real-time console streaming
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(line_buffering=True)
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(line_buffering=True)

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
BASE_URL = os.getenv("API_URL")
if not BASE_URL:
    raise ValueError(
        "Environment variable 'API_URL' is required. Please set it in your .env file."
    )

BASE_URL = BASE_URL.rstrip("/")
RAW_FOLDER = Path(os.getenv("RAW_DATA_DIR", BASE_DIR / "data" / "raw"))
DEFAULT_CONCURRENCY = int(os.getenv("FETCH_CONCURRENCY", "8"))

# Configure endpoints: (endpoint_path, parquet_filename, query_params, page_limit, max_workers)
# Bounded by 2024 date parameters to prevent infinite streams from real-time simulation.
ENDPOINTS = [
    ("zones", "urban_zones.parquet", {}, 1000, 4),
    ("quadrants", "quadrants.parquet", {}, 1000, 4),
    ("users", "users.parquet", {}, 2000, 4),
    ("drivers", "drivers.parquet", {}, 1000, 4),
    ("vehicles", "vehicles.parquet", {}, 1000, 4),
    ("campaigns", "incentive_campaigns.parquet", {}, 1000, 4),
    (
        "trips",
        "trips.parquet",
        {"end_time": "2024-12-31T23:59:59"},
        5000,
        8,
    ),
    ("payments", "trip_payments.parquet", {}, 5000, 8),
    ("ratings", "trip_ratings.parquet", {}, 5000, 8),
    ("cancellations", "trip_cancellations.parquet", {}, 5000, 8),
    (
        "telemetry",
        "driver_telemetry.parquet",
        {"end_time": "2024-12-31T23:59:59"},
        10000,
        8,
    ),
    (
        "maintenance",
        "vehicle_maintenance.parquet",
        {"end_date": "2024-12-31"},
        1000,
        4,
    ),
    (
        "weather",
        "quadrant_weather.parquet",
        {"date_from": "2024-01-01", "date_to": "2024-12-31"},
        5000,
        3,  # Conservative concurrency to avoid saturating remote database pool
    ),
]


def create_session(concurrency: int) -> requests.Session:
    session = requests.Session()
    adapter = HTTPAdapter(
        pool_connections=concurrency + 4,
        pool_maxsize=concurrency + 4,
        max_retries=3,
    )
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    return session


def format_time(seconds: float) -> str:
    """Format duration into MM:SS or HH:MM:SS."""
    if seconds < 0 or seconds > 86400 * 7:
        return "--:--"
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    if h > 0:
        return f"{h:02d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"


def print_progress(
    path: str,
    completed: int,
    num_batches: int,
    items_count: int,
    total: int,
    start_time: float,
    is_final: bool = False,
) -> None:
    """Render a dynamic progress bar with real-time transfer rate and ETA."""
    elapsed = max(time.time() - start_time, 0.001)
    rate = items_count / elapsed
    pct = (completed / num_batches) * 100 if num_batches > 0 else 100.0
    remaining_items = max(0, total - items_count)
    eta = remaining_items / rate if rate > 0 else 0

    bar_width = 24
    filled = int(bar_width * completed // num_batches) if num_batches > 0 else bar_width
    bar = "=" * filled + (">" if filled < bar_width else "") + " " * max(0, bar_width - filled - 1)

    msg = (
        f"  [{path}] [{bar}] {completed}/{num_batches} lotes ({pct:5.1f}%) "
        f"| {items_count:,}/{total:,} reg | {rate:,.0f} reg/s "
        f"| {format_time(elapsed)} < {format_time(eta)}"
    )

    if sys.stdout.isatty():
        print(f"\r{msg}", end="" if not is_final else "\n", flush=True)
    else:
        step = 5 if num_batches > 25 else 1
        if completed % step == 0 or completed == num_batches or is_final:
            print(msg, flush=True)


def get_num_batches(
    session: requests.Session, path: str, params: dict, limit: int
) -> tuple[int, int]:
    """Request metadata to calculate total items and batch count with explicit logging."""
    url = f"{BASE_URL}/{path.lstrip('/')}"
    p = params.copy()
    p["limit"] = 1
    filter_desc = str(params) if params else "sin filtros"
    print(f"[{path}] Consultando metadatos en API (filtros: {filter_desc})...", flush=True)

    for attempt in range(4):
        try:
            res = session.get(url, params=p, timeout=25)
            if res.status_code == 200:
                total: int = res.json().get("total", 0)
                num_batches = ceil(total / limit) if total > 0 else 0
                return total, num_batches
            else:
                print(
                    f"  ⚠️ [{path}] Respuesta HTTP {res.status_code}: {res.text[:120]} (intento {attempt + 1}/4)",
                    flush=True,
                )
        except Exception as e:
            print(
                f"  ⚠️ [{path}] Error consultando metadatos (intento {attempt + 1}/4): {e}",
                flush=True,
            )
            time.sleep(1.0 * (attempt + 1))
    return 0, 0


def fetch_batch(
    session: requests.Session,
    url: str,
    base_params: dict,
    offset: int,
    limit: int,
    retries: int = 5,
) -> list[dict]:
    """Fetch a single paginated batch with retry mechanism and exponential backoff."""
    p = base_params.copy()
    p["offset"] = offset
    p["limit"] = limit
    for attempt in range(retries):
        try:
            res = session.get(url, params=p, timeout=60)
            if res.status_code == 200:
                return res.json().get("items", [])
            elif res.status_code == 422:
                break
        except Exception as e:
            if attempt < retries - 1:
                endpoint_name = url.split("/")[-1]
                print(
                    f"\n  ⚠️ [{endpoint_name}] Reintentando lote offset={offset} (intento {attempt + 2}/{retries}): {e}",
                    flush=True,
                )
            else:
                print(
                    f"\n  ❌ [{url.split('/')[-1]}] Lote offset={offset} falló tras {retries} intentos: {e}",
                    flush=True,
                )
        time.sleep(0.5 * (attempt + 1))
    return []


def get_data(
    session: requests.Session,
    path: str,
    params: dict,
    limit: int,
    concurrency: int,
    max_trip_id: int | None = None,
) -> pd.DataFrame:
    """
    Fetch paginated data for an endpoint using controlled concurrent workers.
    Supports max_trip_id bounding for streaming child tables (payments, ratings, cancellations).
    """
    url = f"{BASE_URL}/{path.lstrip('/')}"
    total, num_batches = get_num_batches(session, path, params, limit)

    if total == 0:
        print(f"[{path}] 0 registros encontrados.", flush=True)
        return pd.DataFrame()

    # Bounded fetch for sequential child tables to avoid downloading infinite streaming data
    if max_trip_id is not None and path in ("payments", "ratings", "cancellations"):
        print(
            f"[{path}] Modo acotado por viajes 2024 (max_trip_id={max_trip_id:,}). "
            f"Evitando descarga del flujo en tiempo real (total API: {total:,}, hilos: {concurrency}).",
            flush=True,
        )

        all_items: list[dict] = []
        offset = 0
        start_time = time.time()
        chunk_batch_count = concurrency

        while offset < total:
            chunk_offsets = [
                offset + i * limit
                for i in range(chunk_batch_count)
                if offset + i * limit < total
            ]
            if not chunk_offsets:
                break

            with ThreadPoolExecutor(max_workers=concurrency) as executor:
                future_to_offset = {
                    executor.submit(
                        fetch_batch, session, url, params, off, limit
                    ): off
                    for off in chunk_offsets
                }
                chunk_results: dict[int, list[dict]] = {}
                for future in as_completed(future_to_offset):
                    off = future_to_offset[future]
                    chunk_results[off] = future.result()

            reached_boundary = False
            for off in sorted(chunk_results.keys()):
                items = chunk_results[off]
                if not items:
                    reached_boundary = True
                    break

                valid = [it for it in items if it.get("trip_id", 0) <= max_trip_id]
                all_items.extend(valid)

                if len(valid) < len(items):
                    reached_boundary = True
                    break

            offset += len(chunk_offsets) * limit
            elapsed = max(time.time() - start_time, 0.001)
            rate = len(all_items) / elapsed
            print(
                f"  [{path}] Registros recolectados: {len(all_items):,} "
                f"| Offset: {offset:,} | {rate:,.0f} reg/s | {format_time(elapsed)} transcurrido",
                flush=True,
            )

            if reached_boundary:
                print(
                    f"  -> Límite temporal 2024 alcanzado para /{path}. Deteniendo paginación.",
                    flush=True,
                )
                break

        elapsed = time.time() - start_time
        print(
            f"✅ [{path}] Descarga acotada completada en {elapsed:.2f}s "
            f"({len(all_items):,} filas 2024, {len(all_items) / max(elapsed, 0.01):.1f} reg/s)\n",
            flush=True,
        )
        return pd.DataFrame(all_items)

    # Standard paginated extraction with real-time ETA and rate logging
    print(
        f"[{path}] Total registros: {total:,} en {num_batches} lotes "
        f"(límite: {limit:,}, hilos: {concurrency})",
        flush=True,
    )

    offsets = [i * limit for i in range(num_batches)]
    batch_results: dict[int, list[dict]] = {}

    start_time = time.time()
    if num_batches == 1:
        items = fetch_batch(session, url, params, 0, limit)
        print_progress(path, 1, 1, len(items), total, start_time, is_final=True)
        return pd.DataFrame(items)

    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        future_to_offset = {
            executor.submit(
                fetch_batch, session, url, params, offset, limit
            ): offset
            for offset in offsets
        }

        completed = 0
        items_count = 0
        for future in as_completed(future_to_offset):
            offset = future_to_offset[future]
            items = future.result()
            batch_results[offset] = items
            completed += 1
            items_count += len(items)
            print_progress(
                path,
                completed,
                num_batches,
                items_count,
                total,
                start_time,
                is_final=(completed == num_batches),
            )

    elapsed = time.time() - start_time
    print(
        f"  -> Descarga /{path} finalizada en {format_time(elapsed)} "
        f"({total / max(elapsed, 0.01):.1f} reg/s)",
        flush=True,
    )

    ordered_items = []
    for offset in sorted(batch_results.keys()):
        ordered_items.extend(batch_results[offset])

    if not ordered_items:
        return pd.DataFrame()

    return pd.DataFrame(ordered_items)


def main():
    parser = argparse.ArgumentParser(description="MoviGo 2024 Data Extraction Pipeline")
    parser.add_argument("--only", type=str, help="Descargar únicamente un endpoint (ej. --only weather)")
    parser.add_argument("--skip-existing", action="store_true", help="Saltar datasets que ya existen en pipeline/data/raw/")
    parser.add_argument("--force", action="store_true", help="Forzar re-descarga de todos los datasets")
    args = parser.parse_args()

    RAW_FOLDER.mkdir(parents=True, exist_ok=True)

    print("=" * 70, flush=True)
    print("MoviGo High-Throughput 2024 Data Extraction Pipeline", flush=True)
    print("=" * 70, flush=True)

    session = create_session(DEFAULT_CONCURRENCY)

    try:
        openapi_url = f"{BASE_URL.rsplit('/', 1)[0]}/openapi.json"
        res = session.get(openapi_url, timeout=15)
        if res.status_code == 200:
            (RAW_FOLDER / "openapi.json").write_text(res.text, encoding="utf-8")
            print("✅ openapi.json actualizado con la especificación de la API", flush=True)
    except Exception as e:
        print(f"⚠️ No se pudo actualizar openapi.json: {e}", flush=True)

    valid_trip_ids: set[int] | None = None
    max_trip_id: int | None = None

    # Load existing trip_ids if trips already saved
    trips_file = RAW_FOLDER / "trips.parquet"
    if trips_file.exists():
        try:
            trips_df = pd.read_parquet(trips_file, columns=["trip_id"])
            valid_trip_ids = set(int(x) for x in trips_df["trip_id"].tolist())
            max_trip_id = max(valid_trip_ids)
        except Exception:
            pass

    for endpoint, filename, params, limit, ep_concurrency in ENDPOINTS:
        if args.only and endpoint != args.only:
            continue

        dest_file = RAW_FOLDER / filename
        if args.skip_existing and dest_file.exists() and not args.force:
            print(f"⏩ Saltando /{endpoint} ('{dest_file.name}' ya existe)", flush=True)
            continue

        print(f"\nIniciando extracción para: /{endpoint}", flush=True)
        ep_session = create_session(ep_concurrency)
        df = get_data(ep_session, endpoint, params, limit, ep_concurrency, max_trip_id=max_trip_id)

        if endpoint == "trips" and not df.empty and "trip_id" in df.columns:
            valid_trip_ids = set(int(x) for x in df["trip_id"].tolist())
            max_trip_id = max(valid_trip_ids)
            print(
                f"  -> Identificados {len(valid_trip_ids):,} viajes válidos para 2024 "
                f"(max_trip_id={max_trip_id:,}).",
                flush=True,
            )

        if (
            valid_trip_ids is not None
            and endpoint in ("payments", "ratings", "cancellations")
            and "trip_id" in df.columns
        ):
            orig_len = len(df)
            df = df[df["trip_id"].isin(valid_trip_ids)]
            discarded = orig_len - len(df)
            if discarded > 0:
                print(
                    f"  -> Filtrados {len(df):,} registros pertenecientes a viajes de 2024 "
                    f"(descartados {discarded:,} registros fuera de 2024)",
                    flush=True,
                )

        if not df.empty:
            df.to_parquet(dest_file, index=False)
            print(f"✅ Guardado /{endpoint} en '{dest_file.name}' ({len(df):,} filas)", flush=True)
        else:
            print(f"⚠️ Dataset vacío para /{endpoint}, no se sobreescribió.", flush=True)

    print("\n" + "=" * 70, flush=True)
    print("🎉 Extracción finalizada con éxito.", flush=True)
    print("=" * 70, flush=True)


if __name__ == "__main__":
    main()
