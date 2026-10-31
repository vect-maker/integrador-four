#!/usr/bin/env python3
"""
MoviGo Spatial Trip Origin Density & Geographic Distribution Analysis
---------------------------------------------------------------------
Generates spatial visualization of trip origin GPS coordinates across
the urban quadrants and socio-economic zones of Managua, overlaid on
the pre-cached OpenStreetMap arterial basemap.

Outputs:
  - Image: typst/graphs/trip_origins_density.png (300 DPI)
  - Data:  typst/data/spatial_density_summary.json
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import duckdb
import matplotlib.pyplot as plt
from PIL import Image

BASE_DIR = Path(__file__).resolve().parent.parent.parent
DATA_DIR = BASE_DIR / "pipeline" / "data"
DUCKDB_PATH = DATA_DIR / "analytics.duckdb"
BASEMAP_PATH = DATA_DIR / "managua_basemap.png"
BOUNDS_PATH = DATA_DIR / "managua_basemap_bounds.json"
OUTPUT_GRAPH = BASE_DIR / "typst" / "graphs" / "trip_origins_density.png"
OUTPUT_JSON = BASE_DIR / "typst" / "data" / "spatial_density_summary.json"


def generate_density_plot(
    db_path: Path,
    output_path: Path,
    basemap_img: Image.Image | None = None,
    bounds: dict[str, float] | None = None,
) -> dict[str, Any]:
    """Generates a high-resolution spatial plot of trip origin coordinates overlaid on Managua basemap."""
    output_path.parent.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(db_path), read_only=True)
    try:
        # 1. Fetch completed and cancelled trip origins within valid Managua metropolitan bounds
        completed_coords = con.execute("""
            SELECT cast(origin_longitude as double), cast(origin_latitude as double)
            FROM fct_viajes
            WHERE is_completed = true
              AND origin_latitude BETWEEN 12.000 AND 12.200
              AND origin_longitude BETWEEN -86.360 AND -86.130;
        """).fetchall()

        cancelled_coords = con.execute("""
            SELECT cast(origin_longitude as double), cast(origin_latitude as double)
            FROM fct_viajes
            WHERE is_cancelled = true
              AND origin_latitude BETWEEN 12.000 AND 12.200
              AND origin_longitude BETWEEN -86.360 AND -86.130;
        """).fetchall()

        # 2. Fetch urban zones catalog
        zones_rows = con.execute("""
            SELECT 
                cast(zone_id as int) as id_zona,
                cast(zone_name as varchar) as nombre_zona,
                cast(socioeconomic_stratum as varchar) as estrato,
                cast(latitude as double) as latitud,
                cast(longitude as double) as longitud
            FROM dim_zones
            ORDER BY zone_id;
        """).fetchall()

        # 3. Zone demand metrics aggregation
        zone_metrics_rows = con.execute("""
            SELECT 
                z.zone_id as id_zona,
                z.zone_name as nombre_zona,
                z.socioeconomic_stratum as estrato_socioeconomico,
                count(v.trip_id) as total_solicitudes,
                sum(case when v.is_completed then 1 else 0 end) as completados,
                sum(case when v.is_cancelled then 1 else 0 end) as cancelados,
                round(cast(sum(case when v.is_cancelled then 1 else 0 end) as double) * 100.0 / nullif(count(v.trip_id), 0), 2) as tasa_cancelacion_pct
            FROM dim_zones z
            LEFT JOIN fct_viajes v ON z.sk_zone = v.sk_zone_origin
            GROUP BY z.zone_id, z.zone_name, z.socioeconomic_stratum
            ORDER BY total_solicitudes DESC;
        """).fetchall()
    finally:
        con.close()

    comp_lons = [r[0] for r in completed_coords]
    comp_lats = [r[1] for r in completed_coords]
    canc_lons = [r[0] for r in cancelled_coords]
    canc_lats = [r[1] for r in cancelled_coords]
    total_samples = len(comp_lons) + len(canc_lons)
    cancellation_rate = (len(canc_lons) / total_samples * 100.0) if total_samples > 0 else 0.0

    fig, ax = plt.subplots(figsize=(10, 8.5), dpi=300)

    # 1. Overlay OpenStreetMap Basemap
    if basemap_img is not None and bounds is not None:
        extent: tuple[float, float, float, float] = (
            bounds["west"],
            bounds["east"],
            bounds["south"],
            bounds["north"],
        )
        ax.imshow(
            basemap_img,
            extent=extent,
            origin="upper",
            alpha=0.65,
            zorder=0,
            aspect="equal",
        )
        ax.set_xlim(bounds["west"], bounds["east"])
        ax.set_ylim(bounds["south"], bounds["north"])
    else:
        ax.set_xlim(-86.325, -86.195)
        ax.set_ylim(12.080, 12.170)

    # 2. Plot Completed Trip Origins (High density, semi-transparent teal/blue, sharp arterial definition)
    ax.scatter(
        comp_lons,
        comp_lats,
        s=2.5,
        c="#0077b6",
        alpha=0.15,
        label="Viajes Completados",
        zorder=2,
        rasterized=True,
    )

    # 3. Plot Cancelled Trip Origins (Vivid coral/crimson overlay)
    ax.scatter(
        canc_lons,
        canc_lats,
        s=3.5,
        c="#d62828",
        alpha=0.30,
        label="Viajes Cancelados",
        zorder=3,
        rasterized=True,
    )

    # 4. Anti-collision label offsets for reference landmarks
    zone_label_offsets: dict[int, tuple[float, float, str, str]] = {
        1: (0.0000, -0.0030, "center", "top"),      # Villa Fontana
        6: (-0.0025, 0.0022, "right", "bottom"),    # Bolonia
        7: (0.0000, -0.0030, "center", "top"),      # Bello Horizonte
        8: (0.0000, 0.0028, "center", "bottom"),    # Linda Vista
        9: (0.0035, -0.0025, "left", "top"),        # Metrocentro
        11: (0.0000, 0.0028, "center", "bottom"),   # Mercado Oriental
    }

    # 5. Reference Landmarks (Orientation badges without extraneous dot clutter)
    landmark_zones = {1, 6, 7, 8, 9, 11}
    for row in zones_rows:
        zid = int(row[0])
        if zid not in landmark_zones:
            continue
        zname = str(row[1]).split(" / ")[0].replace("Mercado Oriental", "M. Oriental")
        lat = float(row[3])
        lon = float(row[4])
        dx, dy, ha, va = zone_label_offsets.get(zid, (0.0, 0.0028, "center", "bottom"))

        ax.text(
            lon + dx,
            lat + dy,
            f"Z{zid}: {zname}",
            fontsize=7.2,
            fontweight="bold",
            ha=ha,
            va=va,
            bbox=dict(
                boxstyle="round,pad=0.20",
                facecolor="white",
                edgecolor="#37474f",
                alpha=0.90,
                linewidth=0.8,
            ),
            zorder=6,
        )

    # 6. Clean Coordinates Formatting
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5, fontweight="medium")
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5, fontweight="medium")

    # Legend
    legend = ax.legend(
        loc="upper right",
        frameon=True,
        facecolor="white",
        edgecolor="#b0bec5",
        framealpha=0.95,
        fontsize=8.5,
    )
    legend.set_zorder(10)
    ax.grid(True, linestyle="--", alpha=0.30)

    plt.tight_layout()
    plt.savefig(output_path, format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Gráfico de densidad espacial guardado en: {output_path}")

    zone_metrics = []
    for r in zone_metrics_rows:
        zone_metrics.append({
            "id_zona": int(r[0]),
            "nombre_zona": str(r[1]),
            "estrato": str(r[2]),
            "total_solicitudes": int(r[3]),
            "completados": int(r[4]),
            "cancelados": int(r[5]),
            "tasa_cancelacion_pct": float(r[6]) if r[6] is not None else 0.0,
        })

    summary_data = {
        "total_viajes_analizados": total_samples,
        "total_completados": len(comp_lons),
        "total_cancelados": len(canc_lons),
        "tasa_cancelacion_global_pct": round(float(cancellation_rate), 2),
        "distribucion_zonas": zone_metrics,
    }

    return summary_data


def main() -> None:
    print("Iniciando generación de mapa geoespacial de viajes...")

    if not DUCKDB_PATH.exists():
        print(f"Error: DuckDB snapshot '{DUCKDB_PATH}' no existe. Ejecute 'just duckdb-snapshot'.")
        return

    # Load Basemap and bounds (auto-generating if missing)
    basemap_img = None
    bounds = None
    if not (BASEMAP_PATH.exists() and BOUNDS_PATH.exists()):
        try:
            from pipeline.analysis.cache_basemap import cache_basemap
            print("Basemap no encontrado. Descargando y costurando teselas de OpenStreetMap...")
            cache_basemap()
        except Exception as exc:
            print(f"Aviso: No se pudo auto-generar el basemap ({exc}).")

    if BASEMAP_PATH.exists() and BOUNDS_PATH.exists():
        basemap_img = Image.open(BASEMAP_PATH)
        with open(BOUNDS_PATH, "r", encoding="utf-8") as f:
            bounds = json.load(f)
        print(f"Basemap cargado desde: {BASEMAP_PATH}")
    else:
        print("Aviso: Basemap no encontrado, graficando sobre plano vectorial.")

    summary = generate_density_plot(
        DUCKDB_PATH,
        OUTPUT_GRAPH,
        basemap_img=basemap_img,
        bounds=bounds,
    )

    OUTPUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    print(f"✅ Resumen JSON guardado en: {OUTPUT_JSON}")


if __name__ == "__main__":
    main()
