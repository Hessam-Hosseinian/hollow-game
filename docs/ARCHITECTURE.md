# Architecture

Godot 4.7.2, GDScript, Compatibility renderer. No autoloads or game framework.

- `AshenGame`: composition root, screens/run lifecycle, room ownership and signal routing.
- `VesselPlayer`: CharacterBody2D movement and ability timing. Form values are `FormData` resources; all combat constants live in `CombatRules`. Health remains shared; special cooldowns remain per form so switching cannot reset them.
- `Vitality`: shared health bounds and exactly-once death signal.
- `HollowMark`: timed one-shot cross-form combo component shared by enemies.
- `RemnantEnemy`: common seek/telegraph/recover/stagger/dead state machine. `EnemyData` selects melee, ranged, armored behavior. `CollectorBoss` extends it with three patterns, a second phase and a form-sensitive ward.
- `BoneProjectile`: Area2D, terrain/player collision, bounded lifetime.
- `RunDirector`: seed-local RNG, six-layout shuffled bags, controlled ten-room sequence, unique three-option reward selection. Room types are fixed for pacing; layouts and reward options vary by seed.
- `CathedralRoom`: resource geometry, TileMapLayer ground, one-way optional ledges, mandatory solid outer walls, exit presentation. Collision and decorative artwork are separate.
- `GameInterface`: UI flow/HUD; communicates through signals, works while gameplay is paused.
- `ActorVisual`, `PixelFX`, `CathedralBackdrop`: replaceable presentation; animated sprite atlas, sparse effects, parallax/ambient ash.
- `SoundDirector`: limited voice pool, music loop, independent volumes. Graceful shutdown gives the audio thread time to release playback resources.
- `SaveStore`: ConfigFile settings/best room/win count. No permanent upgrades. Tests use separate save paths.

Collision layers: 1 world, 2 player, 4 enemy. Actor bodies collide only with the world; enemy contact alone does not hurt. Damage comes from readable attack rectangles/projectiles. Soul Phase and Bone Dash retain world collision at all times. Transforming grants no invulnerability. A short room-entry grace prevents damage before the room is readable.

Scenes are assembled from small reusable scripted nodes at runtime. The main entry scene is `scenes/main/main.tscn`. This keeps ownership and art replacement simple; no fragile absolute scene paths are used. Resources are editor-editable. Placeholder generators are optional development tools, not runtime dependencies.

Hit-stop reduces Engine.time_scale for 45ms; real-time timers restore it. Simulation/UI pause is separate. Run serial guards cancel delayed result screens from abandoned runs. A removed room is immediately cleared from the owner reference to prevent double-removal on restart.

Physics body coordinates may be fractional. Camera and pixel transforms are snapped for rendering; no smoothing. Integer viewport scaling preserves the logical 640x360 raster. The source background is retained separately from its deliberately temporary 640x360 integration rendition.

Enemy spawns use `Array[Vector2]`. In the installed engine, a PackedVector2Array property loaded correctly from text but was empty after binary PCK resource export. A separate packed-game test validates the serialized arrays and starts an encounter.
