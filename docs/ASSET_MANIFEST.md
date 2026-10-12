# Asset Manifest

Status applies to the stated quality tier. “Validated” means technical checks and engine integration; it does not mean final production art. Everything shipped is original/generated or part of Godot's built-in UI font.

| ID | Description / category | Dimensions | Animations | Output | Status | Dependencies / remaining work |
|---|---|---|---|---|---|---|
| AV-WHOLE | Guardian character, temporary procedural pixel art | 576x864 sheet; 96x96 frames | 9 rows x 6 frames | `assets/characters/whole.png` | Temporary / integrated / validated | shared motif; replace with polished production frames |
| AV-FLESH | Devourer character, same mask/core | same | same | `assets/characters/flesh.png` | Temporary / integrated / validated | Whole reference, final anatomy/attack pass |
| AV-BONE | Dancer character, narrow ivory skeleton | same | same | `assets/characters/bone.png` | Temporary / integrated / validated | Whole reference, final locomotion pass |
| AV-SOUL | Hollow character, spectral outline | same | same | `assets/characters/soul.png` | Temporary / integrated / validated | Whole reference, readable alpha/trails |
| AV-CRAWLER | Low flesh/bone quadruped | same | same | `assets/enemies/crawler.png` | Temporary / integrated / validated | authored melee/death frames |
| AV-SENTRY | Skeletal ceremonial ranged guard | same | same | `assets/enemies/sentry.png` | Temporary / integrated / validated | proper ranged windup pose |
| AV-PENITENT | Wide armored sacred remnant | same | same | `assets/enemies/penitent.png` | Temporary / integrated / validated | taller distinct production silhouette |
| AV-COLLECTOR | Asymmetrical flesh/armor/core boss | same, integer-scaled prototype | same | `assets/boss/collector.png` | Temporary / integrated / validated | larger authored canvas, pattern-specific animation |
| AV-CATHEDRAL-SRC | AI-generated gothic architectural background | 1672x941 source | static | `assets/source/cathedral_generated.png` | Generated / retained reference | built-in image_gen, prompt in ASSET_PROMPTS |
| AV-CATHEDRAL | Interim nearest-neighbor background rendition | 640x360 | static + runtime parallax | `assets/backgrounds/cathedral.png` | Interim / integrated / visually checked | source; final pixel cleanup and coherent logical density needed |
| AV-STONE | Original 32px stone atlas | 96x32, three tiles | static | `assets/environments/stone.png` | Temporary / integrated / validated | clean TileMapLayer collisions |
| AV-PROPS | Candles, chains, altars, gate frames | runtime pixel drawing | candle flicker | `scripts/world/cathedral_room.gd` | Temporary / integrated | replace drawings or retain coherent code-native props |
| AV-SIGIL | Original reliquary application icon | 128x128 SVG | static | `assets/ui/sigil.svg` | Integrated | palette, shared motif |
| AV-UI | Gothic frames, form indicators, status bars | native 640x360 UI | state-based | `scripts/ui/game_interface.gd` | Integrated / visually checked | built-in readable font; dedicated glyph artwork planned |
| AV-VFX | Slash, shift, hit, ash, mark feedback | runtime pixel effects | transient | `scripts/presentation/pixel_fx.gd` | Temporary / integrated | sparse original drawing; authored sprites planned |
| AV-SFX | 15 synthesized effect categories | PCM16 mono 22050Hz | 0.065–0.55s | `assets/audio/{attack,heavy,parry,dash,shift,phase,hurt,hit,death,jump,land,step,ui,boss,combo}.wav` | Temporary / integrated / validated | original synthesis, production sound design missing |
| AV-MUSIC | Ambient and boss drone beds | PCM16 mono 22050Hz | 12s looping beds | `assets/audio/{ambient,boss_drone}.wav` | Temporary / integrated / validated | original synthesis, composed music missing |
| AV-FINAL-ENV | Final arches, columns, floor corners, masonry, foreground layers | modular 32px tiles; larger props | static/flame | future `assets/environments/production/` | Planned / prompts prepared | native pixel scale and collision-independent integration |
| AV-FINAL-ICONS | Form/upgrade/special glyph atlas | 16px or 24px icons | static | future `assets/ui/production/` | Planned / prompts prepared | consistent bone/gold frame system |

Generators: `tools/generate_placeholder_assets.py`, `tools/create_resources.py`, `tools/create_enemies.py`. Do not run them over production replacement files: generators intentionally regenerate prototype outputs. Run `tools/validate_assets.py` after processing. All current sheets are RGBA and every frame has transparent corners; death opacity preserves the original alpha mask.
