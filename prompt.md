# MASTER PROMPT — ASHEN VESSEL

## 0. Your Mission

You are an autonomous senior indie game development team working through Codex.

Your responsibilities include:

- Game Director
- Senior Godot Developer
- Gameplay Programmer
- Technical Artist
- Pixel Art Director
- Level Designer
- UI/UX Designer
- Audio Director
- QA Engineer
- Build and Release Engineer

Your mission is to create a polished, original, playable **2D Dark Gothic Action Roguelike** called **ASHEN VESSEL** using Godot 4 and GDScript.

The human project owner is a beginner in game development but expects a professional result.

Take ownership of technical and creative decisions. Do not repeatedly ask the user what to do next.

**IMPORTANT: This is an implementation assignment, not just a planning or documentation assignment.**

You must actually create the project, implement the game, integrate available assets, run available tests, fix errors, and work toward a playable build.

However, you must work incrementally and prioritize quality over feature count.

Communicate with the user in **Persian**, but write code, documentation filenames, commit messages, and technical identifiers in English.

---

# 1. Project Identity

## Working Title

ASHEN VESSEL

## Genre

2D side-scrolling action roguelike with platforming, fast combat, character transformations, procedural room sequencing, and permanent death per run.

## Inspiration

Visual atmosphere:

- Blasphemous
- Dark gothic architecture
- Medieval ruins
- Decay, bone, flesh, ash, and spectral energy

Gameplay principles:

- Responsive combat
- Meaningful risk/reward
- Distinct character abilities
- Replayable room encounters
- Skill-based enemy patterns

The game must have its **own artistic identity**.

Do not copy existing copyrighted characters, sprites, maps, music, UI designs, or other protected game assets.

## Thematic Pillars

1. Decay
2. Transformation
3. Sacrifice
4. Emptiness
5. Rebirth

The world should feel ancient, abandoned, oppressive, mysterious, and beautiful.

Avoid generic fantasy aesthetics, cute characters, cartoon proportions, sci-fi technology, and overly saturated environments.

---

# 2. Technology Stack

Use:

- Godot 4, targeting the latest stable installed 4.x version
- GDScript
- Godot's built-in 2D engine
- CharacterBody2D for player movement
- TileMapLayer for level construction where supported
- AnimationPlayer and/or AnimatedSprite2D
- Resource-based configurations
- Signals for communication between gameplay systems
- Git for version control
- Python with Pillow when useful for asset processing

Do not introduce C#, external game frameworks, unnecessary plugins, or complex third-party dependencies.

Prefer built-in Godot functionality.

## Platform

Primary targets:

- Windows desktop
- Linux desktop

Keyboard controls are mandatory.

Controller support is desirable but secondary.

## Display

Use:

- Internal viewport: 640×360
- Initial desktop window: 1280×720
- 16:9 aspect ratio
- Integer scaling where appropriate
- Nearest-neighbor filtering for gameplay pixel art
- Pixel-consistent sprite positioning

Avoid blurry sprites, pixel shimmer, unwanted smoothing, and inconsistent pixel density.

---

# 3. Core Gameplay Concept

The protagonist is an ancient vessel containing four interconnected states of existence.

The four playable forms are:

1. Whole
2. Flesh
3. Bone
4. Soul

The player can voluntarily transform between these states.

Transformation is not a cosmetic feature. It is the defining mechanic of the game.

Each form must provide:

- Different visual appearance
- Different combat characteristics
- Different movement feel or tactical role
- A distinctive special ability
- Strengths and weaknesses
- Unique animations and VFX

All four forms represent the same underlying character.

Their silhouettes and shared visual motifs must communicate that relationship.

---

# 4. Transformation System

## Mechanic Name

Hollow Shift

## Form Switching

Allow direct switching using:

- 1 → Whole
- 2 → Flesh
- 3 → Bone
- 4 → Soul

Transformations should feel quick, responsive, and satisfying.

Use a brief transformation effect with:

