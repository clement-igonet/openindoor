# OpenIndoor — Station

An immersive, multi-level **station walkthrough** built with **MapLibre GL JS**.
You move through a real railway station in first person and travel between
levels the way a passenger does — taking **elevators, stairs and escalators** —
with interaction points to **check in, board a train, enter a shop, and buy
tickets**.

## Area

- **Station:** Gare de Lyon, Paris (France).
- **GPS:** `48.844533, 2.374633` — view on indoorequal:
  <https://indoorequal.org/#map=18.08/48.844533/2.374633/11.1/57>
- **OSM:** railway station way [`726629180`](https://www.openstreetmap.org/way/726629180)
  · bbox ≈ `48.8417, 2.3717` → `48.8457, 2.3811`.

## Data

The indoor model comes from **OpenStreetMap** indoor data — the same data the
**openindoor / indoorequal** community renders — using the
[Simple Indoor Tagging](https://wiki.openstreetmap.org/wiki/Simple_Indoor_Tagging)
scheme: `indoor=room|area|corridor|wall`, `level=*` (and `repeat_on=*`),
vertical circulation (`highway=elevator|steps`, `conveying=*`), plus shops,
ticket machines and platforms.

It is fetched from the public **Overpass API** into [`data/`](data/) as GeoJSON.
To refresh it:

```bash
./data/fetch.sh        # queries Overpass for the station bbox → data/gare-de-lyon.geojson
```

> Map data © OpenStreetMap contributors (ODbL). Indoor tiles concept: indoorequal / openindoor.

## How it works (planned)

- **Levels.** Features carry an OSM `level` (e.g. `-2 … 2`). The renderer shows
  one active level at a time (floor `fill`, walls as `fill-extrusion`), and a
  level selector / vertical-circulation nodes let the player change floors.
- **Camera.** A MapLibre first-person / near-level camera (reusing the
  `jumpTo` eye-rig from the `f3d` demos), walking the concourse and platforms.
- **Interactions.** Elevators & stairs move you between levels; tagged points
  (check-in, ticket machine, shop entrances, train doors) trigger actions.

## Run locally

Static site, no build step — serve the folder and open it:

```bash
# from the repo root (Apple `container` + Caddy, see ../docker-compose.yml)
container-compose up -d        # → http://localhost:8080/station/
```

## Status

Bootstrapping: retrieving the Gare de Lyon indoor dataset from the community
(OSM/Overpass). Rendering, level switching and interactions come next.
