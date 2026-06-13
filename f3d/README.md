# W3D — Wolfenstein-style 3D (demo #1)

A first-person maze rendered **entirely with MapLibre GL JS** — no raycaster.
Every wall is a real `fill-extrusion` polygon and the view comes from MapLibre's
**free camera** placed at eye height, looking toward the horizon.

Served at `<github-page-url>/w3d`.

## Controls

| Input | Action |
| --- | --- |
| `W` / `S` | move forward / back |
| `A` / `D` | strafe left / right |
| mouse (pointer-lock) or `←` / `→` | turn |
| `Esc` | release the mouse |

Click the canvas to capture the mouse.

## How it works

- The level is an ASCII grid (`MAZE`) — `#` wall, `.` open, `S` start.
- The grid is laid out in **metres** near `lng/lat = 0,0`, then converted to
  degrees (`DEG = 1/111320`) so MapLibre can render it.
- Walls → a GeoJSON `FeatureCollection` drawn as a `fill-extrusion` layer
  (`WALL_H` tall); a single floor polygon + a dark background layer act as
  ground and sky.
- Each animation frame: read input → move with simple per-axis collision
  against the grid → place the camera via `setFreeCameraOptions` at `EYE`
  height looking 1 km down the current heading (≈ level view).

## Tuning

Constants at the top of the script: `CELL` (cell size), `WALL_H`, `EYE`,
`MOVE` (speed), `TURN`, `MOUSE_SENS`, and the `PALETTE` of wall colours.
Edit `MAZE` to change the level.

## Notes

- Targets **MapLibre GL JS v5** (loaded from unpkg) for free-camera support.
- The near-horizontal view relies on the free camera bypassing the normal pitch
  limit; if a future MapLibre version clamps it, raise `EYE`/`WALL_H` or revisit
  the camera code.