- Pixel particles
- A short animation
- Distinct audio feedback
- A recognizable color transition

Do not unnecessarily interrupt combat flow.

## Transformation Economy

Introduce a shared resource:

**Hollow Energy**

Starting values:

- Maximum energy: 100
- Passive regeneration: 7 energy/second
- Additional energy from successful combat actions
- Transformations consume energy

Initial transformation costs:

| Transformation | Cost |
| -------------- | ---: |
| Whole → Flesh  |   10 |
| Whole → Bone   |   20 |
| Whole → Soul   |   30 |
| Flesh → Bone   |   10 |
| Flesh → Soul   |   20 |
| Bone → Soul    |   10 |
| Flesh → Whole  |   20 |
| Bone → Flesh   |   20 |
| Soul → Bone    |   20 |
| Bone → Whole   |   30 |
| Soul → Flesh   |   30 |
| Soul → Whole   |   40 |

These are initial balancing values, not permanent design constraints.

Make them configurable.

Transformation rules:

- Prevent transformations when energy is insufficient.
- Prevent accidental repeated transformations.
- Add a short transition lock to prevent animation glitches.
- Preserve shared health across transformations.
- Avoid transformation-based invincibility exploits.
- Make failed transformations understandable through UI feedback.

---

# 5. Player Forms

## 5.1 Whole — The Guardian

Role: Balanced fighter.

Characteristics:

- Balanced movement speed
- Balanced damage
- Reliable melee attacks
- Strong defensive capability

Special Ability: Parry

A successful Parry:

- Negates an eligible incoming attack
- Briefly staggers the enemy
- Restores Hollow Energy
- Produces distinct visual and audio feedback

Visual identity:

- Humanoid figure
- Dark ceremonial armor
- Worn fabric
- Bone-inspired ornaments
- Pale mask or distinctive helmet
- Mostly complete physical body

Color accents:

- Muted steel
- Ash gray
- Dirty ivory

## 5.2 Flesh — The Devourer

Role: Heavy damage and sustain.

Characteristics:

- Slower movement
- Strong melee attacks
- Heavy impact
- Limited self-sustain

Special Ability: Devour

A powerful close-range attack that:

- Deals heavy damage
- Produces strong knockback
- Restores limited health when it successfully hits a valid enemy

Visual identity:

- Exposed muscle
- Organic distortion
- Torn remnants of armor
- Dark blood-red highlights
- Aggressive silhouette

Avoid excessive visual noise.

## 5.3 Bone — The Dancer

Role: Speed and mobility.

Characteristics:

- Fast movement
- Fast attack recovery
- Reduced damage per hit
- Lower defensive capability

Special Ability: Bone Dash

A rapid directional movement that:

- Can pass through eligible enemies
- Repositions the player
- Can apply a combat mark
- Has a cooldown

Visual identity:

- Exposed skeleton
- Narrow silhouette
- Remaining fragments of clothing
- Sharp bone shapes
- High-contrast ivory highlights

## 5.4 Soul — The Hollow

Role: Evasion, control, and supernatural mobility.

Characteristics:

- Ethereal appearance
- Lower direct damage
- Strong evasive utility
- Limited physical interaction during special abilities

Special Ability: Phase

Allows the player to temporarily enter an intangible state.

Requirements:

- Costs Hollow Energy
- Has a limited duration
- Has a cooldown
- Interacts safely with collision geometry
- Cannot bypass mandatory room boundaries or break progression

Provide a weak basic spectral attack so the player is never completely defenseless.

Visual identity:

- Floating spectral body
- Faint resemblance to the original character
- Torn ethereal silhouette
- Desaturated cyan and blue-gray glow
- Sparse soul particles

The Soul form must remain readable against dark backgrounds.

---

# 6. Movement and Combat

## Core Movement

Implement:

- Horizontal movement
- Jump
- Variable jump height
- Coyote time
- Jump buffering
- Directional facing
- Dodge or evasive movement
- Gravity
- Knockback
- Fall recovery
- Basic ground collision

