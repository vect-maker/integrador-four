import os
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from math import ceil
from pathlib import Path

import pandas as pd
import requests
from dotenv import load_dotenv
from requests.adapters import HTTPAdapter

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
BASE_URL = os.getenv("API_URL")
if not BASE_URL:
    raise ValueError(
        "Environment variable 'API_URL' is required. Please set it in your .env file."
    )

BASE_URL = BASE_URL.rstrip("/")
RAW_FOLDER = Path(os.getenv("RAW_DATA_DIR", BASE_DIR / "data" / "raw"))
CONCURRENCY = int(os.getenv("FETCH_CONCURRENCY", "4"))

# Configure endpoints: (endpoint_path, parquet_filename, query_params, page_limit)
ENDPOINTS = [
    ("zones", "urban_zones.parquet", {}, 1000),
    ("quadrants", "quadrants.parquet", {}, 1000),
    ("users", "users.parquet", {}, 2000),
    ("drivers", "drivers.parquet", {}, 1000),
    ("vehicles", "vehicles.parquet", {}, 1000),
    ("campaigns", "incentive_campaigns.parquet", {}, 1000),
    (
        "weather",
        "quadrant_weather.parquet",
        {"date_from": "2024-01-01", "date_to": "2024-12-31"},
        10000,
    ),
    (
        "trips",
        "trips.parquet",
        {"end_time": "2024-12-31T23:59:59"},
        5000,
    ),
    ("payments", "trip_payments.parquet", {}, 5000),
    ("ratings", "trip_ratings.parquet", {}, 5000),
    ("cancellations", "trip_cancellations.parquet", {}, 5000),
    (
        "telemetry",
        "driver_telemetry.parquet",
        {"end_time": "2024-12-31T23:59:59"},
        10000,
    ),
    (
        "maintenance",
        "vehicle_maintenance.parquet",
        {"end_date": "2024-12-31"},
        1000,
    ),
]


def create_session() -> requests.Session:
    session = requests.Session()
    adapter = HTTPAdapter(
        pool_connections=CONCURRENCY + 2,
        pool_maxsize=CONCURRENCY + 2,
        max_retries=3,
    )
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    return session


def get_num_batches(
    session: requests.Session, path: str, params: dict, limit: int
) -> tuple[int, int]:
    """Request metadata to calculate total items and batch count."""
    url = f"{BASE_URL}/{path.lstrip('/')}"
    p = params.copy()
    p["limit"] = 1
    for attempt in range(4):
        try:
            res = session.get(url, params=p, timeout=20)
            if res.status_code == 200:
                total: int = res.json().get("total", 0)
                num_batches = ceil(total / limit) if total > 0 else 0
                return total, num_batches
        except Exception:
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
            res = session.get(url, params=p, timeout=30)
            if res.status_code == 200:
                return res.json().get("items", [])
            elif res.status_code == 422:
                break
        except Exception:
            pass
        time.sleep(0.5 * (attempt + 1))
    return []


def get_data(
    session: requests.Session, path: str, params: dict, limit: int
) -> pd.DataFrame:
    """Fetch paginated data for an endpoint using controlled concurrent workers."""
    url = f"{BASE_URL}/{path.lstrip('/')}"
    total, num_batches = get_num_batches(session, path, params, limit)
    print(
        f"[{path}] Total registros: {total:,} en {num_batches} lotes (límite: {limit:,}, hilos: {CONCURRENCY})"
    )

    if total == 0:
        return pd.DataFrame()

    offsets = [i * limit for i in range(num_batches)]
    batch_results: dict[int, list[dict]] = {}

    start_time = time.time()
    # Single batch fast-path
    if num_batches == 1:
        items = fetch_batch(session, url, params, 0, limit)
        return pd.DataFrame(items)

    with ThreadPoolExecutor(max_workers=CONCURRENCY) as executor:
        future_to_offset = {
            executor.submit(
                fetch_batch, session, url, params, offset, limit
            ): offset
            for offset in offsets
        }

        completed = 0
        for future in as_completed(future_to_offset):
            offset = future_to_offset[future]
            items = future.result()
            batch_results[offset] = items
            completed += 1
            if completed % 10 == 0 or completed == num_batches:
                pct = (completed / num_batches) * 100
                print(
                    f"  -> Progreso /{path}: {completed}/{num_batches} lotes ({pct:.1f}%)"
                )

    elapsed = time.time() - start_time
    print(
        f"  -> Descarga completada en {elapsed:.2f}s ({total / max(elapsed, 0.01):.1f} reg/s)"
    )

    # Reassemble in deterministic offset order
    ordered_items = []
    for offset in sorted(batch_results.keys()):
        ordered_items.extend(batch_results[offset])

    if not ordered_items:
        return pd.DataFrame()

    return pd.DataFrame(ordered_items)


def main():
    RAW_FOLDER.mkdir(parents=True, exist_ok=True)
    session = create_session()

    print("=" * 70)
    print("MoviGo High-Throughput 2024 Data Extraction Pipeline")
    print("=" * 70)

    valid_trip_ids = None

    for endpoint, filename, params, limit in ENDPOINTS:
        print(f"\nIniciando extracción para: /{endpoint}")
        df = get_data(session, endpoint, params, limit)
        dest_file = RAW_FOLDER / filename

        if endpoint == "trips" and not df.empty and "trip_id" in df.columns:
            valid_trip_ids = [int(x) for x in df["trip_id"].tolist()]

        # Enforce relational integrity for 2024 trips child datasets
        if valid_trip_ids is not None and endpoint in ("payments", "ratings", "cancellations") and "trip_id" in df.columns:
            orig_len = len(df)
            df = df[df["trip_id"].isin(valid_trip_ids)]
            print(f"  -> Filtrados {len(df):,} registros pertenecientes a viajes de 2024 (descartados {orig_len - len(df):,} post-2024)")

        df.to_parquet(dest_file, index=False)
        print(f"✅ Guardado /{endpoint} en '{dest_file.name}' ({len(df):,} filas)")

    print("\n" + "=" * 70)
    print("🎉 Extracción completa de todos los datasets 2024 finalizada con éxito.")
    print("=" * 70)


if __name__ == "__main__":
    main()
