import os
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from math import ceil
from pathlib import Path

import pandas as pd
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
BASE_URL = os.getenv("API_URL")
if not BASE_URL:
    raise ValueError(
        "Environment variable 'API_URL' is required. Please set it in your .env file."
    )

BASE_URL = BASE_URL.rstrip("/")
MAX_LIMIT = int(os.getenv("MAX_LIMIT", "200"))
RAW_FOLDER = Path(os.getenv("RAW_DATA_DIR", BASE_DIR / "data" / "raw"))
CONCURRENCY = int(os.getenv("FETCH_CONCURRENCY", "20"))


def get_num_batches(path: str) -> tuple[int, int]:
    """Request metadata to calculate total items and batch count."""
    url = f"{BASE_URL}/{path.lstrip('/')}"
    res = requests.get(url, params={"limit": 1}, timeout=30).json()
    total: int = res.get("total", 0)
    num_batches = ceil(total / MAX_LIMIT) if total > 0 else 0
    return total, num_batches


def fetch_batch(url: str, offset: int, limit: int, retries: int = 3) -> list[dict]:
    """Fetch a single paginated batch with retry mechanism."""
    for attempt in range(retries):
        try:
            res = requests.get(
                url, params={"offset": offset, "limit": limit}, timeout=30
            )
            if res.status_code == 200:
                return res.json().get("items", [])
            elif res.status_code == 422:
                # Handle possible edge limits
                break
        except Exception:
            if attempt == retries - 1:
                raise
            time.sleep(0.5 * (attempt + 1))
    return []


def get_data(path: str) -> pd.DataFrame:
    """Fetch paginated data for an endpoint using concurrent workers."""
    url = f"{BASE_URL}/{path.lstrip('/')}"
    total, num_batches = get_num_batches(path)
    print(
        f"[{path}] Total registros: {total:,} en {num_batches} lotes (límite: {MAX_LIMIT}, hilos: {CONCURRENCY})"
    )

    if total == 0:
        return pd.DataFrame()

    offsets = [i * MAX_LIMIT for i in range(num_batches)]
    batch_results: dict[int, list[dict]] = {}

    start_time = time.time()
    with ThreadPoolExecutor(max_workers=CONCURRENCY) as executor:
        future_to_offset = {
            executor.submit(fetch_batch, url, offset, MAX_LIMIT): offset
            for offset in offsets
        }

        completed = 0
        for future in as_completed(future_to_offset):
            offset = future_to_offset[future]
            items = future.result()
            batch_results[offset] = items
            completed += 1
            if completed % 100 == 0 or completed == num_batches:
                pct = (completed / num_batches) * 100
                print(
                    f"  -> Progreso /{path}: {completed}/{num_batches} lotes ({pct:.1f}%)"
                )

    elapsed = time.time() - start_time
    print(f"  -> Descarga completada en {elapsed:.2f}s ({total / max(elapsed, 0.01):.1f} reg/s)")

    # Reassemble in deterministic offset order
    ordered_items = []
    for offset in sorted(batch_results.keys()):
        ordered_items.extend(batch_results[offset])

    if not ordered_items:
        return pd.DataFrame()

    return pd.DataFrame(ordered_items)


def main():
    RAW_FOLDER.mkdir(parents=True, exist_ok=True)

    # 13 MoviGo collection endpoints (Normalized 3NF API)
    endpoints = [
        ("zones", "urban_zones.parquet"),
        ("quadrants", "quadrants.parquet"),
        ("users", "users.parquet"),
        ("drivers", "drivers.parquet"),
        ("vehicles", "vehicles.parquet"),
        ("campaigns", "incentive_campaigns.parquet"),
        ("weather", "quadrant_weather.parquet"),
        ("trips", "trips.parquet"),
        ("payments", "trip_payments.parquet"),
        ("ratings", "trip_ratings.parquet"),
        ("cancellations", "trip_cancellations.parquet"),
        ("telemetry", "driver_telemetry.parquet"),
        ("maintenance", "vehicle_maintenance.parquet"),
    ]

    for endpoint, filename in endpoints:
        print(f"\nIniciando extracción para: /{endpoint}")
        df = get_data(endpoint)
        dest_file = RAW_FOLDER / filename
        df.to_parquet(dest_file, index=False)
        print(f"✅ Guardado /{endpoint} en '{dest_file}' ({len(df):,} filas)")


if __name__ == "__main__":
    main()