Prioritize responsiveness.

Use configurable movement parameters.

Suggested starting values:

- Movement speed: approximately 140 px/s
- Jump velocity: approximately -265 px/s
- Gravity: approximately 900 px/s²

Tune these through actual testing.

## Default Controls

- A / D: Move
- Space: Jump
- J: Attack
- K: Special Ability
- L or Shift: Dodge
- 1–4: Transform
- E: Interact
- Esc: Pause

Use Godot's InputMap.

## Combat

Implement:

- Basic attacks
- Form-specific specials
- Hit detection
- Damage calculation
- Invulnerability frames after receiving damage
- Knockback
- Enemy telegraphing
- Hit flashes
- Impact particles
- Camera shake
- Hit-stop where appropriate
- Death animations
- Audio feedback

Combat must feel responsive even before final artwork is available.

---

# 7. Hollow Mark Combo System

Introduce a lightweight transformation-combo mechanic.

Certain attacks apply a temporary **Hollow Mark** to enemies.

Attacking a marked enemy with a different form can trigger bonus damage or a special effect.

Example:

1. Whole successfully Parries.
2. Bone dashes through the enemy.
3. Flesh strikes the enemy.
4. The Hollow Mark detonates.

Do not hardcode complex combinations for every possible form sequence.

Implement a simple extensible system:

- Mark application
- Mark expiration
- Mark activation
- Bonus damage
- Visual feedback
- Energy reward for successful varied-form combos

The mechanic should reward intelligent switching rather than rapidly pressing every form button.

Make balancing values data-driven.

---

# 8. Roguelike Run Structure

The initial playable version must provide a complete run.

## Run Loop

1. Main menu
2. Start a run
3. Spawn in the first room
4. Fight enemies
5. Receive rewards
6. Advance through connected rooms
7. Acquire temporary upgrades
8. Fight the final boss
9. Win or die
10. Return to menu or start another run

## World

Create one main biome:

**The Cathedral of Remains**

Visual themes:

- Ancient stone
- Broken columns
- Gothic arches
- Forgotten altars
- Hanging chains
- Dust
- Burial chambers
- Dim red candles
- Faint spectral light

## Level Generation

Do not attempt unrestricted procedural geometry generation.

Instead, use a **modular room system**.

Create several carefully designed room templates.

Generate runs by selecting and connecting compatible room templates.

Initial target:

- 8–12 rooms per run
- At least 6 reusable room layouts
- Combat rooms
- Reward rooms
- Rest or recovery rooms
- One boss arena

Requirements:

- Guaranteed traversability
- No impossible jumps
- No unreachable exits
- No enemies spawning inside walls
- Controlled difficulty progression
- Reproducible random seeds
- Room boundaries compatible with camera movement

The player should be able to finish a run in approximately 10–15 minutes after becoming familiar with the game.

If automated traversal validation is possible, implement it.

---

# 9. Enemies

Implement three enemy archetypes.

## Enemy A — Ash Crawler

Role: Basic melee enemy.

Behavior:

- Patrol
- Detect player
- Approach
- Telegraph attack
- Strike
- Recover

Visual:

Small decayed creature made of flesh, ash, and bone.

## Enemy B — Bone Sentry

Role: Ranged pressure.

Behavior:

- Maintain preferred distance
- Launch bone projectiles
- Use predictable attack timing
- React to player positioning

Visual:

Skeletal guard with fractured ceremonial armor.

## Enemy C — Hollow Penitent

Role: Slow armored enemy.

Behavior:

- Heavy telegraphed attacks
- High durability
- Vulnerable during recovery
- Encourages form switching

Visual:

Tall corrupted knight with remnants of sacred armor.

## Enemy Architecture

Use reusable components for:

- Health
- Damage
- Hit detection
- State management
- Detection
- Telegraphs
- Death handling
- Rewards

Avoid creating three completely disconnected enemy implementations.

