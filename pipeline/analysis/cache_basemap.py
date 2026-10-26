#!/usr/bin/env python3
"""
MoviGo Basemap Pre-caching Utility
----------------------------------
Downloads and stitches OpenStreetMap Standard raster tiles (zoom level 14)
covering the urban extent of Managua, Nicaragua (Leaflet default, 100% free,
zero API key required).

Saves:
  - pipeline/data/managua_basemap.png: Stitched RGB basemap
  - pipeline/data/managua_basemap_bounds.json: Bounding box coordinates
"""

from __future__ import annotations

import io
import json
import math
import sys
import urllib.request
from pathlib import Path
from PIL import Image

# Zoom level and tile ranges covering Managua's 12 platform quadrants
ZOOM = 14
X_MIN, X_MAX = 4263, 4268  # 6 horizontal tiles
Y_MIN, Y_MAX = 7634, 7637  # 4 vertical tiles
TILE_SIZE = 256

# OpenStreetMap Standard (Leaflet default, 100% free, zero API key required)
TILE_URL_TEMPLATE = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
USER_AGENT = "MoviGo-Academic-Research/1.0 (Universidad Nacional de Ingenieria Managua; academic paper dataset)"


def num2deg(xtile: int, ytile: int, zoom: int) -> tuple[float, float]:
    """Converts tile numbers (x, y, zoom) to geographic latitude and longitude."""
    n = 2.0**zoom
    lon_deg = (xtile / n) * 360.0 - 180.0
    lat_rad = math.atan(math.sinh(math.pi * (1.0 - 2.0 * (ytile / n))))
    lat_deg = math.degrees(lat_rad)
    return lat_deg, lon_deg


def compute_bounding_box(zoom: int = ZOOM) -> dict[str, float]:
    """Calculates the geographic bounding box of the stitched tile region."""
    north, west = num2deg(X_MIN, Y_MIN, zoom)
    south, east = num2deg(X_MAX + 1, Y_MAX + 1, zoom)
    return {
        "west": west,
        "east": east,
        "south": south,
        "north": north,
        "zoom": zoom,
        "x_min": X_MIN,
        "x_max": X_MAX,
        "y_min": Y_MIN,
        "y_max": Y_MAX,
    }


def fetch_tile(x: int, y: int, zoom: int = ZOOM) -> Image.Image:
    """Downloads a single map tile from CartoDB."""
    url = TILE_URL_TEMPLATE.format(z=zoom, x=x, y=y)
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=10) as response:
        tile_bytes = response.read()
    return Image.open(io.BytesIO(tile_bytes)).convert("RGB")


def stitch_basemap() -> tuple[Image.Image, dict[str, float]]:
    """Downloads all tiles in the grid and stitches them into a single PIL Image."""
    cols = (X_MAX - X_MIN) + 1
    rows = (Y_MAX - Y_MIN) + 1
    total_tiles = cols * rows

    width = cols * TILE_SIZE
    height = rows * TILE_SIZE
    stitched_image = Image.new("RGB", (width, height), color=(240, 240, 240))

    print(
        f"Downloading and stitching {total_tiles} OpenStreetMap tiles ({cols}x{rows}, zoom={ZOOM})..."
    )
    tile_count = 0

    for col_idx, x in enumerate(range(X_MIN, X_MAX + 1)):
        for row_idx, y in enumerate(range(Y_MIN, Y_MAX + 1)):
            tile = fetch_tile(x, y, ZOOM)
            px = col_idx * TILE_SIZE
            py = row_idx * TILE_SIZE
            stitched_image.paste(tile, (px, py))
            tile_count += 1
            print(f"  [{tile_count:2d}/{total_tiles}] Fetched tile x={x}, y={y}")

    bounds = compute_bounding_box(ZOOM)
    return stitched_image, bounds


def cache_basemap(force: bool = False) -> tuple[Path, Path]:
    """Generates and saves the pre-cached basemap image and metadata file."""
    root = Path(__file__).resolve().parent.parent.parent
    data_dir = root / "pipeline" / "data"
    data_dir.mkdir(parents=True, exist_ok=True)

    image_path = data_dir / "managua_basemap.png"
    bounds_path = data_dir / "managua_basemap_bounds.json"

    if image_path.exists() and bounds_path.exists() and not force:
        print(f"✅ Pre-cached basemap already exists: {image_path.relative_to(root)}")
        return image_path, bounds_path

    try:
        stitched_image, bounds = stitch_basemap()
        stitched_image.save(image_path, format="PNG", optimize=True)
        with open(bounds_path, "w", encoding="utf-8") as f:
            json.dump(bounds, f, indent=2)

        print(f"🎉 Pre-cached basemap successfully created:")
        print(f"   Image: {image_path.relative_to(root)} ({stitched_image.size})")
        print(f"   Bounds: {bounds_path.relative_to(root)}")
        print(
            f"   Extent: Lon [{bounds['west']:.4f}, {bounds['east']:.4f}], Lat [{bounds['south']:.4f}, {bounds['north']:.4f}]"
        )
        return image_path, bounds_path
    except Exception as exc:
        print(f"⚠️  Error downloading basemap tiles: {exc}", file=sys.stderr)
        if image_path.exists():
            print("   Using existing cached basemap on disk.", file=sys.stderr)
            return image_path, bounds_path
        raise


def main():
    force = "--force" in sys.argv
    cache_basemap(force=force)


if __name__ == "__main__":
    main()
