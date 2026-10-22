import os
from math import ceil
from pathlib import Path

import pandas as pd
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("MOVIGO_API_URL", "http://4.157.251.192:8000/movigo")
MAX_LIMIT = int(os.getenv("MAX_LIMIT", "200"))
RAW_FOLDER = Path(os.getenv("RAW_DATA_DIR", "./data/raw"))


def get_num_batches(path: str) -> tuple[int, int]:
    """Request metadata to calculate total items and batch count."""
    url = f"{BASE_URL}{path}"
    res = requests.get(url, params={"limit": 1}, timeout=30).json()
    total: int = res.get("total", 0)
    num_batches = ceil(total / MAX_LIMIT) if total > 0 else 0
    return total, num_batches


def get_data(path: str) -> pd.DataFrame:
    """Fetch paginated data for an endpoint and return consolidated DataFrame."""
    total, num_batches = get_num_batches(path)
    print(f"[{path}] Total registros: {total:,} en {num_batches} lotes (límite por lote: {MAX_LIMIT})")

    if total == 0:
        return pd.DataFrame()

    dfs = []
    for i in range(num_batches):
        offset = i * MAX_LIMIT
        params = {"offset": offset, "limit": MAX_LIMIT}

        print(f"  -> Lote {i + 1}/{num_batches} de {path} (offset: {offset}, limit: {MAX_LIMIT})")
        res = requests.get(f"{BASE_URL}{path}", params=params, timeout=30).json()

        items = res.get("items", [])
        if items:
            dfs.append(pd.DataFrame(items))

    if not dfs:
        return pd.DataFrame()

    return pd.concat(dfs, ignore_index=True)


def main():
    RAW_FOLDER.mkdir(parents=True, exist_ok=True)

    # Lista de endpoints de MoviGo (excluyendo /viajes/{id_viaje} individual)
    endpoints = [
        ("zonas", "zonas.parquet"),
        ("usuarios", "usuarios.parquet"),
        ("conductores", "conductores.parquet"),
        ("campanas", "campanas.parquet"),
        ("clima", "clima.parquet"),
        ("viajes", "viajes.parquet"),
        ("telemetria", "telemetria.parquet"),
    ]

    for endpoint, filename in endpoints:
        print(f"\nIniciando extracción para: /{endpoint}")
        try:
            df = get_data(f"/{endpoint}")
            dest_file = RAW_FOLDER / filename
            df.to_parquet(dest_file, index=False)
            print(f"✅ Guardado /{endpoint} en '{dest_file}' ({len(df):,} filas)")
        except Exception as e:
            print(f"❌ Error al extraer /{endpoint}: {e}")


if __name__ == "__main__":
    main()