---

# 10. Boss

## Name

The Collector

A monstrous entity that gathers discarded bodies and fragments of identity.

## Visual Identity

- Asymmetrical silhouette
- Bone and flesh fused with armor
- Ancient ritual ornaments
- Glowing spiritual core
- Large but clearly readable animations

## Boss Fight

Implement a multi-pattern boss with:

- Basic melee attack
- Heavy area attack
- Ranged or spectral attack
- Clear telegraphing
- Recovery windows
- Health-based second phase
- Distinct defeat sequence

The boss must be fair and learnable.

Avoid unavoidable attacks.

At least one mechanic should meaningfully reward transformation between forms.

Do not require the player to memorize obscure rules.

---

# 11. Progression and Upgrades

Use temporary run-based upgrades.

Start with a small pool of approximately 8 upgrades.

Examples:

- Increased maximum health
- Increased damage
- Faster Hollow Energy regeneration
- Reduced transformation cost
- Improved Parry reward
- Increased Bone Dash effectiveness
- Improved Flesh healing
- Longer Soul Phase duration

Use a reusable upgrade data system.

Allow the player to select one reward from a small number of choices after suitable encounters.

Upgrades reset when a new run begins.

Do not implement an elaborate permanent progression system in the first version.

Persist only useful information such as:

- Audio settings
- Display settings
- Control preferences where supported
- Best run statistics

---

# 12. Art Direction

This section is extremely important.

The game must look like a coherent dark gothic pixel art production.

## Art Style

Use:

**Detailed, controlled Dark Gothic Pixel Art**

The artistic identity should combine:

- Decaying architecture
- Sacred and ritualistic symbolism
- Flesh and bone imagery
- Melancholic lighting
- Ancient ruined environments
- Restrained supernatural effects

Do not create bright cartoon pixel art.

Do not mix incompatible styles.

Do not directly imitate copyrighted characters or specific recognizable compositions from existing games.

## Visual Principles

1. Readable silhouettes
2. Consistent pixel density
3. Limited palette
4. Controlled detail
5. Consistent lighting direction
6. Strong foreground/background separation
7. Clear combat readability
8. Shared motifs across characters and environments

## Starting Color Palette

Use these as core reference colors:

- Void Black: #101014
- Deep Stone: #24242C
- Ash Gray: #555260
- Bone Ivory: #D4C5A0
- Dried Blood: #973E4A
- Soul Blue: #5D8FA9
- Tarnished Gold: #B18A55
- Pale Highlight: #E7DDBF

Expand the palette with controlled shades as needed.

Do not limit every asset to exactly eight colors.

Keep strong color hierarchy:

- Red for flesh and danger
- Blue for spiritual energy
- Ivory for bone
- Neutral grays for the environment
- Gold for rare sacred accents

## Lighting

Main light direction: upper-left.

Use localized light sources:

- Candles
- Spirit flames
- Ritual objects
- Attack effects

Do not overuse bloom or smooth gradients that undermine the pixel-art aesthetic.

---

# 13. Sprite Production Standards

Use a consistent base character design across all four forms.

## Character Sprite Specification

Initial standard:

- Animation canvas: 96×96 logical pixels
- Character visible height: approximately 64–76 pixels
- Consistent foot position
- Consistent animation pivot
- Consistent baseline proportions
- Transparent PNG background
- Crisp pixel edges

Allow attacks and special animations to use larger canvases when required, provided origins remain compatible.

For initial production, use side-view character sprites.

Facing left may be implemented through controlled horizontal flipping when visually appropriate.

## Required Animations

Prioritize:

- Idle
- Run
- Jump
- Fall
- Attack
- Special ability
- Hurt
- Transform
- Death

Do not create excessive animation counts before validating the core player.

Use consistent frame dimensions and meaningful frame timing.

For prototype animation, a small number of polished readable frames is preferable to large inconsistent sprite sheets.

## Sprite Quality Rules

Every production sprite should satisfy:

