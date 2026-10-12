class_name ActorVisual
extends AnimatedSprite2D
const ANIMATIONS := ["idle", "run", "jump", "fall", "attack", "special", "hurt", "transform", "death"]
var flash_time: float = 0.0

func configure(path: String, scale_factor: float = 1.0) -> void:
	var sheet: Texture2D = load(path)
	var frames := SpriteFrames.new()
	for row in ANIMATIONS.size():
		var anim: String = ANIMATIONS[row]
		frames.add_animation(anim)
		frames.set_animation_speed(anim, 12.0 if anim in ["run", "attack", "transform"] else 8.0)
		frames.set_animation_loop(anim, anim in ["idle", "run", "jump", "fall"])
		for column in 6:
			var atlas := AtlasTexture.new()
			atlas.atlas = sheet
			atlas.region = Rect2(column * 96, row * 96, 96, 96)
			frames.add_frame(anim, atlas)
	sprite_frames = frames
	scale = Vector2.ONE * scale_factor
	position = Vector2(0, -38 * scale_factor)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	play("idle")

func show_state(state: String, facing: int) -> void:
	flip_h = facing < 0
	if animation != state:
		play(state)

func _process(delta: float) -> void:
	flash_time = maxf(0.0, flash_time - delta)
	modulate = Color(2, 1.7, 1.4) if flash_time > 0.0 else Color.WHITE
