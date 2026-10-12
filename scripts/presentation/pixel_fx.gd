class_name PixelFX
extends Node2D
var particles: Array[Dictionary] = []
var arcs: Array[Dictionary] = []
var rng := RandomNumberGenerator.new()

func burst(at: Vector2, tint: Color, count: int = 12, force: float = 90.0) -> void:
	for i in count:
		particles.append({"pos": at, "vel": Vector2(rng.randf_range(-force, force), rng.randf_range(-force, 20)), "life": rng.randf_range(0.2, 0.6), "color": tint, "size": rng.randi_range(1, 3)})

func slash(at: Vector2, facing: int, tint: Color, heavy: bool = false) -> void:
	arcs.append({"pos": at, "facing": facing, "color": tint, "life": 0.14, "heavy": heavy})

func _process(delta: float) -> void:
	for i in range(particles.size()-1, -1, -1):
		particles[i].life -= delta
		particles[i].vel.y += 200.0 * delta
		particles[i].pos += particles[i].vel * delta
		if particles[i].life <= 0.0:
			particles.remove_at(i)
	for i in range(arcs.size()-1, -1, -1):
		arcs[i].life -= delta
		if arcs[i].life <= 0.0:
			arcs.remove_at(i)
	queue_redraw()

func _draw() -> void:
	for p in particles:
		draw_rect(Rect2(p.pos.round(), Vector2.ONE * p.size), p.color)
	for a in arcs:
		var radius := 58.0 if a.heavy else 45.0
		var center: Vector2 = a.pos
		var start := -1.25 if a.facing > 0 else PI - 1.25
		draw_arc(center, radius, start, start+2.5, 13, a.color, 3.0)