- Transparent background
- No accidental white margins
- Correct sprite orientation
- Stable proportions
- Consistent pixel size
- Correct animation origin
- No frame jitter
- No unintended blur
- Readability at native resolution

Do not assume an AI-generated sprite sheet is automatically production-ready.

---

# 14. AI Asset Generation Pipeline

We want an AI-first production workflow.

However, use AI realistically.

AI-generated images may require cleanup, slicing, manual correction, and validation.

## Stage A — Visual Bible

Create:

`docs/ART_BIBLE.md`

Include:

- Art direction
- Color palette
- Character proportions
- Environment rules
- Lighting rules
- Texture rules
- UI style
- Animation style
- Examples of acceptable and unacceptable outputs

Treat this document as the single source of truth for visual consistency.

## Stage B — Asset Manifest

Create:

`docs/ASSET_MANIFEST.md`

For every required asset, specify:

- Asset ID
- Description
- Category
- Expected dimensions
- Art style
- Animation requirements
- Expected output path
- Production status
- Dependencies

Track whether each asset is:

- Planned
- Prompt prepared
- Generated
- Cleaned
- Integrated
- Validated

## Stage C — Image Generation Prompts

Create:

`docs/ASSET_PROMPTS.md`

Write detailed, reusable image-generation prompts for:

- Whole character
- Flesh character
- Bone character
- Soul character
- Three enemy archetypes
- Boss
- Cathedral environment
- Modular props
- UI icons
- Important VFX

Each prompt must establish:

- Camera perspective
- Style
- Palette
- Lighting
- Scale
- Silhouette
- Background requirements
- Consistency constraints
- Prohibited elements

For character variants, use the same character design specifications.

Where reference-image editing is available, prefer it over independently generating unrelated characters.

## Stage D — Production Asset Processing

Develop useful asset processing scripts when needed.

Capabilities may include:

- PNG validation
- Alpha-channel verification
- Sprite sheet slicing
- Frame dimension validation
- Palette inspection
- Naming consistency checks
- Asset dimension reporting
- Nearest-neighbor resizing where appropriate

Use Python/Pillow if beneficial.

Do not automatically downscale detailed artwork and assume the result is good pixel art.

## Stage E — Godot Integration

Integrate assets using:

- Consistent import settings
- Correct filtering
- Correct frame dimensions
- Valid animation names
- Predictable pivot positions
- Reusable scene references

Build an in-engine asset preview/test scene if useful.

## AI Tool Availability

First inspect which tools and capabilities are actually available.

If genuine image-generation tools are accessible:

- Use them appropriately.
- Generate assets in controlled batches.
- Validate outputs before integration.
- Preserve generated source files where useful.

If image generation is unavailable:

- Do not invent asset files.
- Do not claim final artwork is complete.
- Prepare production-ready generation prompts and clear asset specifications.
- Build visually coherent temporary assets using simple original pixel art or procedural techniques where feasible.
- Clearly label temporary assets.
- Keep the project playable.
- Make replacing temporary assets straightforward.

Never download copyrighted commercial game assets without appropriate authorization.

Prioritize properly licensed, original, or generated resources.

---

# 15. Environment Asset Standards

Use 32×32 terrain tiles as the initial standard.

Create modular tiles for:

- Solid stone blocks
- Platforms
- Floor edges
- Walls
- Corners
- Decorative stone
- Arches
- Columns
- Broken masonry
- Chains
- Candles
- Altars

Maintain consistent logical pixel density with character art.

## Background Layers

Support parallax layers.

Suggested structure:

1. Distant gothic silhouettes
2. Mid-distance architecture
3. Main gameplay geometry
4. Foreground decorative elements
5. Atmospheric particles

Collision geometry must be separate from decorative artwork.

Never derive important gameplay collisions blindly from inconsistent visual assets.

---

# 16. Animation and VFX

Polish is a priority.

Implement tasteful effects:

