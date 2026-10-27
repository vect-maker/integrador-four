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
            SELECT cast(longitud_origen as double), cast(latitud_origen as double)
            FROM fct_viajes
            WHERE es_completado = true
              AND latitud_origen BETWEEN 12.080 AND 12.180
              AND longitud_origen BETWEEN -86.330 AND -86.190;
        """).fetchall()

        cancelled_coords = con.execute("""
            SELECT cast(longitud_origen as double), cast(latitud_origen as double)
            FROM fct_viajes
            WHERE es_cancelado = true
              AND latitud_origen BETWEEN 12.080 AND 12.180
              AND longitud_origen BETWEEN -86.330 AND -86.190;
        """).fetchall()

        # 2. Fetch urban zones catalog
        zones_rows = con.execute("""
            SELECT 
                cast(id_zona as int) as id_zona,
                cast(nombre_zona as varchar) as nombre_zona,
                cast(estrato_socioeconomico as varchar) as estrato,
                cast(latitud as double) as latitud,
                cast(longitud as double) as longitud
            FROM dim_zonas
            ORDER BY id_zona;
        """).fetchall()

        # 3. Zone demand metrics aggregation
        zone_metrics_rows = con.execute("""
            SELECT 
                z.id_zona,
                z.nombre_zona,
                z.estrato_socioeconomico,
                count(v.id_viaje) as total_solicitudes,
                sum(case when v.es_completado then 1 else 0 end) as completados,
                sum(case when v.es_cancelado then 1 else 0 end) as cancelados,
                round(cast(sum(case when v.es_cancelado then 1 else 0 end) as double) * 100.0 / nullif(count(v.id_viaje), 0), 2) as tasa_cancelacion_pct
            FROM dim_zonas z
            LEFT JOIN fct_viajes v ON z.sk_zona = v.sk_zona_origen
            GROUP BY z.id_zona, z.nombre_zona, z.estrato_socioeconomico
            ORDER BY total_solicitudes DESC;
        """).fetchall()
    finally:
        con.close()

    comp_lons = [r[0] for r in completed_coords]
    comp_lats = [r[1] for r in completed_coords]
    canc_lons = [r[0] for r in cancelled_coords]
    canc_lats = [r[1] for r in cancelled_coords]

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

    # 2. Plot Completed Trip Origins (High density, semi-transparent teal/blue)
    ax.scatter(
        comp_lons,
        comp_lats,
        s=4,
        c="#0077b6",
        alpha=0.18,
        label=f"Viajes Completados ({len(comp_lons):,})",
        zorder=2,
        rasterized=True,
    )

    # 3. Plot Cancelled Trip Origins (Vivid coral/crimson overlay)
    ax.scatter(
        canc_lons,
        canc_lats,
        s=6,
        c="#d62828",
        alpha=0.35,
        label=f"Viajes Cancelados ({len(canc_lons):,})",
        zorder=3,
        rasterized=True,
    )

    # 4. Stratum colors for Zone Centers
    stratum_colors = {
        "alto": "#1d3557",
        "medio": "#2a9d8f",
        "comercial": "#e76f51",
        "popular": "#6a0572",
    }

    # 5. Plot Urban Zone Centroids and Labels
    for row in zones_rows:
        zid = int(row[0])
        zname = str(row[1]).split(" / ")[0]
        stratum = str(row[2]).lower()
        lat = float(row[3])
        lon = float(row[4])
        color = stratum_colors.get(stratum, "#333333")

        ax.scatter(
            [lon],
            [lat],
            s=120,
            c=color,
            edgecolors="#ffffff",
            linewidths=1.8,
            zorder=5,
        )

        ax.text(
            lon,
            lat + 0.0024,
            f"Z{zid}: {zname}",
            fontsize=7.5,
            fontweight="bold",
            ha="center",
            va="bottom",
            bbox=dict(
                boxstyle="round,pad=0.22",
                facecolor="white",
                edgecolor=color,
                alpha=0.92,
                linewidth=1.2,
            ),
            zorder=6,
        )

    # 6. Formatting and Metadata
    ax.set_title(
        "Distribución Geoespacial de Orígenes de Viajes en Managua (MoviGo 2024)",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9, fontweight="medium")
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9, fontweight="medium")

    # Legend
    legend = ax.legend(
        loc="upper right",
        frameon=True,
        facecolor="white",
        edgecolor="#b0bec5",
        framealpha=0.95,
        fontsize=8,
    )
    legend.set_zorder(10)
    ax.grid(True, linestyle="--", alpha=0.30)

    # Annotate summary box in bottom left
    total_samples = len(comp_lons) + len(canc_lons)
    cancellation_rate = (len(canc_lons) / total_samples) * 100 if total_samples > 0 else 0.0
    summary_text = (
        f"Muestras WGS84: {total_samples:,}\n"
        f"Completados: {len(comp_lons):,} ({100 - cancellation_rate:.1f}%)\n"
        f"Cancelaciones: {len(canc_lons):,} ({cancellation_rate:.1f}%)"
    )
    ax.text(
        0.02,
        0.03,
        summary_text,
        transform=ax.transAxes,
        fontsize=8,
        fontfamily="monospace",
        verticalalignment="bottom",
        bbox=dict(
            boxstyle="square,pad=0.5",
            facecolor="#f8f9fa",
            edgecolor="#adb5bd",
            alpha=0.92,
        ),
        zorder=10,
    )

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

    # Load Basemap and bounds if present
    basemap_img = None
    bounds = None
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
