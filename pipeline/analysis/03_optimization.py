#!/usr/bin/env python3
"""
MoviGo Operations Optimization: Graph Theory & Dijkstra Shortest Path
---------------------------------------------------------------------
Models the urban road network of Managua as a weighted graph G = (V, E)
connecting the 24 urban zones across primary arterial avenues.

Evaluates minimum travel time paths under:
  1. Baseline Scenario: Dry, free-flow arterial conditions.
  2. Storm Contingency Scenario: Flash-flooded bottleneck corridors
     (Pista Juan Pablo II, Metrocentro, cauces) triggering dynamic rerouting.

Outputs:
  - JSON data: typst/data/routing_optimization.json
  - Image plot 1: typst/graphs/urban_network_topology.png
  - Image plot 2: typst/graphs/urban_network_dijkstra.png
"""

from __future__ import annotations

import json
from math import atan2, cos, radians, sin, sqrt
from pathlib import Path
from typing import Any

import duckdb
import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from PIL import Image

# -----------------------------------------------------------------------------
# Spatial Utility Functions
# -----------------------------------------------------------------------------
TORTUOSITY_FACTOR = 1.30  # Urban street network detour correction factor


def haversine_distance_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculates the great-circle distance between two points in kilometers."""
    R = 6371.0  # Earth radius in km
    phi1, phi2 = radians(lat1), radians(lat2)
    delta_phi = radians(lat2 - lat1)
    delta_lambda = radians(lon2 - lon1)

    a = sin(delta_phi / 2.0) ** 2 + cos(phi1) * cos(phi2) * sin(delta_lambda / 2.0) ** 2
    c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
    return float(R * c)


def get_zones_catalog(db_path: Path) -> dict[int, dict]:
    """Extracts the 24 urban zones with coordinates from DuckDB."""
    con = duckdb.connect(str(db_path), read_only=True)
    try:
        rows = con.execute("""
            SELECT zone_id, zone_name, socioeconomic_stratum,
                   cast(latitude as double) AS latitud,
                   cast(longitude as double) AS longitud,
                   cast(coverage_radius_km as double) AS radio_cobertura_km
            FROM dim_zones
            ORDER BY zone_id;
        """).fetchall()
    finally:
        con.close()

    zones = {}
    for r in rows:
        zones[r[0]] = {
            "id_zona": r[0],
            "nombre": r[1],
            "estrato": r[2],
            "lat": r[3],
            "lon": r[4],
            "radio_km": r[5],
        }
    return zones


# -----------------------------------------------------------------------------
# Graph Construction & Impedance Modeling
# -----------------------------------------------------------------------------
# Primary arterial connections of Managua (44 bidirectional road corridors connecting all 24 zones)
# Format: (u, v, corridor_name, is_flood_prone)
ROAD_EDGES = [
    # Corredores Principales Centrales y Radiales (Z1 - Z12)
    (8, 6, "Pista Juan Pablo II (Oeste)", True),
    (6, 9, "Pista Juan Pablo II (Tiscapa-Metrocentro)", True),
    (9, 5, "Pista Juan Pablo II (Central)", True),
    (5, 12, "Pista Juan Pablo II (Este-Huembes)", True),
    (12, 7, "Pista de la Solidaridad / Rubenia", False),
    (9, 4, "Carretera a Masaya (Tramo Norte)", False),
    (4, 1, "Pista Jean Paul Genie / Carretera a Masaya", False),
    (1, 2, "Corredor Residencial Sur", False),
    (2, 3, "Carretera a Masaya (Km 8.5)", False),
    (6, 10, "Eje Tiscapa / Calle 27 de Mayo", False),
    (10, 11, "Avenida Central Mercado Oriental", True),
    (11, 12, "Pista Radial Este", True),
    (10, 7, "Pista Larreynaga", False),
    (11, 7, "Pista Portezuelo / Radial Norte", True),
    (4, 5, "Pista Los Robles - Camino de Oriente", False),
    (1, 5, "Pista Suburbana (Enlace Este)", False),
    (8, 9, "Pista de la Resistencia / Radial Norte", False),
    (6, 4, "Interseccion Plaza El Sol", False),
    (1, 3, "Pista Jean Paul Genie (Enlace Santo Domingo)", False),
    (5, 10, "Pista Buenos Aires", False),
    (10, 12, "Pista El Dorado", False),
    (2, 12, "Pista Radial Sur-Huembes", False),
    # Conexiones Arteriales Distrito II y III (Occidente y Suroccidente)
    (8, 13, "Paseo Las Brisas / Monseñor Lezcano", True),
    (13, 6, "Calle 27 de Mayo / Estatua Montoya", False),
    (13, 14, "Pista Dupla Norte (Acceso Malecón)", False),
    (14, 6, "Avenida Bolívar / Antiguo Centro", False),
    (14, 11, "Dupla Norte / Enlace Oriental", True),
    (6, 15, "Pista Benjamín Zeledón / Altagracia", False),
    (15, 16, "Pista Suburbana / Eje San Judas", False),
    (16, 17, "Carretera Sur / Cruce Nejapa", False),
    (17, 8, "Pista Enlace Sur-Occidente (Nejapa-Linda Vista)", False),
    (16, 1, "Pista Suburbana (Tramo San Judas-Villa Fontana)", False),
    # Conexiones Arteriales Distrito V (Extremo Sur)
    (3, 18, "Carretera a Masaya (Km 9 - 14 / Esquipulas)", False),
    (2, 18, "Camino San Isidro - Esquipulas", False),
    # Conexiones Arteriales Distrito VI y VII (Oriente y Suroriente)
    (7, 19, "Pista Larreynaga / Multicentro", False),
    (19, 20, "Pista de la Solidaridad Este (Multicentro-Mayoreo)", True),
    (20, 21, "Carretera Panamericana Norte (Km 9 - 11 Aeropuerto)", False),
    (7, 21, "Carretera Norte (Tramo Portezuelo-Aeropuerto)", False),
    (19, 22, "Pista Radial Mayoreo / Primero de Mayo", False),
    (12, 22, "Pista de la Solidaridad / Paso a Desnivel Rubenia", False),
    (22, 23, "Pista Buenos Aires Este (Primero de Mayo-Villa Libertad)", False),
    (20, 23, "Avenida Los Laureles (Mayoreo-Villa Libertad)", False),
    (23, 24, "Pista Sabana Grande / Eje Ciudad Belén", False),
    (21, 24, "Enlace Periférico Aeropuerto - Sabana Grande", False),
]


def build_managua_graph(zones: dict[int, dict]) -> nx.Graph:
    """Builds the unweighted topological graph with distance and road metadata."""
    G = nx.Graph()

    # Add nodes
    for zid, zdata in zones.items():
        G.add_node(
            zid,
            name=zdata["nombre"],
            estrato=zdata["estrato"],
            pos=(zdata["lon"], zdata["lat"]),
            radio_km=zdata["radio_km"],
        )

    # Add edges with calibrated physical distances
    for u, v, corridor_name, is_flood in ROAD_EDGES:
        lat1, lon1 = zones[u]["lat"], zones[u]["lon"]
        lat2, lon2 = zones[v]["lat"], zones[v]["lon"]
        straight_dist = haversine_distance_km(lat1, lon1, lat2, lon2)
        road_dist = round(straight_dist * TORTUOSITY_FACTOR, 2)

        G.add_edge(
            u,
            v,
            corridor=corridor_name,
            distance_km=road_dist,
            is_flood_prone=is_flood,
        )

    return G


def compute_scenario_weights(G: nx.Graph):
    """
    Computes travel time impedance in minutes:
      tau = (distance_km / speed_kmh) * 60
    under dry vs. storm conditions.
    """
    for u, v, data in G.edges(data=True):
        dist = data["distance_km"]
        is_flood = data["is_flood_prone"]

        # Base speeds (dry)
        # Commercial market zones are naturally slower (22 km/h) vs standard arterial (32 km/h)
        is_market = (u in [11, 12, 20]) or (v in [11, 12, 20])
        v_base = 22.0 if is_market else 32.0

        time_dry = round((dist / v_base) * 60.0, 2)
        data["weight_dry"] = time_dry
        data["speed_dry"] = v_base

        # Storm speeds
        if is_flood:
            # 65% speed drop in flood-prone cauces and underpasses
            v_storm = round(v_base * 0.35, 1)
        else:
            # 25% speed drop in elevated, well-drained southern corridors
            v_storm = round(v_base * 0.75, 1)

        time_storm = round((dist / v_storm) * 60.0, 2)
        data["weight_storm"] = time_storm
        data["speed_storm"] = v_storm


# -----------------------------------------------------------------------------
# Dijkstra Shortest Path Evaluations
# -----------------------------------------------------------------------------
EVAL_OD_PAIRS = [
    {
        "od_id": "OD_1",
        "description": "Diagonal Metropolitana Noroccidente - Suroriente",
        "origin_id": 8,  # Linda Vista
        "destination_id": 3,  # Santo Domingo
    },
    {
        "od_id": "OD_2",
        "description": "Residencial Sur a Nucleo Comercial Mayorista",
        "origin_id": 2,  # Las Colinas
        "destination_id": 11,  # Mercado Oriental
    },
    {
        "od_id": "OD_3",
        "description": "Corredor Transversal Este - Oeste",
        "origin_id": 6,  # Bolonia
        "destination_id": 7,  # Bello Horizonte
    },
]


def run_dijkstra_analysis(G: nx.Graph, zones: dict[int, dict]) -> list[dict]:
    """Runs Dijkstra algorithm across the 3 strategic OD pairs in both scenarios."""
    compute_scenario_weights(G)
    results = []

    for od in EVAL_OD_PAIRS:
        orig = od["origin_id"]
        dest = od["destination_id"]

        # 1. Dry Scenario
        path_dry = nx.dijkstra_path(G, orig, dest, weight="weight_dry")
        time_dry = nx.dijkstra_path_length(G, orig, dest, weight="weight_dry")
        dist_dry = sum(
            G[u][v]["distance_km"] for u, v in zip(path_dry[:-1], path_dry[1:])
        )

        # 2. Storm Scenario
        path_storm = nx.dijkstra_path(G, orig, dest, weight="weight_storm")
        time_storm = nx.dijkstra_path_length(G, orig, dest, weight="weight_storm")
        dist_storm = sum(
            G[u][v]["distance_km"] for u, v in zip(path_storm[:-1], path_storm[1:])
        )

        delay_pct = round(((time_storm - time_dry) / time_dry) * 100.0, 1)
        path_changed = path_dry != path_storm

        results.append(
            {
                "od_id": od["od_id"],
                "description": od["description"],
                "origin": {"id": orig, "name": zones[orig]["nombre"]},
                "destination": {"id": dest, "name": zones[dest]["nombre"]},
                "dry_scenario": {
                    "path_nodes": path_dry,
                    "path_names": [zones[n]["nombre"] for n in path_dry],
                    "travel_time_minutes": round(time_dry, 2),
                    "distance_km": round(dist_dry, 2),
                    "avg_speed_kmh": round((dist_dry / (time_dry / 60.0)), 1),
                },
                "storm_scenario": {
                    "path_nodes": path_storm,
                    "path_names": [zones[n]["nombre"] for n in path_storm],
                    "travel_time_minutes": round(time_storm, 2),
                    "distance_km": round(dist_storm, 2),
                    "avg_speed_kmh": round((dist_storm / (time_storm / 60.0)), 1),
                    "delay_percentage": delay_pct,
                    "path_rerouted": path_changed,
                },
            }
        )

    return results


def compute_network_centrality_and_resilience(
    G: nx.Graph, zones: dict[int, dict]
) -> dict[str, Any]:
    """Computes Betweenness Centrality, bottlenecks, and all-pairs network resilience."""
    compute_scenario_weights(G)

    # Centrality metrics
    betw_dry = nx.betweenness_centrality(G, weight="weight_dry")
    betw_storm = nx.betweenness_centrality(G, weight="weight_storm")
    degrees = dict(G.degree())

    # Global shortest path lengths across all 552 OD pairs
    all_pairs_dry = dict(nx.all_pairs_dijkstra_path_length(G, weight="weight_dry"))
    all_pairs_storm = dict(nx.all_pairs_dijkstra_path_length(G, weight="weight_storm"))

    times_dry = [all_pairs_dry[u][v] for u in G.nodes() for v in G.nodes() if u != v]
    times_storm = [all_pairs_storm[u][v] for u in G.nodes() for v in G.nodes() if u != v]

    avg_dry = float(np.mean(times_dry))
    avg_storm = float(np.mean(times_storm))
    avg_delay = float(((avg_storm - avg_dry) / avg_dry) * 100.0)

    # Ranking of top bottleneck zones by betweenness
    ranking = []
    for zid, val in sorted(betw_dry.items(), key=lambda x: x[1], reverse=True):
        ranking.append(
            {
                "zone_id": zid,
                "name": zones[zid]["nombre"],
                "stratum": zones[zid]["estrato"],
                "betweenness_dry": round(val, 4),
                "betweenness_storm": round(betw_storm[zid], 4),
                "degree": int(degrees[zid]),
            }
        )

    return {
        "global_resilience": {
            "total_pairs_evaluated": len(times_dry),
            "avg_travel_time_dry_min": round(avg_dry, 2),
            "avg_travel_time_storm_min": round(avg_storm, 2),
            "network_delay_percentage": round(avg_delay, 1),
            "diameter_dry_min": round(max(times_dry), 2),
            "diameter_storm_min": round(max(times_storm), 2),
        },
        "top_bottlenecks": ranking[:8],
        "all_zones_centrality": ranking,
    }


# -----------------------------------------------------------------------------
# Basemap Cache Loader
# -----------------------------------------------------------------------------
def load_cached_basemap(
    root: Path,
) -> tuple[Image.Image | None, dict[str, float] | None]:
    """
    Loads pre-cached Managua raster basemap and geographic bounding coordinates.
    Falls back gracefully if the cache is missing.
    """
    img_path = root / "pipeline" / "data" / "managua_basemap.png"
    bounds_path = root / "pipeline" / "data" / "managua_basemap_bounds.json"

    if not img_path.exists() or not bounds_path.exists():
        try:
            from pipeline.analysis.cache_basemap import cache_basemap

            img_path, bounds_path = cache_basemap()
        except Exception:
            return None, None

    try:
        img = Image.open(img_path).convert("RGB")
        with open(bounds_path, "r", encoding="utf-8") as f:
            bounds = json.load(f)
        return img, bounds
    except Exception:
        return None, None


# -----------------------------------------------------------------------------
# Visualization Functions (Standalone PNGs at 300 DPI)
# -----------------------------------------------------------------------------
def generate_topology_plot(
    G: nx.Graph,
    zones: dict[int, dict],
    output_path: Path,
    basemap_img: Image.Image | None = None,
    bounds: dict[str, float] | None = None,
):
    """
    Renders standalone PNG: Spatial network topology of the 24 Managua urban zones
    with arterial road connections, node strata colors, and flood-prone corridors flagged.
    Overlays onto the pre-cached urban street basemap when available.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)
    plt.style.use(
        "seaborn-v0_8-whitegrid"
        if "seaborn-v0_8-whitegrid" in plt.style.available
        else "default"
    )
    fig, ax = plt.subplots(figsize=(10.5, 8.2), dpi=300)

    # Render urban street basemap if cached
    if basemap_img is not None and bounds is not None:
        extent = (bounds["west"], bounds["east"], bounds["south"], bounds["north"])
        ax.imshow(
            basemap_img,
            extent=extent,
            alpha=0.55,
            zorder=0,
            aspect="equal",
        )
        ax.set_xlim(bounds["west"], bounds["east"])
        ax.set_ylim(bounds["south"], bounds["north"])
    else:
        ax.set_xlim(-86.345, -86.140)
        ax.set_ylim(12.045, 12.180)

    pos = nx.get_node_attributes(G, "pos")

    # Stratum color mapping
    stratum_colors = {
        "alto": "#1976d2",  # Royal Blue
        "medio": "#388e3c",  # Forest Green
        "comercial": "#f57c00",  # Amber Orange
        "popular": "#7b1fa2",  # Purple
    }

    # Draw edges
    flood_edges = [(u, v) for u, v, d in G.edges(data=True) if d["is_flood_prone"]]
    safe_edges = [(u, v) for u, v, d in G.edges(data=True) if not d["is_flood_prone"]]

    nx.draw_networkx_edges(
        G,
        pos,
        edgelist=safe_edges,
        width=2.0,
        alpha=0.70,
        edge_color="#424242",
        ax=ax,
        label="Corredor Arterial Drenado",
    )
    nx.draw_networkx_edges(
        G,
        pos,
        edgelist=flood_edges,
        width=2.6,
        alpha=0.90,
        edge_color="#d32f2f",
        style="--",
        ax=ax,
        label="Corredor Vulnerable a Inundación",
    )

    # Draw nodes by stratum
    for stratum, color in stratum_colors.items():
        node_subset = [n for n, d in G.nodes(data=True) if d["estrato"] == stratum]
        nx.draw_networkx_nodes(
            G,
            pos,
            nodelist=node_subset,
            node_color=color,
            node_size=380,
            edgecolors="#ffffff",
            linewidths=1.5,
            ax=ax,
            label=f"Estrato {stratum.capitalize()}",
        )

    # Node labels (ID inside node, name offset)
    node_labels = {n: str(n) for n in G.nodes()}
    nx.draw_networkx_labels(
        G,
        pos,
        labels=node_labels,
        font_size=8,
        font_color="#ffffff",
        font_weight="bold",
        ax=ax,
    )

    # Custom label offsets to eliminate crowding in dense urban zones (e.g. Metrocentro, Los Robles, Altamira)
    custom_offsets: dict[int, tuple[float, float, str, str]] = {
        # zone_id: (dx, dy, ha, va)
        4: (-0.0020, 0.0026, "right", "bottom"),   # Los Robles
        9: (0.0025, -0.0028, "left", "top"),       # Metrocentro
        5: (0.0000, -0.0028, "center", "top"),     # Altamira
        10: (0.0000, 0.0028, "center", "bottom"),  # Ciudad Jardín
        6: (-0.0020, 0.0026, "right", "bottom"),   # Bolonia
        15: (-0.0020, -0.0026, "right", "top"),    # Altagracia
        19: (0.0000, 0.0028, "center", "bottom"),  # Multicentro
        20: (0.0025, 0.0010, "left", "center"),    # Mayoreo
        22: (0.0000, -0.0028, "center", "top"),    # Primero de Mayo
        12: (0.0000, -0.0028, "center", "top"),    # Roberto Huembes
        2: (0.0000, -0.0028, "center", "top"),     # Las Colinas
        3: (0.0020, 0.0026, "left", "bottom"),     # Santo Domingo
        18: (0.0000, -0.0028, "center", "top"),    # Esquipulas
    }

    # Offset zone name text with collision avoidance
    for n, (x, y) in pos.items():
        name = zones[n]["nombre"].split(" / ")[0]  # shorter name
        dx, dy, ha, va = custom_offsets.get(n, (0.0, 0.0028, "center", "bottom"))
        ax.text(
            x + dx,
            y + dy,
            f"Z{n}: {name}",
            fontsize=6.8,
            fontweight="semibold",
            ha=ha,
            va=va,
            bbox=dict(
                boxstyle="round,pad=0.20",
                facecolor="white",
                edgecolor="#90a4ae",
                alpha=0.92,
                linewidth=0.8,
            ),
            zorder=5,
        )

    ax.set_title(
        "Topología Espacial de la Red Vial Urbana de Managua (24 Zonas Urbanas)",
        fontsize=12,
        fontweight="bold",
        pad=10,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9)
    ax.legend(
        loc="upper right",
        frameon=True,
        facecolor="white",
        framealpha=0.92,
        fontsize=7.5,
    )
    ax.grid(True, linestyle="--", alpha=0.35)

    plt.tight_layout()
    plt.savefig(output_path, format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)