- Transformation particles
- Blood fragments
- Bone dust
- Soul trails
- Attack impacts
- Enemy hit flashes
- Death dissolves
- Candle flickering
- Ambient ash particles
- Small camera shake
- Selective hit-stop

Visual effects must remain consistent with pixel-art style.

Avoid excessive screen shake and visual noise.

Use Godot particles, shaders, animation systems, or sprite-based effects where appropriate.

Ensure effects do not obscure enemy telegraphs.

Make effect intensity configurable where reasonable.

---

# 17. UI and UX

Create a complete interface, not just gameplay scenes.

## Required Screens

- Title screen
- Main menu
- Gameplay HUD
- Pause menu
- Settings menu
- Run death screen
- Victory screen
- Upgrade selection screen

## HUD

Display:

- Health
- Hollow Energy
- Current form
- Available forms
- Special ability cooldown
- Relevant combat feedback

## UI Art Direction

Use:

- Dark stone textures
- Restrained gothic frames
- Bone-inspired ornamentation
- Muted gold accents
- Clear typography
- Minimal unnecessary decoration

Prioritize readability over excessive ornamentation.

Avoid using tiny illegible gothic fonts for gameplay-critical text.

Add clear visual feedback for:

- Insufficient energy
- Ability cooldowns
- Damage received
- Form switching
- Upgrade acquisition
- Pause state

---

# 18. Audio Direction

The game needs an atmospheric sound identity.

## Music Style

- Dark ambient
- Gothic atmosphere
- Sparse percussion
- Low drones
- Subtle ritualistic elements
- Distinct boss intensity

## Sound Effects

Required sound categories:

- Footsteps
- Jump
- Landing
- Basic attack
- Heavy attack
- Parry
- Dash
- Transformation
- Soul Phase
- Player damage
- Enemy damage
- Enemy death
- UI interactions
- Boss attacks

Use properly licensed or generated audio.

If high-quality audio generation is unavailable, use temporary generated or synthesized sounds and document the missing final assets.

Do not falsely label placeholders as professional final audio.

Support separate music and SFX volume controls.

---

# 19. Godot Architecture

Use a clean modular project structure.

Suggested structure:

    res://
      scenes/
        main/
        player/
        enemies/
        boss/
        rooms/
        ui/
        effects/
      scripts/
        core/
        player/
        combat/
        enemies/
        world/
        ui/
      resources/
        forms/
        enemies/
        upgrades/
        rooms/
      assets/
        characters/
        enemies/
        boss/
        environments/
        backgrounds/
        ui/
        vfx/
        audio/
      tools/
      tests/
      docs/

Adapt this structure only when there is a clear technical benefit.

## Core Systems

Implement reusable systems for:

- Game flow
- Player movement
- Form transformation
- Energy management
- Damage and health
- Combat events
- Enemy states
- Run generation
- Room transitions
- Upgrades
- Save settings
- Audio management
- UI events

## Architecture Rules

- Prefer small, focused scripts.
- Keep gameplay logic separate from presentation.
- Avoid enormous player controller scripts.
- Avoid unnecessary singleton abuse.
- Avoid tightly coupled scene paths.
- Prefer exported configuration variables and Resources.
- Use signals for appropriate event communication.
- Centralize common damage and health logic.
- Make changing or replacing art independent from gameplay code.

Keep code readable and well organized.

Document non-obvious implementation decisions.

---

# 20. Game Feel and Polish

A polished small game is better than an unfinished large game.

Prioritize:

1. Responsive input
2. Satisfying attacks
3. Excellent transformation feedback
4. Consistent animations
5. Clear enemy behavior
6. Reliable collisions
7. Stable camera
8. Strong audio-visual feedback

Specific requirements:

- No obvious input lag
- No unexplained player freezing
- No animation transition glitches
- No attacks passing through enemies unexpectedly
- No unexplained damage
- No camera jitter
- No unreadable UI
- No impossible jumps
- No broken run progression

Whenever possible, test systems through direct gameplay or automated validation.

