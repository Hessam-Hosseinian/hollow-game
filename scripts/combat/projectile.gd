class_name BoneProjectile
extends Area2D
var motion := Vector2.ZERO
var damage: float = 12.0
var owner_enemy: Node
var spectral: bool = false
var life: float = 4.0
var grace: float = 0.06

func _ready() -> void:
	collision_layer = 0
	collision_mask = 3
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(10,8)
	shape.shape = rect
	add_child(shape)
	body_entered.connect(_on_body)
	add_to_group("projectiles")

func _physics_process(delta: float) -> void:
	grace -= delta
	life -= delta
	position += motion * delta
	rotation = motion.angle()
	if life <= 0.0:
		queue_free()
	queue_redraw()

func _on_body(body: Node) -> void:
	if grace > 0.0 and not body is VesselPlayer:
		return
	if body is VesselPlayer:
		body.receive_hit(damage, owner_enemy)
	queue_free()

func _draw() -> void:
	var color := Color("5d8fa9") if spectral else Color("d4c5a0")
	draw_line(Vector2(-9,0),Vector2(7,0),color,3)
	draw_rect(Rect2(-9,-3,3,6), color)
	draw_rect(Rect2(5,-3,3,6), color)
