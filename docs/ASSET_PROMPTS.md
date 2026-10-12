# Production Prompts

Default tool: built-in image_gen. The generated cathedral source was copied into this repository; no project reference points into a tool cache. Character production below is prepared, not generated. Use one asset per controlled request, then inspect and validate.

## Universal production constraints

Original dark gothic pixel art for ASHEN VESSEL. Strict side-view orthographic camera for sprites/terrain. Restrained palette #101014 #24242C #555260 #D4C5A0 #973E4A #5D8FA9 #B18A55 #E7DDBF with controlled intermediate shades. Light from upper-left. No commercial game tracing, logos, text, watermarks, cute/cartoon proportions, saturated fantasy colors, sci-fi details, glossy rendering, blur, anti-aliased edges or accidental white margins. Preserve logical pixel clusters; technical alpha/frame dimensions/pivots require separate QA.

## Shared vessel reference

Create a single right-facing idle side-view figure on a truly transparent background. 96x96 logical-pixel design, visible height 64–76 pixels, feet baseline y=86, pivot (48,86), natural human proportions. Ancient reliquary mask, fractured ceremonial armor, worn black mantle, bone ornaments, small exposed spiritual core. Readable silhouette at native scale. This reference anchors all forms. Ask for one coherent pose, not an unvalidated large sprite sheet. Retain the source image and manually align final frames.

### Whole — The Guardian

Use the shared reference as identity-preserving input. Complete dark ceremonial armor, muted steel and ash, dirty ivory relic mask, narrow tarnished-gold core frame. Balanced upright stance, worn mantle, a simple ritual blade with original silhouette. Transparent background, upper-left light, same baseline, head/body proportions and logical scale. Production animations: idle/run/jump/fall/attack/parry/hurt/transform/death. Generate controlled small batches, preserve identity between poses.

### Flesh — The Devourer

Edit the accepted Whole reference; preserve the same mask, overall height, feet baseline and core location. Expose controlled muscle shapes beneath torn armor, dark dried-blood red shadows, heavier aggressive shoulders and claw-like close-range striking hand. No excessive anatomical visual noise. Transparent background and matching upper-left lighting. Required special: readable heavy Devour windup/contact/recovery; include the nine standard animation families.

### Bone — The Dancer

Edit the accepted Whole reference; preserve mask proportions, baseline and relic core. Narrow ivory skeleton, sharp readable bone shapes, sparse fragments of the same mantle, clear limbs with enough contrast against black architecture. Agile forward stance, no unrelated character redesign. Transparent background, identical scale/light. Required special: dash start/travel/recovery; include nine standard animation families.

### Soul — The Hollow

Edit the same reference, retaining its recognizable mask silhouette and core. Floating torn spectral body, muted cyan/blue-gray edge clusters, sparse translucent internal fragments. Maintain an apparent baseline/pivot compatible with physical forms. Bright enough to read against charcoal stone, no soft bloom or blurred edges. Transparent background. Required special: short phase dissolve/hold/reappear, plus the nine standard animation families. Alpha must remain visible at native scale.

## Enemies

### Ash Crawler

Right-facing original decayed quadruped, approximately 28–36px tall on a 96x96 transparent canvas; feet baseline 86. Flesh, ash and bone fragments, readable low silhouette, dried red flank and ivory jaw. Upper-left light and shared palette. Clear crawl cycle, lifted-head bite windup, contact/recovery, hurt and ash dissolve. Avoid overlong spikes that make collision misleading.

### Bone Sentry

Right-facing skeletal ceremonial guard, approximately 64px visible height on 96x96 transparent canvas, baseline 86. Fractured neutral armor, ivory mask/skull and clearly posed bone-launching arm. Predictable ranged windup and recovery, short retreat/run cycle, hurt/death frames. Same pixel density and light as the vessel. No gun/science-fiction details.

### Hollow Penitent

Right-facing tall, slow corrupted knight, approximately 72–76px visible height on 96x96 transparent canvas, baseline 86. Broad sacred shoulder plate, charcoal steel with tiny dried-red ritual marks, visibly heavy weapon, bone/gold ornaments. Readable long windup, heavy directional strike, exposed recovery pose. Same palette/light/density. No borrowed named-game armor silhouette.

## The Collector

Original side-view asymmetrical ritual monster, fused flesh/bone/armor, discarded reliquary masks, a pale blue spiritual core. Create a larger 192x192 production canvas with approximately 128–150px visible height, feet baseline and origin documented before integration. Do not simply upscale a humanoid sprite. Right-facing, transparent background, upper-left light, muted palette. Keep dangerous limbs and core highly readable. Separate melee windup/strike/recovery, floor shockwave ritual, spectral projectile release, second-phase state, defeat/dissolve. Fewer consistent frames are better than an incoherent long sheet.

## Cathedral environment — prompt used with built-in image_gen

Use case: stylized-concept. Asset type: game background for original ASHEN VESSEL, a 2D dark gothic action game. Create a wide 16:9 side-view pixel-art interior of the Cathedral of Remains, monumental ruined pointed arches, weathered burial niches, tall broken columns, dangling chains, subtle dim red candles and pale spectral light deep in the cathedral. No characters, no text, no UI, no logos. Restrained palette #101014 #24242C #555260 #D4C5A0 #973E4A #5D8FA9 #B18A55. Crisp carefully controlled pixel clusters with deliberate dithering, no painterly brushwork or blur; oppressive and melancholic atmosphere; upper-left light, strong muted dark silhouette layers, center and lower area low contrast to allow foreground action readability. Architecture only, no gameplay floor or ledges. Original composition, avoid recognizable existing game scenes. The background is concept-quality until in-engine QA.

Result: `assets/source/cathedral_generated.png`. Integration rendition: `assets/backgrounds/cathedral.png`; interim only. A cleanup pass is required before calling it final production pixel art.

## Modular props and terrain

Side-view native-pixel modular cathedral stone tiles, 32x32 logical cells, separate individually framed assets for solid stone, platform top/edge/corner, wall, decorative block and broken masonry. Upper-left stone edge lighting, muted charcoal palette. Seamless neighboring cells, crisp flat collision-facing surfaces. Transparent background for separate arch, column, chain, candle and altar props; no perspective distortion, text or scene floor baked into decorations. Draw prop sets in controlled batches; validate slicing and scale manually.

## UI icons

Original relic glyphs for Whole mask, Flesh muscle, Bone ribs, Soul core, eight upgrades and four abilities. Orthographic flat icon view, consistent 16x16 or 24x24 logical frames, ivory marks on transparent background, optional one-pixel gold accent. Clear at native resolution; no text, noisy decorative borders or copyrighted symbols. Keep icon silhouettes distinct and sizes identical.

## VFX

Side-view transient pixel effects, transparent background, controlled frame grid and stable pivot: 96x96 for transformation/hit, larger compatible canvas for slash. Sparse ivory dust for bone, restrained dried-red fragments for flesh, blue-gray spectral trail for soul. Upper-left highlights, short bounded trails, deliberate pixel clusters. Telegraphs remain unobscured. Request one animation family per generation; validate every frame's alpha and extent. No blurred radial gradients or screen-filling glow.

## Audio production brief

No audio-generation service was used. Current WAVs are explicitly temporary original synthesis. Final music: sparse gothic ambient drones and ritual percussion, loopable transitions, distinct boss intensity. Final SFX: footsteps/jump/landing/light-heavy strike/parry/dash/shift/phase/hurt/enemy hit/death/UI/boss. Avoid copied music or samples without a license. Preserve separate music/SFX volume control.
