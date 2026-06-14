#!/usr/bin/env bash
# Fetch building shells / walls around the Gare de Lyon building area from OSM
# (Overpass) → GeoJSON, for the external 3D view (fill-extrusion).
# `building` = footprints; `building:part` = Simple-3D-Buildings massing.
# Data © OpenStreetMap contributors (ODbL).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
BBOX="48.8410,2.3700,48.8465,2.3790"   # S,W,N,E — station building + surroundings
OUT="$DIR/buildings.geojson"

echo "Querying Overpass (buildings) for bbox $BBOX ..."
curl -s --max-time 180 'https://overpass-api.de/api/interpreter' --data-urlencode "data=
[out:json][timeout:180];
(
  way[\"building\"]($BBOX);
  relation[\"building\"]($BBOX);
  way[\"building:part\"]($BBOX);
  relation[\"building:part\"]($BBOX);
  way[\"barrier\"=\"wall\"]($BBOX);
);
out geom tags;" > "$DIR/raw-buildings.json"

python3 "$DIR/osm2geojson.py" "$DIR/raw-buildings.json" "$OUT"
