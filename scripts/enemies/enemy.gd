class_name RemnantEnemy
extends CharacterBody2D
signal died(enemy: RemnantEnemy)
signal combat_event(kind: String, at: Vector2, tint: Color)
var data: EnemyData
var health := Vitality.new()
var mark := HollowMark.new()
var visual := ActorVisual.new()
var player: VesselPlayer
var state: String = "seek"
var state_time: float = 0.5
var facing: int = -1
var attack_facing: int = -1
var knockback: float = 0.0
var tier: float = 1.0
var death_time: float = 0.0
var patrol_dir: int = -1

func _ready() -> void:
	add_to_group("enemies")
	collision_layer = 4
	collision_mask = 1
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(24*data.size_scale,data.body_height)
	shape.shape = rect
	shape.position.y = -data.body_height/2.0
	add_child(shape)
	add_child(health)
	health.configure(data.health * tier)
	health.depleted.connect(_die)
	add_child(mark)
	add_child(visual)
	visual.configure(data.sprite_path, data.size_scale)
	state_time = randf_range(0.25, 0.7)

func _physics_process(delta: float) -> void:
	velocity.y += 900.0 * delta
	knockback = move_toward(knockback, 0.0, 350.0 * delta)
	if health.dead:
		death_time += delta
		velocity.x = knockback
		visual.show_state("death", facing)
		move_and_slide()
		if death_time > 0.75:
			queue_free()
		return
	if not is_instance_valid(player) or player.health.dead:
		velocity.x = 0.0
		move_and_slide()
		return
	state_time -= delta
	velocity.x = knockback
	think(delta)
	move_and_slide()
	position.x = clampf(position.x, 40.0, 1235.0)
	var animation_name := "idle"
	if absf(velocity.x) > 5.0:
		animation_name = "run"
	if state == "telegraph":
		animation_name = "special"
	elif state == "recover" and state_time > data.recovery * 0.65:
		animation_name = "attack"
	elif state == "stagger":
		animation_name = "hurt"
	visual.show_state(animation_name, facing)
	queue_redraw()

func think(_delta: float) -> void:
	var distance := absf(player.global_position.x-global_position.x)
	if state == "seek":
		facing = 1 if player.global_position.x > global_position.x else -1
		if distance > 620.0:
			velocity.x += patrol_dir * data.speed * 0.3
			if is_on_wall() or position.x < 120.0 or position.x > 1170.0:
				patrol_dir *= -1
		elif data.archetype == "sentry":
			if distance < 145.0:
				velocity.x -= facing * data.speed
			elif distance > 280.0:
				velocity.x += facing * data.speed
			if state_time <= 0.0 and distance < 450.0:
				start_telegraph()
		else:
			if distance > data.reach - 12.0:
				velocity.x += facing * data.speed
			elif state_time <= 0.0 and absf(player.global_position.y-global_position.y) < 80.0:
				start_telegraph()
	elif state == "telegraph" and state_time <= 0.0:
		perform_attack()
		state = "recover"
		state_time = data.recovery
	elif state in ["recover", "stagger"] and state_time <= 0.0:
		state = "seek"
		state_time = 0.25

func start_telegraph() -> void:
	state = "telegraph"
	state_time = data.telegraph
	attack_facing = facing

func perform_attack() -> void:
	combat_event.emit("heavy" if data.archetype == "penitent" else "attack", global_position-Vector2(0,32),Color("973e4a"))
	if data.archetype == "sentry":
		shoot((player.global_position-Vector2(0,35)-global_position+Vector2(0,45)).normalized()*210.0, false)
	else:
		var reach := data.reach
		var rect := Rect2(global_position + Vector2(-12 if attack_facing > 0 else -reach, -data.body_height), Vector2(reach+12,data.body_height))
		if rect.intersects(player.hurt_rect()):
			player.receive_hit(data.damage, self)

func shoot(motion: Vector2, spectral: bool, offset: Vector2 = Vector2.ZERO) -> void:
	var projectile := BoneProjectile.new()
	projectile.position = global_position - Vector2(0,45*data.size_scale) + offset
	projectile.motion = motion
	projectile.damage = data.damage * 0.65
	projectile.owner_enemy = self
	projectile.spectral = spectral
	get_parent().add_child(projectile)

func receive_hit(amount: float, direction: int, heavy: bool = false) -> void:
	if health.dead:
		return
	var armor := 0.7 if data.archetype == "penitent" and state not in ["recover", "stagger"] else 1.0
	health.damage(amount * armor)
	visual.flash_time = 0.09
	knockback = direction * (150.0 if heavy else 70.0) / data.size_scale
	if heavy and data.archetype != "collector":
		stagger(0.4)
	combat_event.emit("hit", global_position-Vector2(0,30), Color("d4c5a0"))

func stagger(duration: float) -> void:
	state = "stagger"
	state_time = duration

func hurt_rect() -> Rect2:
	return Rect2(global_position-Vector2(16*data.size_scale,data.body_height), Vector2(32*data.size_scale,data.body_height))

func _die() -> void:
	remove_from_group("enemies")
	combat_event.emit("death", global_position-Vector2(0,35), Color("d4c5a0"))
	died.emit(self)

func _draw() -> void:
	if health.dead:
		return
	var y := -data.body_height-13.0
	if health.current < health.maximum:
		draw_rect(Rect2(-20, y-7, 40, 3), Color("24242c"))
		draw_rect(Rect2(-20, y-7, 40*health.current/health.maximum, 3), Color("973e4a"))
	if mark.remaining > 0.0:
		draw_circle(Vector2(0,y+1), 5, Color("5d8fa9"))
		draw_line(Vector2(-7,y+1),Vector2(7,y+1),Color("e7ddbf"),1)
	if state == "telegraph":
		var progress := clampf(1.0-state_time/data.telegraph, 0.0, 1.0)
		draw_rect(Rect2(-10,y-14,20,3), Color("24242c"))
		draw_rect(Rect2(-10,y-14,20*progress,3), Color("e7ddbf"))
		draw_line(Vector2(0,-35),Vector2(attack_facing*data.reach,-35),Color(0.59,0.24,0.29,0.6),2)
