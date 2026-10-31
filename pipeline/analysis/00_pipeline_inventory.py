#!/usr/bin/env python3
"""
MoviGo Pipeline Inventory & Integrity Audit (Objective 1 evidence)
------------------------------------------------------------------
Summarizes the analytical repository produced by the ELT pipeline:
  - Row counts of the fact table and conformed dimensions (DuckDB snapshot).
  - Referential and key integrity checks computed directly on the snapshot.
  - dbt project inventory (models and declarative tests) read from the
    compiled manifest (pipeline/dbt/target/manifest.json).

Outputs:
  - Data: typst/data/pipeline_inventory.json
"""

from __future__ import annotations

import json
from collections import Counter
from pathlib import Path
from typing import Any

import duckdb

BASE_DIR = Path(__file__).resolve().parent.parent.parent
DUCKDB_PATH = BASE_DIR / "pipeline" / "data" / "analytics.duckdb"
MANIFEST_PATH = BASE_DIR / "pipeline" / "dbt" / "target" / "manifest.json"
OUTPUT_JSON = BASE_DIR / "typst" / "data" / "pipeline_inventory.json"

FACT = "fct_viajes"
DIMENSIONS = [
    "dim_zones",
    "dim_quadrants",
    "dim_weather",
    "dim_users",
    "dim_drivers",
    "dim_campaigns",
]

# (fact foreign key, dimension, dimension primary key)
FOREIGN_KEYS = [
    ("sk_zone_origin", "dim_zones", "sk_zone"),
    ("sk_zone_destination", "dim_zones", "sk_zone"),
    ("sk_user", "dim_users", "sk_user"),
    ("sk_driver", "dim_drivers", "sk_driver"),
    ("sk_weather", "dim_weather", "sk_weather"),
]

ANALYTIC_COLUMNS = ["distance_km", "duration_minutes", "final_fare", "surge_multiplier"]


def scalar(con: duckdb.DuckDBPyConnection, sql: str) -> int:
    row = con.execute(sql).fetchone()
    assert row is not None
    return int(row[0])


def audit_warehouse() -> dict[str, Any]:
    con = duckdb.connect(str(DUCKDB_PATH), read_only=True)
    try:
        rows = {t: scalar(con, f"SELECT COUNT(*) FROM {t}") for t in [FACT, *DIMENSIONS]}

        orphans = {
            fk: scalar(
                con,
                f"SELECT COUNT(*) FROM {FACT} f LEFT JOIN {dim} d ON f.{fk} = d.{pk} "
                f"WHERE f.{fk} IS NOT NULL AND d.{pk} IS NULL",
            )
            for fk, dim, pk in FOREIGN_KEYS
        }
        null_keys = {
            fk: scalar(con, f"SELECT COUNT(*) FROM {FACT} WHERE {fk} IS NULL")
            for fk, _, _ in FOREIGN_KEYS
        }
        null_metrics = {
            c: scalar(con, f"SELECT COUNT(*) FROM {FACT} WHERE {c} IS NULL")
            for c in ANALYTIC_COLUMNS
        }
        duplicated_trips = rows[FACT] - scalar(
            con, f"SELECT COUNT(DISTINCT sk_trip) FROM {FACT}"
        )
    finally:
        con.close()

    return {
        "rows": rows,
        "integrity": {
            "duplicated_trip_keys": duplicated_trips,
            "orphan_foreign_keys": orphans,
            "null_foreign_keys": null_keys,
            "null_analytic_metrics": null_metrics,
            "total_orphans": sum(orphans.values()),
            "total_null_keys": sum(null_keys.values()),
            "total_null_metrics": sum(null_metrics.values()),
        },
    }


def audit_dbt() -> dict[str, Any]:
    manifest = json.loads(MANIFEST_PATH.read_text())
    nodes = manifest["nodes"].values()
    models = [n for n in nodes if n["resource_type"] == "model"]
    tests = [n for n in nodes if n["resource_type"] == "test"]
    by_type = Counter(n.get("test_metadata", {}).get("name", "custom") for n in tests)
    return {
        "staging_models": sum(1 for m in models if "staging" in m["path"]),
        "mart_models": sum(1 for m in models if "marts" in m["path"]),
        "total_tests": len(tests),
        "tests_by_type": dict(by_type),
    }


def main() -> None:
    inventory = {"warehouse": audit_warehouse(), "dbt": audit_dbt()}
    OUTPUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_JSON.write_text(json.dumps(inventory, indent=2, ensure_ascii=False))
    print(f"✅ Pipeline inventory exported to {OUTPUT_JSON}")


if __name__ == "__main__":
    main()
