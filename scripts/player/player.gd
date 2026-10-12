class_name VesselPlayer
extends CharacterBody2D
signal died
signal feedback(message: String)
signal shifted(form: int)
signal combat_event(kind: String, at: Vector2, tint: Color)
signal struck_enemy(enemy: Node, combo: bool)

var rules: CombatRules = preload("res://resources/combat_rules.tres")
var forms: Array[FormData] = []
var form: int = 0
var energy: float = 100.0
var health := Vitality.new()
var visual := ActorVisual.new()
var facing: int = 1
var shift_lock: float = 0.0
var attack_timer: float = 0.0
var special_timer: float = 0.0
var special_cooldowns: PackedFloat32Array = [0,0,0,0]
var dodge_cooldown: float = 0.0
var dodge_time: float = 0.0
var phase_time: float = 0.0
var dash_time: float = 0.0
var parry_time: float = 0.0
var invulnerable: float = 0.0
var coyote: float = 0.0
var jump_buffer: float = 0.0
var knockback: float = 0.0
var step_time: float = 0.0
var dash_hits: Array[int] = []
var damage_bonus: float = 0.0
var regen_bonus: float = 0.0
var shift_discount: float = 0.0
var parry_bonus: float = 0.0
var dash_bonus: float = 0.0
var heal_bonus: float = 0.0
var phase_bonus: float = 0.0
var kills: int = 0
var combos: int = 0
var shifts: int = 0
var dead_time: float = 0.0
var spawn_point := Vector2(100,300)

func _ready() -> void:
	add_to_group("player")
	collision_layer = 2
	collision_mask = 1
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(22, 62)
	shape.shape = rectangle
	shape.position.y = -31
	add_child(shape)
	add_child(health)
	health.configure(140.0)
	health.depleted.connect(_die)
	for key in ["whole", "flesh", "bone", "soul"]:
		forms.append(load("res://resources/forms/%s.tres" % key))
	add_child(visual)
	visual.configure(forms[0].sprite_path)
	energy = rules.max_energy

func _physics_process(delta: float) -> void:
	if health.dead:
		dead_time += delta
		visual.show_state("death", facing)
		velocity.x = move_toward(velocity.x, 0.0, delta * 600)
		velocity.y += rules.gravity * delta
		move_and_slide()
		return
	energy = minf(rules.max_energy, energy + (rules.energy_regen + regen_bonus) * delta)
	shift_lock = maxf(0.0, shift_lock - delta)
	attack_timer = maxf(0.0, attack_timer - delta)
	special_timer = maxf(0.0, special_timer - delta)
	for i in 4:
		special_cooldowns[i] = maxf(0.0, special_cooldowns[i] - delta)
	dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
	dodge_time = maxf(0.0, dodge_time - delta)
	phase_time = maxf(0.0, phase_time - delta)
	dash_time = maxf(0.0, dash_time - delta)
	parry_time = maxf(0.0, parry_time - delta)
	invulnerable = maxf(0.0, invulnerable - delta)
	jump_buffer = maxf(0.0, jump_buffer - delta)
	coyote = rules.coyote_time if is_on_floor() else maxf(0.0, coyote - delta)
	if Input.is_action_just_pressed("jump"):
		jump_buffer = rules.jump_buffer
	var axis := Input.get_axis("move_left", "move_right")
	if axis != 0.0 and dash_time == 0.0 and dodge_time == 0.0:
		facing = 1 if axis > 0.0 else -1
	for i in 4:
		if Input.is_action_just_pressed("form_%d" % i):
			transform(i)
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("special"):
		special()
	if Input.is_action_just_pressed("dodge"):
		dodge()
	if jump_buffer > 0.0 and coyote > 0.0:
		velocity.y = rules.jump_speed
		jump_buffer = 0.0
		coyote = 0.0
		combat_event.emit("jump", global_position, forms[form].tint)
	if Input.is_action_just_released("jump") and velocity.y < -120.0:
		velocity.y *= 0.48
	velocity.y += rules.gravity * delta
	knockback = move_toward(knockback, 0.0, 650.0 * delta)
	var speed := forms[form].speed
	velocity.x = axis * speed + knockback
	if dash_time > 0.0:
		velocity.x = facing * 480.0
		velocity.y = 0.0
		_dash_contacts()
	elif dodge_time > 0.0:
		velocity.x = facing * 300.0
	var was_floor := is_on_floor()
	move_and_slide()
	if is_on_floor() and not was_floor:
		combat_event.emit("land", global_position, forms[form].tint)
	step_time -= delta
	if is_on_floor() and absf(velocity.x) > 25.0 and step_time <= 0.0:
		step_time = 0.32
		combat_event.emit("step", global_position, forms[form].tint)
	if position.y > 520.0:
		position = spawn_point
		velocity = Vector2.ZERO
		receive_hit(15, null, false)
	var state := "idle"
	if absf(velocity.x) > 10.0:
		state = "run"
	if not is_on_floor():
		state = "jump" if velocity.y < 0.0 else "fall"
	if attack_timer > forms[form].recovery * 0.35:
		state = "attack"
	if special_timer > 0.0 or phase_time > 0.0 or dash_time > 0.0:
		state = "special"
	if shift_lock > 0.0:
		state = "transform"
	visual.show_state(state, facing)
	visual.self_modulate.a = 0.45 if phase_time > 0.0 else (0.65 if invulnerable > 0.0 and int(invulnerable*20)%2 else 1.0)

