# F3D — Festung 3D

A browser homage to the **legendary early-1990s first-person shooter** that
defined the genre — rebuilt, against the odds, on top of a *map renderer*.

There is no raycaster and no game engine. Every wall is a real
**georeferenced building** drawn by [MapLibre GL JS](https://maplibre.org/) as a
3D `fill-extrusion`, and the first-person view comes from MapLibre's standard
camera, rigged to sit at eye level inside the maze. It's a demo of how far a
mapping library can be pushed past maps. *Festung* is German for "fortress" —
fitting for a corridor crawl through stone halls.

**Play it:** [`/f3d`](https://clement-igonet.github.io/openindoor/f3d/)

## Controls

| Input | Action |
| --- | --- |
| `↑` / `↓` | move forward / back |
| `←` / `→` | turn left / right |
| `W` `A` `S` `D` (or `Z` `Q` `S` `D` on AZERTY) | move / strafe |
| mouse or trackpad (after click → pointer-lock) | look |
| `Esc` | release the pointer |

Keyboard input is read by **physical key position** (`KeyboardEvent.code`), so
the movement cluster works the same on QWERTY (`WASD`) and AZERTY (`ZQSD`); the
on-screen hint relabels itself to your layout via the Keyboard Map API. A
top-down **minimap** and a debug readout show your position and the camera state.

## How it works

- The level is an ASCII grid (`MAZE`) — `#` wall, `.` open, `S` start.
- The grid is laid out in **metres** near `lng/lat = 0,0`, then converted to
  degrees (`DEG = 1/111320`) so MapLibre can render it.
- Walls → a GeoJSON `FeatureCollection` drawn as a `fill-extrusion` layer
  (`WALL_H` tall); a floor polygon + a dark background layer stand in for ground
  and ceiling/sky.
- **The camera.** MapLibre has no free-camera API (that's Mapbox-only), so the
  first-person eye is faked with the standard camera. MapLibre orbits around a
  ground `center`, with the eye `D·sin(pitch)` behind and `D·cos(pitch)` above
  it (`D` = eye→center distance, fixed by zoom + viewport). So each frame we put
  `center` that distance *ahead* of the player and choose the zoom that makes the
  eye land at `EYE_H`. The eye ends up at the player, looking down the heading;
  turning rotates the look-point around the fixed eye → true first-person turn.
- Movement is per-axis with simple grid collision.

## Tuning

Constants at the top of the script: `CELL` (cell size), `WALL_H`, `EYE_H`,
`PITCH` (≤ `maxPitch` = 85°), `MOVE`, `TURN`, `MOUSE_SENS`, and the wall-colour
`PALETTE`. Edit `MAZE` to change the level.

## Notes

- Uses **MapLibre GL JS v5** (from a CDN). MapLibre caps pitch at **85°**, so a
  truly 90° horizontal view isn't possible; 85° + tall walls keeps it enclosed.
- This is an original homage built for learning and fun — no game assets, code,
  maps, or trademarks from the original are used.