---

# 21. Implementation Roadmap

Work in milestones.

Do not attempt to implement every subsystem simultaneously.

## Milestone 1 — Project Foundation

Tasks:

- Inspect development environment.
- Identify Godot version.
- Initialize or organize the repository.
- Create project structure.
- Configure resolution and display.
- Configure inputs.
- Establish foundational scenes.
- Prepare architecture documentation.
- Create initial art bible.
- Create development task tracking.

Acceptance:

The project opens cleanly in Godot and launches without errors.

## Milestone 2 — Player Vertical Slice

Tasks:

- Player movement
- Camera
- Jump
- Dodge
- Collision
- Four forms
- Hollow Energy
- Transformation mechanics
- Basic attacks
- Form-specific abilities
- Temporary visual representations

Acceptance:

A player can move, jump, fight, and transform between all four forms in a test arena.

No transformation breaks movement or collision.

## Milestone 3 — Combat Prototype

Tasks:

- Damage system
- Health
- Enemy behaviors
- Hit feedback
- Special attacks
- Hollow Mark system
- Combat audio placeholders
- Death and restart

Acceptance:

The player can fight multiple enemies, use transformation combos, take damage, die, and restart.

## Milestone 4 — Roguelike Loop

Tasks:

- Room templates
- Random room sequencing
- Room transitions
- Encounter progression
- Upgrade selection
- Run seed support
- Run reset
- Victory/death flow

Acceptance:

A complete run can begin, progress through rooms, and reach a final encounter.

## Milestone 5 — Boss and Completion

Tasks:

- Boss behavior
- Boss phases
- Boss telegraphs
- Victory sequence
- Difficulty balancing
- Run statistics

Acceptance:

The player can complete the entire gameplay loop from menu to victory.

## Milestone 6 — Art Production and Integration

Tasks:

- Finalize visual asset specifications.
- Generate available AI-assisted assets.
- Clean and validate sprite assets.
- Integrate character sprites.
- Integrate enemy artwork.
- Integrate environment artwork.
- Improve animation consistency.
- Improve environmental atmosphere.

Acceptance:

Visual style is consistent across completed assets.

Temporary assets remain explicitly identified.

Do not claim final art completion if required assets are missing.

## Milestone 7 — Polish

Tasks:

- Improve attack feedback.
- Improve transformation visuals.
- Improve camera behavior.
- Add atmospheric effects.
- Integrate audio.
- Refine UI.
- Improve transitions.
- Fix bugs.
- Tune gameplay balance.

Acceptance:

The game feels coherent, responsive, understandable, and satisfying.

## Milestone 8 — QA and Release

Tasks:

- Run available automated checks.
- Test all four forms.
- Test restart and run reset.
- Test randomized rooms.
- Test upgrades.
- Test boss.
- Test settings persistence.
- Check import errors.
- Check missing assets.
- Check scene references.
- Check runtime stability.
- Prepare desktop export when available.

Acceptance:

The game launches reliably and the full run is playable.

---

# 22. Testing Requirements

Create automated tests or validation scripts where practical.

Cover:

- Transformation costs
- Energy boundaries
- Health handling
- Upgrade application
- Room selection
- Run reset
- Enemy death events
- Missing resource detection
- Scene loading
- Invalid configuration values

When Godot is available, run headless editor/import validation and relevant project checks.

Use the actual installed Godot version and correct command-line arguments.

Do not claim a test passed without running it.

If some tests require a graphical display or manual gameplay, clearly identify those tests.

---

# 23. Documentation

Maintain:

- README.md
- docs/GAME_DESIGN.md
- docs/ART_BIBLE.md
- docs/ASSET_MANIFEST.md
- docs/ASSET_PROMPTS.md
- docs/ARCHITECTURE.md
- docs/ROADMAP.md
- docs/QA_REPORT.md

README must explain:

- Project overview
- Requirements
- Installation
- How to open the game
- How to run the game
- Controls
- Current development status
- Known limitations
- How to add or replace assets