func transform(target: int) -> bool:
	if target == form or target < 0 or target >= 4 or health.dead:
		return false
	if shift_lock > 0.0 or dash_time > 0.0 or phase_time > 0.0 or special_timer > 0.0:
		return false
	var cost := rules.shift_cost(form, target) * (1.0 - shift_discount)
	if not spend_energy(cost):
		return false
	form = target
	shift_lock = rules.transform_lock
	parry_time = 0.0
	shifts += 1
	visual.configure(forms[form].sprite_path)
	shifted.emit(form)
	combat_event.emit("shift", global_position - Vector2(0,32), forms[form].tint)
	return true

func spend_energy(amount: float) -> bool:
	if amount < 0.0:
		return false
	if energy + 0.001 < amount:
		feedback.emit("NOT ENOUGH HOLLOW ENERGY")
		return false
	energy = clampf(energy - amount, 0.0, rules.max_energy)
	return true

func attack() -> void:
	if attack_timer > 0.0 or shift_lock > 0.0 or special_timer > 0.0 or health.dead:
		return
	attack_timer = forms[form].recovery
	_melee(forms[form].damage, 0.0, false)
	combat_event.emit("attack", global_position - Vector2(0,32), forms[form].tint)

func _melee(damage: float, healing: float, heavy: bool) -> int:
	var hit_count := 0
	var reach := 90.0 if heavy else (110.0 if form == 3 else 72.0)
	var attack_rect := Rect2(global_position + Vector2(-12 if facing > 0 else -reach, -77), Vector2(reach+12,80))
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health.dead or not attack_rect.intersects(enemy.hurt_rect()):
			continue
		var combo: bool = enemy.mark.activate(form)
		var amount := damage * (1.0 + damage_bonus) + (rules.mark_bonus if combo else 0.0)
		enemy.receive_hit(amount, facing, heavy)
		if form == 3:
			enemy.mark.apply(form, rules.mark_duration)
		energy = minf(rules.max_energy, energy + rules.hit_energy + (rules.combo_energy if combo else 0.0))
		if combo:
			combos += 1
			combat_event.emit("combo", enemy.global_position-Vector2(0,30), forms[form].tint)
		struck_enemy.emit(enemy, combo)
		hit_count += 1
	if hit_count > 0 and healing > 0.0:
		health.heal(healing)
	return hit_count

