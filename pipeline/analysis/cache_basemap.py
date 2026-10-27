#!/usr/bin/env python3
"""
MoviGo Basemap Pre-caching Utility
----------------------------------
Downloads and stitches OpenStreetMap Standard raster tiles (zoom level 14)
covering the entire metropolitan urban extent of Managua, Nicaragua (Leaflet default,
100% free, zero API key required).

Saves:
  - pipeline/data/managua_basemap.png: Stitched RGB basemap (2560x2048 px)
  - pipeline/data/managua_basemap_bounds.json: Bounding box coordinates
  - pipeline/data/.osm_tile_cache/: Local cache of downloaded individual tiles
"""

from __future__ import annotations

import io
import json
import math
import sys
import time
import urllib.request
from pathlib import Path
from PIL import Image

# Zoom level and tile ranges covering all 24 urban zones and transactional trip extents
# Lon: [-86.3525, -86.1328], Lat: [12.0178, 12.1897]
ZOOM = 14
X_MIN, X_MAX = 4262, 4271  # 10 horizontal tiles
Y_MIN, Y_MAX = 7633, 7640  # 8 vertical tiles (80 tiles total)
TILE_SIZE = 256

# OpenStreetMap Standard (Leaflet default, 100% free, zero API key required)
PRIMARY_TILE_URL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
FALLBACK_TILE_URL = "https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"
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


def fetch_tile(x: int, y: int, zoom: int = ZOOM, tile_cache_dir: Path | None = None) -> Image.Image:
    """Downloads a single map tile from OSM or fallback provider, using a local disk cache."""
    cached_tile = None
    if tile_cache_dir is not None:
        cached_tile = tile_cache_dir / f"{zoom}_{x}_{y}.png"
        if cached_tile.exists():
            try:
                return Image.open(cached_tile).convert("RGB")
            except Exception:
                pass

    urls = [
        PRIMARY_TILE_URL.format(z=zoom, x=x, y=y),
        FALLBACK_TILE_URL.format(z=zoom, x=x, y=y),
    ]

    last_error: Exception | None = None
    for url in urls:
        for attempt in range(3):
            try:
                req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
                with urllib.request.urlopen(req, timeout=12) as response:
                    tile_bytes = response.read()
                img = Image.open(io.BytesIO(tile_bytes)).convert("RGB")
                if cached_tile is not None:
                    cached_tile.parent.mkdir(parents=True, exist_ok=True)
                    with open(cached_tile, "wb") as f:
                        f.write(tile_bytes)
                return img
            except Exception as exc:
                last_error = exc
                time.sleep(0.3 * (attempt + 1))

    raise RuntimeError(f"Failed to fetch tile ({zoom}, {x}, {y}) after retries: {last_error}")


def stitch_basemap(tile_cache_dir: Path | None = None) -> tuple[Image.Image, dict[str, float]]:
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
            tile = fetch_tile(x, y, ZOOM, tile_cache_dir=tile_cache_dir)
            px = col_idx * TILE_SIZE
            py = row_idx * TILE_SIZE
            stitched_image.paste(tile, (px, py))
            tile_count += 1
            if tile_count % 10 == 0 or tile_count == total_tiles:
                print(f"  [{tile_count:2d}/{total_tiles}] Tiles processed...")
            time.sleep(0.04)  # Polite pause adhering to OSM tile policy

    bounds = compute_bounding_box(ZOOM)
    return stitched_image, bounds


def cache_basemap(force: bool = False, clear_cache: bool = False) -> tuple[Path, Path]:
    """Generates and saves the pre-cached basemap image and metadata file."""
    root = Path(__file__).resolve().parent.parent.parent
    data_dir = root / "pipeline" / "data"
    data_dir.mkdir(parents=True, exist_ok=True)
    tile_cache_dir = data_dir / ".osm_tile_cache"

    if clear_cache and tile_cache_dir.exists():
        import shutil

        shutil.rmtree(tile_cache_dir)
        print("🧹 Local tile cache purged.")

    tile_cache_dir.mkdir(parents=True, exist_ok=True)

    image_path = data_dir / "managua_basemap.png"
    bounds_path = data_dir / "managua_basemap_bounds.json"

    # Verify if existing basemap matches the desired dimensions and bounds
    if image_path.exists() and bounds_path.exists() and not force:
        try:
            with open(bounds_path, "r", encoding="utf-8") as f:
                existing_bounds = json.load(f)
            if (
                existing_bounds.get("x_min") == X_MIN
                and existing_bounds.get("x_max") == X_MAX
                and existing_bounds.get("y_min") == Y_MIN
                and existing_bounds.get("y_max") == Y_MAX
            ):
                print(f"✅ Pre-cached basemap already exists and matches bounds: {image_path.relative_to(root)}")
                return image_path, bounds_path
            print("⚠️ Existing basemap has obsolete bounds. Regenerating with full metropolitan extent...")
        except Exception:
            pass

    try:
        stitched_image, bounds = stitch_basemap(tile_cache_dir=tile_cache_dir)
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
    clear_cache = "--clear-cache" in sys.argv
    cache_basemap(force=force, clear_cache=clear_cache)


if __name__ == "__main__":
    main()