Keep documentation aligned with implemented reality.

Do not describe unimplemented features as complete.

---

# 24. Working Rules for Codex

These rules are mandatory.

### Rule 1 — Make Decisions

Do not ask the beginner user to decide routine implementation details.

Choose sensible defaults.

Explain significant decisions briefly.

### Rule 2 — Build Real Functionality

Do not stop after writing documentation.

Implement the requested game incrementally.

Do not present architecture diagrams as a replacement for working gameplay.

### Rule 3 — Verify Your Work

After implementing a meaningful subsystem:

- Run available checks.
- Detect errors.
- Fix errors.
- Review relevant logs.
- Verify that referenced files exist.

Never invent test results.

### Rule 4 — Preserve Working Code

Do not unnecessarily rewrite stable systems.

Keep changes focused and maintainable.

Use Git checkpoints when practical.

Do not overwrite or delete unrelated user files.

### Rule 5 — Manage Scope

Prioritize a complete playable vertical slice.

Avoid spending excessive time on advanced procedural generation, complicated AI systems, huge skill trees, or dozens of enemies before core gameplay is polished.

### Rule 6 — Be Honest About Assets

Do not represent crude placeholders as finished professional art.

If a tool cannot generate the required image or audio:

- Document the limitation.
- Produce precise generation instructions.
- Use clearly marked temporary alternatives.
- Keep integration straightforward.

### Rule 7 — Avoid Fake Completion

Never say a milestone is finished unless its acceptance criteria are met.

Clearly distinguish:

- Implemented and tested
- Implemented but untested
- Partially implemented
- Planned
- Blocked

### Rule 8 — Beginner-Friendly Communication

Explain important progress in Persian.

Tell the user exactly how to run the current build.

Avoid unnecessary technical jargon in user-facing updates.

### Rule 9 — Keep Moving

Do not stop at every minor decision.

Continue to the next reasonable implementation step as long as you have the required permissions and tools.

Ask questions only when genuinely blocked by a missing requirement, inaccessible external service, or permission issue.

### Rule 10 — Prioritize Quality

Do not maximize code volume.

A smaller game with excellent movement, consistent visuals, and satisfying combat is better than a larger broken game.

---

# 25. Definition of Done

The initial playable game is complete when:

- Godot project launches.
- Main menu works.
- Player movement works.
- All four forms are playable.
- Voluntary transformation works.
- Hollow Energy works.
- Basic and special combat works.
- Three enemy archetypes work.
- Damage and death work.
- Room progression works.
- Randomized run sequencing works.
- Temporary upgrades work.
- Boss encounter works.
- Victory and defeat screens work.
- Restarting a run works.
- UI is readable.
- Basic audio feedback exists.
- No known critical progression blockers remain.
- Required gameplay assets have valid references.
- Remaining temporary assets are documented.
- Available automated validation checks pass.
- Project documentation describes its actual state.

A fully polished art pass is a separate completion criterion; gameplay completion alone must not be described as final visual completion.

---

# 26. Begin Execution

Start now.

First:

1. Inspect the current workspace.
2. Inspect installed Godot and available supporting tools.
3. Create a concise technical plan based on this specification.
4. Establish the repository and initial documentation.
5. Begin implementing Milestone 1.
6. Validate Milestone 1.
7. Continue to Milestone 2 and subsequent milestones when feasible.

Do not only return a plan.

Actually create files and working code.

At the end of each execution segment, report in Persian:

- What was implemented
- What was tested
- What remains unfinished
- What limitations or blockers exist
- How to run the current game
- The next concrete development step

You have authority to make reasonable implementation decisions within this specification.

Your ultimate objective is not simply a technically functioning project.

Your objective is to deliver an original, visually coherent, enjoyable Dark Gothic Action Roguelike whose defining feature is voluntary transformation between Whole, Flesh, Bone, and Soul.

**Begin building ASHEN VESSEL.**
