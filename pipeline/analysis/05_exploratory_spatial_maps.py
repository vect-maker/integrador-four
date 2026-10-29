#!/usr/bin/env python3
"""
MoviGo Exploratory Spatial Maps Suite
-------------------------------------
Generates 5 publication-ready 300 DPI exploratory geospatial maps of Managua:
  1. map_exploratory_quadrants_by_zone.png:
     The 298 urban quadrants tiled and categorized across the 24 platform zones.
  2. map_exploratory_od_flows.png:
     Top 25 origin-destination mobility corridors and travel desire vectors.
  3. map_exploratory_cancellation_causes.png:
     Spatial distribution of cancelled trips across 4 macro-causal mechanisms.
  4. map_exploratory_flood_risk_quadrants.png:
     Hydrological flood risk across the 298 quadrants (critical to low) and drainage.
  5. map_exploratory_wait_times.png:
     Pickup latency and temporal service accessibility gaps across the 24 zones.

Outputs:
  - Figures: typst/graphs/map_exploratory_*.png (300 DPI)
  - Metrics: typst/data/exploratory_spatial_kpis.json
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import duckdb
import matplotlib.patches as patches
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.axes import Axes
from PIL import Image

# Directory constants
ROOT_DIR = Path(__file__).resolve().parent.parent.parent
DATA_DIR = ROOT_DIR / "pipeline" / "data"
DUCKDB_PATH = DATA_DIR / "analytics.duckdb"
BASEMAP_PATH = DATA_DIR / "managua_basemap.png"
BOUNDS_PATH = DATA_DIR / "managua_basemap_bounds.json"
GRAPHS_DIR = ROOT_DIR / "typst" / "graphs"
OUTPUT_JSON_PATH = ROOT_DIR / "typst" / "data" / "exploratory_spatial_kpis.json"

# Curated palette of 24 distinct, high-contrast colors for the 24 urban zones
ZONE_24_PALETTE = [
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf",
    "#393b79", "#637939", "#8c6d31", "#843c39", "#7b4173",
    "#5254a3", "#8ca252", "#bd9e39", "#ad494a", "#a55194",
    "#6b6ecf", "#b5cf6b", "#e7ba52", "#de9ed6"
]

# Anti-collision label offsets for the 24 urban zones
ZONE_LABEL_OFFSETS: dict[int, tuple[float, float, str, str]] = {
    # zone_id: (dx, dy, ha, va)
    1: (0.0000, -0.0030, "center", "top"),      # Villa Fontana
    2: (-0.0020, -0.0025, "right", "top"),      # Las Colinas
    3: (0.0025, 0.0022, "left", "bottom"),      # Santo Domingo
    4: (-0.0035, 0.0025, "right", "bottom"),    # Los Robles (Northwest)
    5: (0.0030, 0.0010, "left", "center"),      # Altamira (East)
    6: (-0.0025, 0.0022, "right", "bottom"),    # Bolonia
    7: (0.0000, -0.0030, "center", "top"),      # Bello Horizonte (South)
    8: (0.0000, 0.0028, "center", "bottom"),    # Linda Vista
    9: (0.0035, -0.0025, "left", "top"),        # Metrocentro (Southeast)
    10: (0.0000, 0.0028, "center", "bottom"),   # Ciudad Jardín
    11: (0.0000, 0.0028, "center", "bottom"),   # Mercado Oriental
    12: (0.0020, -0.0028, "left", "top"),       # Mercado Roberto Huembes
    13: (-0.0025, 0.0025, "right", "bottom"),   # Monseñor Lezcano
    14: (0.0000, 0.0028, "center", "bottom"),   # Puerto Salvador Allende
    15: (-0.0025, -0.0022, "right", "top"),     # Altagracia
    16: (0.0000, -0.0030, "center", "top"),     # San Judas (South)
    17: (0.0000, 0.0028, "center", "bottom"),   # Carretera Sur
    18: (0.0000, 0.0028, "center", "bottom"),   # Esquipulas
    19: (0.0000, 0.0030, "center", "bottom"),   # Multicentro (North)
    20: (0.0025, 0.0022, "left", "bottom"),     # Mercado El Mayoreo (North)
    21: (0.0000, 0.0028, "center", "bottom"),   # Aeropuerto
    22: (0.0000, -0.0028, "center", "top"),     # Primero de Mayo
    23: (0.0020, -0.0025, "left", "top"),       # Villa Libertad (South)
    24: (0.0000, 0.0028, "center", "bottom"),   # Sabana Grande
}


def clean_zone_name(raw_name: str) -> str:
    """Produces compact, legible names for map labels without overlaps."""
    name = raw_name.split(" / ")[0]
    replacements = {
        "Multicentro Las Américas": "Multicentro",
        "Aeropuerto Augusto C. Sandino": "Aeropuerto Sandino",
        "Colonia Primero de Mayo": "Primero de Mayo",
        "Puerto Salvador Allende": "Salvador Allende",
    }
    for old, new in replacements.items():
        name = name.replace(old, new)
    return name


def load_basemap() -> tuple[Image.Image | None, dict[str, float] | None]:
    """Loads pre-cached OpenStreetMap basemap and bounding metadata."""
    if not (BASEMAP_PATH.exists() and BOUNDS_PATH.exists()):
        try:
            from pipeline.analysis.cache_basemap import cache_basemap
            print("Basemap not found. Pre-caching OpenStreetMap tiles...")
            cache_basemap()
        except Exception as exc:
            print(f"Warning: Could not auto-generate basemap ({exc}).")

    if BASEMAP_PATH.exists() and BOUNDS_PATH.exists():
        img = Image.open(BASEMAP_PATH).convert("RGB")
        with open(BOUNDS_PATH, "r", encoding="utf-8") as f:
            bounds = json.load(f)
        return img, bounds
    return None, None


def apply_basemap(ax: Axes, basemap_img: Image.Image | None, bounds: dict[str, float] | None) -> None:
    """Overlays the basemap onto matplotlib Axes if available."""
    if basemap_img is not None and bounds is not None:
        extent = (bounds["west"], bounds["east"], bounds["south"], bounds["north"])
        ax.imshow(
            basemap_img,
            extent=extent,
            alpha=0.58,
            zorder=0,
            aspect="equal",
        )
        ax.set_xlim(bounds["west"], bounds["east"])
        ax.set_ylim(bounds["south"], bounds["north"])
    else:
        ax.set_xlim(-86.350, -86.135)
        ax.set_ylim(12.020, 12.185)


# -----------------------------------------------------------------------------
# 1. Mapa de Partición Territorial: 298 Cuadrantes Coloreados por Zona
# -----------------------------------------------------------------------------
def plot_quadrants_by_zone(
    con: duckdb.DuckDBPyConnection,
    output_path: Path,
    basemap_img: Image.Image | None,
    bounds: dict[str, float] | None,
) -> dict[str, Any]:
    """Renders all 298 quadrants tiled and colored by their parent zone ID."""
    quadrants = con.execute("""
        SELECT 
            quadrant_id,
            zone_id,
            zone_name,
            district,
            cast(lat_min as double) as lat_min,
            cast(lat_max as double) as lat_max,
            cast(lon_min as double) as lon_min,
            cast(lon_max as double) as lon_max
        FROM dim_quadrants
        ORDER BY zone_id, quadrant_id;
    """).fetchall()

    zones = con.execute("""
        SELECT 
            zone_id,
            zone_name,
            district,
            socioeconomic_stratum,
            cast(latitude as double) as lat,
            cast(longitude as double) as lon
        FROM dim_zones
        ORDER BY zone_id;
    """).fetchall()

    fig, ax = plt.subplots(figsize=(11.0, 8.5), dpi=300)
    apply_basemap(ax, basemap_img, bounds)

    # 1. Draw 298 quadrant rectangles colored by zone
    for q in quadrants:
        zid = int(q[1])
        color = ZONE_24_PALETTE[(zid - 1) % len(ZONE_24_PALETTE)]
        lon_min, lon_max = float(q[6]), float(q[7])
        lat_min, lat_max = float(q[4]), float(q[5])
        width = lon_max - lon_min
        height = lat_max - lat_min

        rect = patches.Rectangle(
            (lon_min, lat_min),
            width,
            height,
            linewidth=0.55,
            edgecolor="#333333",
            facecolor=color,
            alpha=0.38,
            zorder=2,
        )
        ax.add_patch(rect)

    # 2. Draw 24 Zone Centroids and Badges
    for z in zones:
        zid = int(z[0])
        zname = clean_zone_name(str(z[1]))
        zlat = float(z[4])
        zlon = float(z[5])
        color = ZONE_24_PALETTE[(zid - 1) % len(ZONE_24_PALETTE)]

        ax.scatter(
            [zlon],
            [zlat],
            s=130,
            c=color,
            edgecolors="#ffffff",
            linewidths=1.8,
            zorder=5,
        )

        dx, dy, ha, va = ZONE_LABEL_OFFSETS.get(zid, (0.0, 0.0028, "center", "bottom"))
        ax.text(
            zlon + dx,
            zlat + dy,
            f"Z{zid}: {zname}",
            fontsize=7.2,
            fontweight="bold",
            ha=ha,
            va=va,
            bbox=dict(
                boxstyle="round,pad=0.20",
                facecolor="#ffffff",
                edgecolor=color,
                alpha=0.92,
                linewidth=1.2,
            ),
            zorder=6,
        )

    ax.set_title(
        "Partición Territorial de Managua: 298 Cuadrantes Urbanos Agrupados en 24 Zonas (MoviGo)",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5)
    ax.grid(True, linestyle="--", alpha=0.32)

    # Info box
    info = (
        "Estructura Territorial:\n"
        "• 298 Cuadrantes Operacionales (0.008° x 0.008°)\n"
        "• 24 Zonas Urbanas de Tarifa Base\n"
        "• 7 Distritos Municipales de Managua\n"
        "• Fuente: dim_quadrants & dim_zones"
    )
    ax.text(
        0.02, 0.03, info,
        transform=ax.transAxes,
        fontsize=8.2,
        fontfamily="monospace",
        verticalalignment="bottom",
        bbox=dict(boxstyle="square,pad=0.45", facecolor="#ffffff", edgecolor="#b0bec5", alpha=0.94),
        zorder=10,
    )

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Map 1 saved: {output_path.name}")

    return {
        "total_cuadrantes": len(quadrants),
        "total_zonas": len(zones),
    }


# -----------------------------------------------------------------------------
# 2. Mapa de Corredores de Movilidad y Flujos Origen-Destino (Desire Lines)
# -----------------------------------------------------------------------------
def plot_od_mobility_flows(
    con: duckdb.DuckDBPyConnection,
    output_path: Path,
    basemap_img: Image.Image | None,
    bounds: dict[str, float] | None,
) -> dict[str, Any]:
    """Renders top origin-destination flow vectors between zone centroids."""
    top_od = con.execute("""
        SELECT 
            z1.zone_id as id_orig, z1.zone_name as orig_name,
            cast(z1.longitude as double) as orig_lon, cast(z1.latitude as double) as orig_lat,
            z2.zone_id as id_dest, z2.zone_name as dest_name,
            cast(z2.longitude as double) as dest_lon, cast(z2.latitude as double) as dest_lat,
            count(*) as volume
        FROM fct_viajes v
        JOIN dim_zones z1 ON v.sk_zone_origin = z1.sk_zone
        JOIN dim_zones z2 ON v.sk_zone_destination = z2.sk_zone
        GROUP BY z1.zone_id, z1.zone_name, z1.longitude, z1.latitude,
                 z2.zone_id, z2.zone_name, z2.longitude, z2.latitude
        ORDER BY volume DESC
        LIMIT 25;
    """).fetchall()

    zone_traffic = con.execute("""
        SELECT 
            z.zone_id,
            z.zone_name,
            cast(z.longitude as double) as lon,
            cast(z.latitude as double) as lat,
            count(v.trip_id) as total_viajes
        FROM dim_zones z
        LEFT JOIN fct_viajes v ON z.sk_zone = v.sk_zone_origin
        GROUP BY z.zone_id, z.zone_name, z.longitude, z.latitude
        ORDER BY total_viajes DESC;
    """).fetchall()

    fig, ax = plt.subplots(figsize=(11.0, 8.5), dpi=300)
    apply_basemap(ax, basemap_img, bounds)

    volumes = [r[8] for r in top_od]
    min_vol, max_vol = min(volumes), max(volumes)

    # 1. Draw Flow Desire Lines
    for r in top_od:
        o_lon, o_lat = r[2], r[3]
        d_lon, d_lat = r[6], r[7]
        vol = r[8]

        norm_vol = (vol - min_vol) / (max_vol - min_vol + 1e-5)
        lw = 1.2 + norm_vol * 4.8
        alpha = 0.40 + norm_vol * 0.48

        # Curve deflection slightly to differentiate bidirectional pairs
        mid_lon = (o_lon + d_lon) / 2.0
        mid_lat = (o_lat + d_lat) / 2.0
        dx = d_lon - o_lon
        dy = d_lat - o_lat
        ctrl_lon = mid_lon - dy * 0.12
        ctrl_lat = mid_lat + dx * 0.12

        t = np.linspace(0, 1, 30)
        curve_lon = (1 - t)**2 * o_lon + 2 * (1 - t) * t * ctrl_lon + t**2 * d_lon
        curve_lat = (1 - t)**2 * o_lat + 2 * (1 - t) * t * ctrl_lat + t**2 * d_lat

        line_color = plt.cm.plasma(0.15 + norm_vol * 0.75)  # type: ignore[reportUnknownMemberType]
        ax.plot(curve_lon, curve_lat, color=line_color, linewidth=lw, alpha=alpha, zorder=3)

    # 2. Draw Zone Hubs sized by total trips
    max_zone_trips = max(z[4] for z in zone_traffic)
    for z in zone_traffic:
        zid = int(z[0])
        zlon, zlat = z[2], z[3]
        ztrips = z[4]
        hub_size = 80 + (ztrips / max_zone_trips) * 450

        ax.scatter(
            [zlon], [zlat],
            s=hub_size,
            c="#10002b",
            edgecolors="#ffffff",
            linewidths=1.5,
            alpha=0.88,
            zorder=5,
        )

        dx, dy, ha, va = ZONE_LABEL_OFFSETS.get(zid, (0.0, 0.0028, "center", "bottom"))
        ax.text(
            zlon + dx, zlat + dy,
            f"Z{zid}",
            fontsize=7.5,
            fontweight="bold",
            ha=ha, va=va,
            bbox=dict(boxstyle="circle,pad=0.15", facecolor="#ffffff", edgecolor="#10002b", alpha=0.92),
            zorder=6,
        )

    ax.set_title(
        "Corredores de Movilidad Urbana y Matriz de Deseo de Viajes (Top 25 Pares OD en Managua)",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5)
    ax.grid(True, linestyle="--", alpha=0.32)

    # Flow Legend Box
    od_summary = (
        f"Matriz de Movilidad:\n"
        f"• Par OD #1: {top_od[0][1].split(' / ')[0]} -> {top_od[0][5].split(' / ')[0]} ({top_od[0][8]:,} viajes)\n"
        f"• Par OD #2: {top_od[1][1].split(' / ')[0]} -> {top_od[1][5].split(' / ')[0]} ({top_od[1][8]:,} viajes)\n"
        f"• Rango Top 25: {min_vol:,} a {max_vol:,} viajes\n"
        f"• Grosor de vector representa volumen transaccional"
    )
    ax.text(
        0.02, 0.03, od_summary,
        transform=ax.transAxes,
        fontsize=8.0,
        fontfamily="monospace",
        verticalalignment="bottom",
        bbox=dict(boxstyle="square,pad=0.45", facecolor="#ffffff", edgecolor="#b0bec5", alpha=0.94),
        zorder=10,
    )

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Map 2 saved: {output_path.name}")

    return {
        "top_od_pair_1": f"{top_od[0][1]} -> {top_od[0][5]} ({top_od[0][8]} viajes)",
        "top_od_pair_2": f"{top_od[1][1]} -> {top_od[1][5]} ({top_od[1][8]} viajes)",
    }


# -----------------------------------------------------------------------------
# 3. Mapa Espacial de Motivos de Cancelación
# -----------------------------------------------------------------------------
def plot_cancellation_causes(
    con: duckdb.DuckDBPyConnection,
    output_path: Path,
    basemap_img: Image.Image | None,
    bounds: dict[str, float] | None,
) -> dict[str, Any]:
    """Renders cancelled trips disaggregated by 4 primary causal mechanisms."""
    causes_data = con.execute("""
        SELECT 
            cast(origin_longitude as double) as lon,
            cast(origin_latitude as double) as lat,
            CASE 
                WHEN cancellation_reason = 'Tarifa dinámica sobrepasa presupuesto' THEN 'Tarifa Dinámica Excesiva'
                WHEN cancellation_reason IN ('Tiempo de llegada excesivo', 'Conductor no avanza') THEN 'Espera / Latencia de Llegada'
                WHEN cancellation_reason IN ('Desplazamiento en vacío excesivo (>4km a zona baja demanda)', 'Conductor fatigado / fin de turno', 'Falla mecánica / imprevisto del conductor') THEN 'Fricción Operativa del Conductor'
                WHEN cancellation_reason IN ('Vía anegada / cauce intransitable', 'Riesgo de inundación / cauce desbordado (rechazo conductor)') THEN 'Vulnerabilidad Pluvial / Cauces'
                ELSE 'Otros Imprevistos'
            END as macro_causa
        FROM fct_viajes
        WHERE is_cancelled = true
          AND origin_latitude BETWEEN 12.000 AND 12.200
          AND origin_longitude BETWEEN -86.360 AND -86.130;
    """).fetchall()

    zones = con.execute("""
        SELECT 
            zone_id,
            zone_name,
            cast(latitude as double) as lat,
            cast(longitude as double) as lon
        FROM dim_zones
        ORDER BY zone_id;
    """).fetchall()

    cause_colors = {
        "Tarifa Dinámica Excesiva": "#ff7b00",           # Vivid Orange
        "Espera / Latencia de Llegada": "#7209b7",       # Purple
        "Fricción Operativa del Conductor": "#1f77b4",   # Deep Steel Blue
        "Vulnerabilidad Pluvial / Cauces": "#d90429",    # Intense Crimson
    }

    fig, ax = plt.subplots(figsize=(11.0, 8.5), dpi=300)
    apply_basemap(ax, basemap_img, bounds)

    # Group points by macro cause
    grouped: dict[str, list[tuple[float, float]]] = {}
    for r in causes_data:
        lon, lat, cause = r[0], r[1], r[2]
        grouped.setdefault(cause, []).append((lon, lat))

    # Scatter by cause
    total_canc = len(causes_data)
    for cause, pts in grouped.items():
        if cause not in cause_colors:
            continue
        xs = [p[0] for p in pts]
        ys = [p[1] for p in pts]
        color = cause_colors[cause]
        pct = (len(xs) / total_canc * 100.0) if total_canc > 0 else 0.0
        ax.scatter(
            xs, ys,
            s=8,
            c=color,
            alpha=0.45,
            edgecolors="none",
            label=f"{cause} ({len(xs):,} — {pct:.1f}%)",
            zorder=3,
            rasterized=True,
        )

    # Zone centroids
    for z in zones:
        zid = int(z[0])
        zlat, zlon = z[2], z[3]
        ax.scatter([zlon], [zlat], s=90, c="#ffffff", edgecolors="#212529", linewidths=1.5, zorder=5)
        dx, dy, ha, va = ZONE_LABEL_OFFSETS.get(zid, (0.0, 0.0028, "center", "bottom"))
        ax.text(zlon + dx, zlat + dy, f"Z{zid}", fontsize=7.0, fontweight="bold", ha=ha, va=va,
                bbox=dict(boxstyle="round,pad=0.15", facecolor="#ffffff", edgecolor="#212529", alpha=0.90),
                zorder=6)

    ax.set_title(
        "Desagregación Espacial de Causas de Cancelación de Viajes en Managua (MoviGo 2024)",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5)
    ax.legend(loc="upper right", frameon=True, facecolor="white", edgecolor="#b0bec5", framealpha=0.95, fontsize=8.2)
    ax.grid(True, linestyle="--", alpha=0.32)

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Map 3 saved: {output_path.name}")

    return {cause: len(pts) for cause, pts in grouped.items()}


# -----------------------------------------------------------------------------
# 4. Mapa de Riesgo Pluvial en los 298 Cuadrantes Urbanos
# -----------------------------------------------------------------------------
def plot_flood_risk_quadrants(
    con: duckdb.DuckDBPyConnection,
    output_path: Path,
    basemap_img: Image.Image | None,
    bounds: dict[str, float] | None,
) -> dict[str, Any]:
    """Renders 298 quadrants shaded by hydrological flood risk level."""
    quadrants = con.execute("""
        SELECT 
            quadrant_id,
            flood_risk,
            mean_altitude_masl,
            cast(lat_min as double) as lat_min,
            cast(lat_max as double) as lat_max,
            cast(lon_min as double) as lon_min,
            cast(lon_max as double) as lon_max
        FROM dim_quadrants
        ORDER BY quadrant_id;
    """).fetchall()

    zones = con.execute("""
        SELECT 
            zone_id,
            zone_name,
            cast(latitude as double) as lat,
            cast(longitude as double) as lon
        FROM dim_zones
        ORDER BY zone_id;
    """).fetchall()

    risk_styles = {
        "critico": {"color": "#d90429", "alpha": 0.58, "label": "Riesgo Crítico (Cauces / Ribera Lago)"},
        "alto":    {"color": "#f77f00", "alpha": 0.45, "label": "Riesgo Alto (Anegamiento Rápido)"},
        "medio":   {"color": "#fcbf49", "alpha": 0.35, "label": "Riesgo Medio (Escorrentía Moderada)"},
        "bajo":    {"color": "#2a9d8f", "alpha": 0.28, "label": "Riesgo Bajo / Drenado (Alturas del Sur)"},
    }

    fig, ax = plt.subplots(figsize=(11.0, 8.5), dpi=300)
    apply_basemap(ax, basemap_img, bounds)

    risk_counts: dict[str, int] = {}
    for q in quadrants:
        risk = str(q[1]).lower()
        risk_counts[risk] = risk_counts.get(risk, 0) + 1
        cfg = risk_styles.get(risk, risk_styles["bajo"])

        lon_min, lon_max = q[5], q[6]
        lat_min, lat_max = q[3], q[4]

        rect = patches.Rectangle(
            (lon_min, lat_min),
            lon_max - lon_min,
            lat_max - lat_min,
            linewidth=0.55,
            edgecolor="#2b2d42",
            facecolor=cfg["color"],
            alpha=cfg["alpha"],
            zorder=2,
        )
        ax.add_patch(rect)

    # Zone centroids
    for z in zones:
        zid = int(z[0])
        zname = clean_zone_name(str(z[1]))
        zlat, zlon = z[2], z[3]
        dx, dy, ha, va = ZONE_LABEL_OFFSETS.get(zid, (0.0, 0.0028, "center", "bottom"))
        ax.scatter([zlon], [zlat], s=110, c="#ffffff", edgecolors="#d90429", linewidths=1.8, zorder=5)
        ax.text(zlon + dx, zlat + dy, f"Z{zid}: {zname}", fontsize=7.2, fontweight="bold", ha=ha, va=va,
                bbox=dict(boxstyle="round,pad=0.20", facecolor="#ffffff", edgecolor="#d90429", alpha=0.92, linewidth=1.1),
                zorder=6)

    # Runoff indicator
    ax.annotate(
        "Dirección de Escorrentía Pluvial hacia Lago Xolotlán (Norte) ⬇",
        xy=(-86.265, 12.170),
        xytext=(-86.265, 12.180),
        arrowprops=dict(facecolor="#0077b6", edgecolor="#ffffff", width=2.5, headwidth=8.0),
        fontsize=8.5,
        fontweight="bold",
        color="#0077b6",
        ha="center",
        bbox=dict(boxstyle="round,pad=0.3", facecolor="#e0f2fe", edgecolor="#0077b6", alpha=0.90),
        zorder=10,
    )

    # Custom Legend
    legend_elements = [
        patches.Patch(facecolor=cfg["color"], edgecolor="#2b2d42", alpha=cfg["alpha"], label=f"{cfg['label']} (n={risk_counts.get(k, 0)})")
        for k, cfg in risk_styles.items()
    ]
    ax.legend(handles=legend_elements, loc="upper right", frameon=True, facecolor="white", edgecolor="#b0bec5", framealpha=0.95, fontsize=8.2)

    ax.set_title(
        "Vulnerabilidad Hidrológica y Riesgo de Inundación en 298 Cuadrantes Urbanos de Managua",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5)
    ax.grid(True, linestyle="--", alpha=0.32)

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Map 4 saved: {output_path.name}")

    return risk_counts


# -----------------------------------------------------------------------------
# 5. Mapa de Accesibilidad y Tiempos Medios de Espera para Recogida
# -----------------------------------------------------------------------------
def plot_wait_times(
    con: duckdb.DuckDBPyConnection,
    output_path: Path,
    basemap_img: Image.Image | None,
    bounds: dict[str, float] | None,
) -> dict[str, Any]:
    """Renders pickup wait times in minutes across the 24 zones."""
    zone_waits = con.execute("""
        SELECT 
            z.zone_id,
            z.zone_name,
            z.socioeconomic_stratum,
            cast(z.longitude as double) as lon,
            cast(z.latitude as double) as lat,
            count(v.trip_id) as total_viajes,
            round(avg(v.wait_time_minutes), 2) as tiempo_espera_promedio
        FROM dim_zones z
        JOIN fct_viajes v ON z.sk_zone = v.sk_zone_origin
        GROUP BY z.zone_id, z.zone_name, z.socioeconomic_stratum, z.longitude, z.latitude
        ORDER BY tiempo_espera_promedio DESC;
    """).fetchall()

    fig, ax = plt.subplots(figsize=(11.0, 8.5), dpi=300)
    apply_basemap(ax, basemap_img, bounds)

    wait_vals = [r[6] for r in zone_waits]
    min_w, max_w = min(wait_vals), max(wait_vals)
    cmap = plt.cm.RdYlGn_r  # Red is high wait (poor), Green is low wait (good)  # type: ignore[reportUnknownMemberType]

    for r in zone_waits:
        zid = int(r[0])
        zname = clean_zone_name(str(r[1]))
        zlon, zlat = r[3], r[4]
        ztrips = r[5]
        wait_min = r[6]

        norm_w = (wait_min - min_w) / (max_w - min_w + 1e-5)
        color = cmap(norm_w)
        size = 200 + (ztrips / 5552.0) * 350

        # Outer glow circle
        ax.scatter([zlon], [zlat], s=size * 1.5, c=[color], alpha=0.35, edgecolors="none", zorder=3)
        # Core marker
        ax.scatter([zlon], [zlat], s=size, c=[color], edgecolors="#ffffff", linewidths=1.8, alpha=0.92, zorder=5)

        dx, dy, ha, va = ZONE_LABEL_OFFSETS.get(zid, (0.0, 0.0028, "center", "bottom"))
        ax.text(
            zlon + dx, zlat + dy,
            f"Z{zid}: {zname}\n{wait_min:.1f} min",
            fontsize=7.2,
            fontweight="bold",
            ha=ha, va=va,
            bbox=dict(boxstyle="round,pad=0.20", facecolor="#ffffff", edgecolor=color, alpha=0.94, linewidth=1.2),
            zorder=6,
        )

    # Colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=plt.Normalize(vmin=min_w, vmax=max_w))  # type: ignore[reportUnknownMemberType]
    sm.set_array([])
    cbar = fig.colorbar(sm, ax=ax, orientation="horizontal", pad=0.06, fraction=0.035, aspect=35)
    cbar.set_label("Tiempo Medio de Espera de Recogida (Minutos)", fontsize=9.0, fontweight="medium")

    ax.set_title(
        "Accesibilidad Temporal del Servicio: Tiempos Medios de Espera para Recogida (MoviGo Managua)",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9.5)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9.5)
    ax.grid(True, linestyle="--", alpha=0.32)

    # Disparity info box
    fastest_z = str(zone_waits[-1][1]).split(" / ")[0]
    fastest_w = float(zone_waits[-1][6])
    second_fastest_z = str(zone_waits[-2][1]).split(" / ")[0]
    second_fastest_w = float(zone_waits[-2][6])

    slowest_z = str(zone_waits[0][1]).split(" / ")[0]
    slowest_w = float(zone_waits[0][6])
    second_slowest_z = str(zone_waits[1][1]).split(" / ")[0]
    second_slowest_w = float(zone_waits[1][6])
    total_trips = sum(int(r[5]) for r in zone_waits)

    disparity_text = (
        f"Brecha de Accesibilidad Temporal:\n"
        f"• Más Rápido: {fastest_z} ({fastest_w:.1f} min) | {second_fastest_z} ({second_fastest_w:.1f} min)\n"
        f"• Mayor Demora: {slowest_z} ({slowest_w:.1f} min) | {second_slowest_z} ({second_slowest_w:.1f} min)\n"
        f"• Disparidad Territorial: {slowest_w / fastest_w:.1f}x mayor tiempo en periferias\n"
        f"• Base: {total_trips:,} viajes transaccionales"
    )
    ax.text(
        0.02, 0.03, disparity_text,
        transform=ax.transAxes,
        fontsize=8.0,
        fontfamily="monospace",
        verticalalignment="bottom",
        bbox=dict(boxstyle="square,pad=0.45", facecolor="#ffffff", edgecolor="#b0bec5", alpha=0.94),
        zorder=10,
    )

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"✅ Map 5 saved: {output_path.name}")

    return {
        "min_wait_minutes": min_w,
        "max_wait_minutes": max_w,
        "disparity_ratio": round(max_w / min_w, 2),
    }


# -----------------------------------------------------------------------------
# Main Orchestrator
# -----------------------------------------------------------------------------
def main() -> None:
    print("=" * 70)
    print("MoviGo Exploratory Geospatial Maps Suite: Generating 5 Map Figures")
    print("=" * 70)

    if not DUCKDB_PATH.exists():
        raise FileNotFoundError(f"DuckDB database not found at {DUCKDB_PATH}. Run 'just duckdb-snapshot'.")

    basemap_img, bounds = load_basemap()
    con = duckdb.connect(str(DUCKDB_PATH), read_only=True)

    summary: dict[str, Any] = {}
    try:
        # 1. Quadrants tiled by zone
        p1 = GRAPHS_DIR / "map_exploratory_quadrants_by_zone.png"
        summary["quadrants_by_zone"] = plot_quadrants_by_zone(con, p1, basemap_img, bounds)

        # 2. OD Mobility flows
        p2 = GRAPHS_DIR / "map_exploratory_od_flows.png"
        summary["od_mobility_flows"] = plot_od_mobility_flows(con, p2, basemap_img, bounds)

        # 3. Cancellation causes
        p3 = GRAPHS_DIR / "map_exploratory_cancellation_causes.png"
        summary["cancellation_causes"] = plot_cancellation_causes(con, p3, basemap_img, bounds)

        # 4. Flood risk quadrants
        p4 = GRAPHS_DIR / "map_exploratory_flood_risk_quadrants.png"
        summary["flood_risk_quadrants"] = plot_flood_risk_quadrants(con, p4, basemap_img, bounds)

        # 5. Wait times
        p5 = GRAPHS_DIR / "map_exploratory_wait_times.png"
        summary["wait_times"] = plot_wait_times(con, p5, basemap_img, bounds)
    finally:
        con.close()

    OUTPUT_JSON_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_JSON_PATH, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    print(f"✅ Exploratory KPIs exported to: {OUTPUT_JSON_PATH.relative_to(ROOT_DIR)}")
    print("=" * 70)
    print("🎉 All 5 exploratory map figures generated successfully!")
    print("=" * 70)


if __name__ == "__main__":
    main()