def generate_dijkstra_plot(
    G: nx.Graph,
    zones: dict[int, dict],
    od_result: dict,
    output_path: Path,
    basemap_img: Image.Image | None = None,
    bounds: dict[str, float] | None = None,
):
    """
    Renders standalone PNG: Visual route comparison between the baseline dry path
    (solid green) and storm rerouted path (dashed red/amber) for OD_1.
    Overlays onto the pre-cached urban street basemap when available.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)
    plt.style.use(
        "seaborn-v0_8-whitegrid"
        if "seaborn-v0_8-whitegrid" in plt.style.available
        else "default"
    )
    fig, ax = plt.subplots(figsize=(10.5, 8.2), dpi=300)

    # Render urban street basemap if cached
    if basemap_img is not None and bounds is not None:
        extent = (bounds["west"], bounds["east"], bounds["south"], bounds["north"])
        ax.imshow(
            basemap_img,
            extent=extent,
            alpha=0.55,
            zorder=0,
            aspect="equal",
        )
        ax.set_xlim(bounds["west"], bounds["east"])
        ax.set_ylim(bounds["south"], bounds["north"])
    else:
        ax.set_xlim(-86.345, -86.140)
        ax.set_ylim(12.045, 12.180)

    pos = nx.get_node_attributes(G, "pos")

    # Draw all background edges lightly
    nx.draw_networkx_edges(G, pos, width=1.2, alpha=0.35, edge_color="#757575", ax=ax)

    # Extract paths
    dry_path = od_result["dry_scenario"]["path_nodes"]
    storm_path = od_result["storm_scenario"]["path_nodes"]

    dry_edges = list(zip(dry_path[:-1], dry_path[1:]))
    storm_edges = list(zip(storm_path[:-1], storm_path[1:]))

    # Highlight dry route
    nx.draw_networkx_edges(
        G,
        pos,
        edgelist=dry_edges,
        width=3.8,
        alpha=0.90,
        edge_color="#2e7d32",
        ax=ax,
        label=f"Ruta Óptima en Seco ({od_result['dry_scenario']['travel_time_minutes']} min, {od_result['dry_scenario']['distance_km']} km)",
    )

    # Highlight storm route
    nx.draw_networkx_edges(
        G,
        pos,
        edgelist=storm_edges,
        width=3.2,
        alpha=0.95,
        edge_color="#d84315",
        style="--",
        ax=ax,
        label=f"Desvío Óptimo por Tormenta ({od_result['storm_scenario']['travel_time_minutes']} min, {od_result['storm_scenario']['distance_km']} km)",
    )

    # Draw nodes
    nx.draw_networkx_nodes(
        G,
        pos,
        node_color="#eceff1",
        node_size=320,
        edgecolors="#78909c",
        linewidths=1.2,
        ax=ax,
    )

    # Highlight Origin and Destination
    orig = od_result["origin"]["id"]
    dest = od_result["destination"]["id"]
    nx.draw_networkx_nodes(
        G,
        pos,
        nodelist=[orig],
        node_color="#43a047",
        node_size=480,
        edgecolors="#ffffff",
        linewidths=2.0,
        ax=ax,
        label=f"Origen: {zones[orig]['nombre']}",
    )
    nx.draw_networkx_nodes(
        G,
        pos,
        nodelist=[dest],
        node_color="#e53935",
        node_size=480,
        edgecolors="#ffffff",
        linewidths=2.0,
        ax=ax,
        label=f"Destino: {zones[dest]['nombre']}",
    )

    # Labels inside nodes
    node_labels = {n: str(n) for n in G.nodes()}
    nx.draw_networkx_labels(
        G,
        pos,
        labels=node_labels,
        font_size=8,
        font_color="#263238",
        font_weight="bold",
        ax=ax,
    )

    # Annotation box with comparative metrics in lower left
    info_text = (
        f"Evaluación Dijkstra ({od_result['origin']['name']} -> {od_result['destination']['name']}):\n"
        f"• Tiempo en Seco: {od_result['dry_scenario']['travel_time_minutes']} min ({od_result['dry_scenario']['avg_speed_kmh']} km/h)\n"
        f"• Tiempo en Tormenta: {od_result['storm_scenario']['travel_time_minutes']} min ({od_result['storm_scenario']['avg_speed_kmh']} km/h)\n"
        f"• Incremento de Tiempo: +{od_result['storm_scenario']['delay_percentage']}%\n"
        f"• Reruteo Activo: {'SÍ (Desvío Adaptativo)' if od_result['storm_scenario']['path_rerouted'] else 'NO'}"
    )
    ax.text(
        0.03,
        0.05,
        info_text,
        transform=ax.transAxes,
        fontsize=8.5,
        verticalalignment="bottom",
        bbox=dict(
            boxstyle="round,pad=0.5",
            facecolor="#ffffff",
            edgecolor="#b0bec5",
            alpha=0.94,
        ),
        zorder=5,
    )

    ax.set_title(
        f"Optimización de Ruta Dijkstra ante Tormenta: {od_result['description']}",
        fontsize=11,
        fontweight="bold",
        pad=10,
    )
    ax.set_xlabel("Longitud Oeste (WGS84)", fontsize=9)
    ax.set_ylabel("Latitud Norte (WGS84)", fontsize=9)
    ax.legend(
        loc="upper right",
        frameon=True,
        facecolor="white",
        framealpha=0.92,
        fontsize=7.5,
    )
    ax.grid(True, linestyle="--", alpha=0.35)

    plt.tight_layout()
    plt.savefig(output_path, format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)


# -----------------------------------------------------------------------------
# Main Orchestrator
# -----------------------------------------------------------------------------
def main():
    root = Path(__file__).resolve().parent.parent.parent
    db_path = root / "pipeline" / "data" / "analytics.duckdb"
    json_path = root / "typst" / "data" / "routing_optimization.json"
    topo_plot_path = root / "typst" / "graphs" / "urban_network_topology.png"
    dijkstra_plot_path = root / "typst" / "graphs" / "urban_network_dijkstra.png"

    print("=" * 60)
    print("MoviGo Operations Optimization: Graph Theory & Dijkstra Routing")
    print("=" * 60)
    print(f"Loading zones from DuckDB: {db_path.relative_to(root)}")

    zones = get_zones_catalog(db_path)
    print(f"Loaded {len(zones)} urban quadrant centroids.")

    # Build road network graph
    G = build_managua_graph(zones)
    print(
        f"Constructed network graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} arterial edges."
    )

    # Run Dijkstra across OD pairs
    routes_results = run_dijkstra_analysis(G, zones)

    print("\n--- Dijkstra Shortest Path Comparison ---")
    for r in routes_results:
        print(f"\n[{r['od_id']}] {r['description']}:")
        print(
            f"  Seco:     {r['dry_scenario']['travel_time_minutes']} min | {r['dry_scenario']['distance_km']} km | Ruta: {' -> '.join(r['dry_scenario']['path_names'])}"
        )
        print(
            f"  Tormenta: {r['storm_scenario']['travel_time_minutes']} min | {r['storm_scenario']['distance_km']} km | Ruta: {' -> '.join(r['storm_scenario']['path_names'])}"
        )
        print(
            f"  Demora:   +{r['storm_scenario']['delay_percentage']}% | Reruteo: {'SÍ' if r['storm_scenario']['path_rerouted'] else 'NO'}"
        )

    # Run centrality & resilience analysis
    centrality_resilience = compute_network_centrality_and_resilience(G, zones)
    res_glob = centrality_resilience["global_resilience"]
    print("\n--- [Análisis de Centralidad y Resiliencia Global de Red] ---")
    print(
        f"  Tiempo Promedio Global (552 pares OD): Seco = {res_glob['avg_travel_time_dry_min']} min | Tormenta = {res_glob['avg_travel_time_storm_min']} min (+{res_glob['network_delay_percentage']}%)"
    )
    print("  Top 5 Cuellos de Botella (Centralidad de Intermediación):")
    for b in centrality_resilience["top_bottlenecks"][:5]:
        print(f"    - Zona {b['zone_id']} ({b['name']}): Betweenness = {b['betweenness_dry']} | Grado = {b['degree']}")

    # Build JSON payload
    payload = {
        "description": "Optimizacion de Rutas de Despacho en Red Vial Urbana de Managua (Algoritmo de Dijkstra)",
        "network_summary": {
            "total_nodes": G.number_of_nodes(),
            "total_edges": G.number_of_edges(),
            "tortuosity_factor": TORTUOSITY_FACTOR,
            "baseline_arterial_speed_kmh": 32.0,
            "storm_flood_speed_kmh": 11.2,
            "flood_prone_corridors_count": len([e for e in ROAD_EDGES if e[3]]),
        },
        "global_resilience": centrality_resilience["global_resilience"],
        "top_bottlenecks": centrality_resilience["top_bottlenecks"],
        "all_zones_centrality": centrality_resilience["all_zones_centrality"],
        "routes": routes_results,
    }

    # Write JSON
    json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2, ensure_ascii=False)
    print(f"\n✅ JSON metrics saved to: {json_path.relative_to(root)}")

    # Load pre-cached urban street basemap
    basemap_img, bounds = load_cached_basemap(root)
    if basemap_img is not None and bounds is not None:
        print("✅ Pre-cached Managua street basemap loaded.")
    else:
        print("ℹ️  Running without basemap background (fallback mode).")

    # Render PNGs
    generate_topology_plot(G, zones, topo_plot_path, basemap_img, bounds)
    print(f"✅ Urban network topology saved to: {topo_plot_path.relative_to(root)}")

    generate_dijkstra_plot(
        G, zones, routes_results[0], dijkstra_plot_path, basemap_img, bounds
    )
    print(
        f"✅ Dijkstra routing comparison saved to: {dijkstra_plot_path.relative_to(root)}"
    )

    print("\n" + "=" * 60)
    print("Routing optimization analysis successfully completed!")
    print("=" * 60)


if __name__ == "__main__":
    main()
