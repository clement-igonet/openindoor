#!/usr/bin/env bash
# Fetch Gare de Lyon (Paris) indoor data from OpenStreetMap via Overpass → GeoJSON.
# Data © OpenStreetMap contributors (ODbL).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
# Walkable halls / concourse (west part of the station; the way bbox also
# includes the rail yard further east).
BBOX="48.8417,2.3710,48.8457,2.3775"   # S,W,N,E
OUT="$DIR/gare-de-lyon.geojson"

echo "Querying Overpass for bbox $BBOX ..."
curl -s --max-time 180 'https://overpass-api.de/api/interpreter' --data-urlencode "data=
[out:json][timeout:180];
(
  nwr[\"indoor\"]($BBOX);
  nwr[\"level\"][\"indoor\"!~\".\"][\"building\"!~\".\"]($BBOX);
  nwr[\"highway\"=\"elevator\"]($BBOX);
  nwr[\"highway\"=\"steps\"]($BBOX);
  nwr[\"room\"]($BBOX);
  nwr[\"shop\"]($BBOX);
  nwr[\"amenity\"=\"vending_machine\"]($BBOX);
  nwr[\"railway\"=\"platform\"]($BBOX);
  nwr[\"public_transport\"=\"platform\"]($BBOX);
  nwr[\"railway\"=\"subway_entrance\"]($BBOX);
);
out geom tags;" > "$DIR/raw.json"

python3 "$DIR/osm2geojson.py" "$DIR/raw.json" "$OUT"
