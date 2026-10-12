# Art Bible — Cathedral of Remains

## Identity

Sacred emptiness, discarded identity, decay and rebirth. Original reliquary masks, open spiritual cores, fractured mantles and burial architecture unify the work. Never trace or transplant recognizable commercial game characters or maps.

## Palette

| Name | Hex | Purpose |
|---|---|---|
| Void Black | #101014 | negative space, deepest shadows |
| Deep Stone | #24242C | architecture, armor shadows |
| Ash Gray | #555260 | stone edges, dull steel |
| Bone Ivory | #D4C5A0 | bones, masks, interface |
| Dried Blood | #973E4A | flesh, danger |
| Soul Blue | #5D8FA9 | energy, marks, spectral effects |
| Tarnished Gold | #B18A55 | ritual details, rare accents |
| Pale Highlight | #E7DDBF | small sharp highlights |

Controlled intermediate shades permitted. Main lighting upper-left. Restrict bright colors to telegraphs, attacks, souls, candles and important UI. Characters must stand apart from lower-contrast architecture. Dense background detail is permitted only when it remains subordinate to combat silhouettes.

## Character production

Four forms share one mask/core/mantle motif. Side-view, facing right, feet at logical y=86, consistent pivot centered at (48,86) on a 96x96 transparent canvas. Target visible height 64–76 pixels. Sparse two- or three-pixel clusters, crisp edges, deliberate shading. Form identity: complete ceremonial armor; red exposed flesh; narrow ivory bones; desaturated spectral outline. The temporary crawler has a shorter quadruped silhouette. Production boss needs a separately authored larger canvas, not a permanently scaled humanoid.

Runtime atlas: six columns, nine rows, each frame 96x96. Rows idle/run/jump/fall/attack/special/hurt/transform/death. Current frames are generated original placeholders with minimal pose changes; they are not final animation production. Sprite configuration and sheet dimensions must be updated together if final frame counts change.

## Environment

32x32 stone tiles; one logical pixel per texture pixel. Separate collision geometry from candles, chains, broken supports and background. Preserve clean platform tops. Parallax is subtle; ambient ash is sparse. Optional ledges must be reachable with full jump. Backgrounds should contain arches, burial niches and ruined columns, with lower contrast than foreground actors. No soft bloom, glossy surfaces, saturated fantasy gradients or noisy foreground ornament.

## UI and effects

Void panels, thin ash/gold frames, ivory text, readable neutral font. Avoid tiny decorative gothic fonts. Blood indicates health/danger, blue indicates energy/phase, gold indicates rewards. Small, bounded pixel particles; short arcs, directional telegraphs, restrained adjustable camera shake and brief hit-stop. Telegraphs take priority over effects.

## Current production assessment

Acceptable: original masks and coherent muted palette; clean transparent sheets with consistent baseline; readable native-resolution combat/UI; source-generated cathedral backdrop retained for reference.

Temporary: procedural character/enemy animations, scaled prototype boss, synthesized soundscape, nearest-neighbor integrated cathedral rendition. Automated dimensions/transparency checks and engine screenshots validate technical integration, not final artistic quality. A detailed generated image is not automatically finished pixel art. The 640x360 backdrop is explicitly an interim rendition and needs an authored pixel cleanup pass.

Unacceptable: opaque sprite margins, unstable frame pivots, accidental blur, incompatible pixel sizes, commercial game tracing, brightly saturated environments, unreadable reward text, visual effects hiding enemy windup.
