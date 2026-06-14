#!/usr/bin/env python3
"""Convert an Overpass `out geom` JSON dump to GeoJSON (nodes→Point,
ways→Polygon/LineString, relations→MultiPolygon). Usage: osm2geojson.py in.json out.geojson"""
import sys, json

src, dst = sys.argv[1], sys.argv[2]
data = json.load(open(src))
feats = []
for e in data.get("elements", []):
    tags = e.get("tags", {})
    t = e["type"]
    geom = None
    if t == "node":
        if not tags:
            continue
        geom = {"type": "Point", "coordinates": [e["lon"], e["lat"]]}
    elif t == "way":
        g = e.get("geometry")
        if not g:
            continue
        coords = [[p["lon"], p["lat"]] for p in g]
        closed = len(coords) >= 4 and coords[0] == coords[-1]
        geom = ({"type": "Polygon", "coordinates": [coords]} if closed
                else {"type": "LineString", "coordinates": coords})
    elif t == "relation":
        outers, inners = [], []
        for m in e.get("members", []):
            if m.get("type") != "way" or "geometry" not in m:
                continue
            ring = [[p["lon"], p["lat"]] for p in m["geometry"]]
            (inners if m.get("role") == "inner" else outers).append(ring)
        if not outers:
            continue
        polys = [[o] for o in outers]
        for inn in inners:           # naive: attach holes to the first outer
            polys[0].append(inn)
        geom = {"type": "MultiPolygon", "coordinates": polys}
    else:
        continue
    props = dict(tags)
    props["@id"] = f"{t}/{e['id']}"
    feats.append({"type": "Feature", "properties": props, "geometry": geom})

json.dump({"type": "FeatureCollection", "features": feats}, open(dst, "w"))
print(f"features: {len(feats)} -> {dst}")
