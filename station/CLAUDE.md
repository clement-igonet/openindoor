# CLAUDE.md — openindoor/station

Context for Claude Code when working in this subfolder. See the parent
[`../CLAUDE.md`](../CLAUDE.md) for repo-wide setup (GitHub auth: operate as
`clement-igonet` / `clement@igonet.fr`, **never** the connektica account; deploy
via GitHub Pages).

## Goal

An immersive, multi-level **station walkthrough** on **MapLibre GL JS**: move a
player through Gare de Lyon (Paris) in first person, change floors via
**elevators / stairs / escalators**, and trigger actions — **check-in, board a
train, enter a shop, buy tickets**. Lean on MapLibre heavily (fill-extrusion
walls, fill floors, symbols, a custom first-person camera, level filtering).

## Target area

- Gare de Lyon, Paris — GPS `48.844533, 2.374633`.
- OSM railway station: way `726629180`; bbox ≈ `48.8417,2.3717 → 48.8457,2.3811`.
  (The full way includes the rail yard to the east; the walkable concourse/halls
  are the western part — clip to the building if the yard adds noise.)
- Reference render: <https://indoorequal.org/#map=18.08/48.844533/2.374633/11.1/57>

## Data pipeline

- Source: **OpenStreetMap** indoor data (the openindoor/indoorequal community
  dataset), via the public **Overpass API** — no key needed.
- `data/fetch.sh` runs the Overpass query for the station bbox and writes
  `data/gare-de-lyon.geojson` (converted from OSM JSON).
- Relevant tags (Simple Indoor Tagging):
  - `indoor=room|area|corridor|wall|level|yes`, `level=<n>`, `repeat_on=<a;b>`,
    `min_level`/`max_level`.
  - vertical: `highway=elevator`, `highway=steps`, `conveying=yes|forward|backward`
    (escalator/travolator), `room=stairs|elevator`.
  - POIs: `shop=*`, `amenity=ticket_validator|vending_machine`,
    `vending=public_transport_tickets`, `railway=subway_entrance`, platforms
    (`railway=platform`, `public_transport=platform`).
- **Attribution is required**: “© OpenStreetMap contributors” (ODbL).

## Rendering model (intended)

- Parse each feature's `level` (handle `repeat_on`/ranges → expand to a set of
  integer levels). Keep one **active level**; render floor (`fill`) + walls
  (`fill-extrusion`, base 0 → ~3 m).
- A level selector (and elevator/stairs nodes) switch the active level.
- First-person camera: reuse the `f3d` eye-rig (`jumpTo` with elevated `center`
  + fixed zoom + `setCenterClampedToGround(false)` at near-90° pitch).
- Collision/movement constrained to walkable `indoor` areas; circulation nodes
  teleport/transition between levels.

## Conventions

- Static site, no build step; lives at `/station/` (add to the Pages workflow
  `for demo in …` list and link from the root `index.html` when ready).
- Keep this file updated as the model/data/decisions evolve.
- Don't commit huge raw OSM dumps; keep `data/` to the trimmed GeoJSON we use.
