# ASHEN VESSEL — Playable Alpha Design

An ancient reliquary carries four states of one body through the Cathedral of Remains. Hollow Shift is voluntary, consumes energy, preserves health, and creates tactical opportunities. Original motifs: sealed relic mask, broken mantle, exposed reliquary core. No copied commercial game content.

## Implemented forms

| Form | Speed | Basic damage | Incoming damage factor | Special |
|---|---:|---:|---:|---|
| Whole | 140 | 24 | 0.85 | 0.32s parry, stagger, mark, +18 energy |
| Flesh | 112 | 35 | 1.00 | 58 damage Devour, heals 6 once on valid contact |
| Bone | 185 | 17 | 1.20 | 0.20s directional dash, applies Hollow Mark |
| Soul | 150 | 16 | 1.10 | 0.80s phase, costs 22 energy, retains world collision |

Configurable through `resources/forms/*.tres` and `resources/combat_rules.tres`. The requested 4x4 shift cost matrix is implemented. Hollow Energy is capped at 100, regenerates 7/s, earns 3 on hits, 8 on kills, 12 on varied-form mark detonation. Shift lock is 0.16s. Specials have independent form cooldowns. Basic Soul attacks apply marks. Same-form hits do not consume marks; cross-form hits consume them for 14 bonus damage. Marks last four seconds.

Movement: acceleration-free horizontal response, -430 jump velocity, 900 gravity, 110ms coyote time, 120ms jump buffer, early-release jump cut, ground/air dodge. Jump strength is higher than the initial suggested value so a 64px character can reach 64–96px ledges. Optional platforms are independently physics-tested. Dodge costs 8 energy and lasts 180ms, with 800ms cooldown. Receiving damage grants 720ms immunity. Shifts do not refresh immunity. Fall recovery costs health.

## Run structure

Ten rooms: combat, combat, reward, combat, rest, combat, combat, reward, combat, boss. Six hand-authored layouts are selected without repeats in each six-room bag. Continuous floors provide guaranteed basic traversal; optional one-way ledges support ranged positioning. Combat room counts rise from three to five; enemy health grows by tier. Combat gates remain sealed until all living enemies die. E activates altars and the exit when nearby. Rewards offer three unique choices from eight temporary upgrades. Rest grants 45 health and full energy once. No permanent character progression.

Three shared enemy archetypes: Ash Crawler approaches/patrols and strikes; Bone Sentry maintains distance and fires aimed projectiles; Hollow Penitent has heavy attacks and reduced damage taken outside recovery/stagger windows. Telegraph bars and attack direction lines communicate danger.

The Collector has 750 health, directional melee, low jumpable shockwaves, and aimed spectral projectiles. At half health it accelerates and fires a three-projectile fan. Changing the attacking form breaks its remembered-form ward for bonus damage. The HUD announces the second-phase rule. Attacks have recovery windows; phase/parry/jump/dodge offer distinct counters.

UI includes menu with optional numeric seed, HUD, pause/settings, upgrade cards, death/victory statistics, restart and abandon-run flow. Settings persist music, SFX, camera shake, fullscreen, best rooms and wins.

## Scope and remaining tuning

This is a functional alpha, not a finished commercial art/audio release. The 10–15 minute run target is not verified by unassisted human play. Automated completion intentionally injects positioning/attacks to test progression; it does not establish human difficulty or enjoyment. Enemy AI stays on the ground; ranged attacks pressure elevated players. Controller/remapping, polished locomotion frames, authored music, localized in-game text and permanent progression are not implemented. The next work is manual combat balancing and a production sprite/animation pass.