func special() -> void:
	if health.dead or shift_lock > 0.0 or special_timer > 0.0 or dash_time > 0.0 or phase_time > 0.0:
		return
	if special_cooldowns[form] > 0.0:
		feedback.emit("%s IS RECOVERING" % forms[form].special_name)
		return
	if not spend_energy(forms[form].special_cost):
		return
	special_cooldowns[form] = forms[form].special_cooldown
	match form:
		0:
			parry_time = 0.32
			special_timer = 0.32
			feedback.emit("PARRY WINDOW")
		1:
			special_timer = 0.55
			_melee(58.0, 6.0 + heal_bonus, true)
			combat_event.emit("heavy", global_position-Vector2(0,32), forms[form].tint)
		2:
			dash_time = 0.2
			dash_hits.clear()
			combat_event.emit("dash", global_position-Vector2(0,32), forms[form].tint)
		3:
			phase_time = 0.8 + phase_bonus
			combat_event.emit("phase", global_position-Vector2(0,32), forms[form].tint)

func _dash_contacts() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health.dead or dash_hits.has(enemy.get_instance_id()):
			continue
		if hurt_rect().grow(12).intersects(enemy.hurt_rect()):
			dash_hits.append(enemy.get_instance_id())
			enemy.mark.apply(2, rules.mark_duration + (2.0 if dash_bonus > 0.0 else 0.0))
			if dash_bonus > 0.0:
				enemy.receive_hit(dash_bonus, facing, false)
			combat_event.emit("dash", enemy.global_position-Vector2(0,30), forms[2].tint)

func dodge() -> void:
	if dodge_cooldown > 0.0 or health.dead or dash_time > 0.0 or special_timer > 0.0:
		return
	if not spend_energy(8.0):
		return
	dodge_time = 0.18
	dodge_cooldown = 0.8
	combat_event.emit("dash", global_position-Vector2(0,30), forms[form].tint)

func receive_hit(amount: float, attacker: Node, parryable: bool = true) -> bool:
	if health.dead or invulnerable > 0.0 or phase_time > 0.0 or dodge_time > 0.0 or dash_time > 0.0:
		return false
	if form == 0 and parry_time > 0.0 and parryable:
		parry_time = 0.0
		energy = minf(rules.max_energy, energy + rules.parry_energy + parry_bonus)
		if is_instance_valid(attacker) and attacker.has_method("stagger"):
			attacker.stagger(1.2)
			attacker.mark.apply(0, rules.mark_duration)
		combat_event.emit("parry", global_position-Vector2(0,35), forms[0].tint)
		feedback.emit("PARRY  /  HOLLOW MARK")
		return false
	if health.damage(amount * forms[form].defense):
		invulnerable = 0.72
		knockback = -facing * 150.0
		if is_instance_valid(attacker) and attacker is Node2D:
			knockback = signf(global_position.x-attacker.global_position.x) * 170.0
		velocity.y = -100.0
		visual.flash_time = 0.12
		combat_event.emit("hurt", global_position-Vector2(0,30), Color("973e4a"))
		return true
	return false

func hurt_rect() -> Rect2:
	return Rect2(global_position-Vector2(11,62), Vector2(22,62))

func apply_upgrade(upgrade: UpgradeData) -> void:
	match upgrade.stat:
		"max_health": health.increase_maximum(upgrade.amount)
		"damage": damage_bonus += upgrade.amount
		"regen": regen_bonus += upgrade.amount
		"shift": shift_discount = minf(0.6, shift_discount + upgrade.amount)
		"parry": parry_bonus += upgrade.amount
		"dash": dash_bonus += upgrade.amount
		"heal": heal_bonus += upgrade.amount
		"phase": phase_bonus += upgrade.amount

func _die() -> void:
	combat_event.emit("death", global_position-Vector2(0,30), forms[form].tint)
	died.emit()
