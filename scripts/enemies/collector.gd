class_name CollectorBoss
extends RemnantEnemy
signal phase_changed(phase: int)
var phase: int = 1
var pattern: int = 0
var cycle: int = 0
var target_x: float = 0.0
var ward_form: int = -1

func think(_delta: float) -> void:
	if health.current < health.maximum * 0.5 and phase == 1:
		phase = 2
		phase_changed.emit(phase)
		combat_event.emit("boss", global_position-Vector2(0,70),Color("5d8fa9"))
	if state == "seek":
		facing = 1 if player.global_position.x > global_position.x else -1
		var distance := absf(player.global_position.x-global_position.x)
		if distance > 110.0:
			velocity.x += facing * data.speed * (1.25 if phase == 2 else 1.0)
		if state_time <= 0.0:
			pattern = cycle % 3
			cycle += 1
			start_telegraph()
			state_time = 1.15 if pattern == 1 else 0.85
			target_x = player.global_position.x
	elif state == "telegraph" and state_time <= 0.0:
		perform_attack()
		state = "recover"
		state_time = 1.45 if pattern == 1 else 1.0
	elif state in ["recover", "stagger"] and state_time <= 0.0:
		state = "seek"
		state_time = 0.65 if phase == 2 else 1.0

func perform_attack() -> void:
	combat_event.emit("boss",global_position-Vector2(0,65),Color("973e4a"))
	match pattern:
		0:
			var rect := Rect2(global_position+Vector2(-15 if attack_facing > 0 else -125,-100),Vector2(140,100))
			if rect.intersects(player.hurt_rect()):
				player.receive_hit(data.damage,self)
		1:
			# Ground shockwaves: low height, always jumpable, emitted from both sides.
			shoot(Vector2(-200,0),true,Vector2(-36,72))
			shoot(Vector2(200,0),true,Vector2(36,72))
		2:
			var direction := (player.global_position-Vector2(0,34)-(global_position-Vector2(0,81))).normalized()
			shoot(direction*185.0,true)
			if phase == 2:
				shoot(direction.rotated(-0.3)*165.0,true)
				shoot(direction.rotated(0.3)*165.0,true)

func receive_hit(amount: float, direction: int, heavy: bool = false) -> void:
	# Collector remembers the last form. A different form shatters the ward.
	if phase == 2 and is_instance_valid(player):
		if ward_form >= 0 and player.form != ward_form:
			amount += 12.0
			combat_event.emit("combo",global_position-Vector2(0,70),Color("5d8fa9"))
		ward_form = player.form
	super.receive_hit(amount,direction,heavy)

func _draw() -> void:
	super._draw()
	if health.dead:
		return
	if state == "telegraph" and pattern == 1:
		draw_line(Vector2(-180,-2),Vector2(180,-2),Color("973e4a"),4)
		draw_line(Vector2(-160,-7),Vector2(-160,-21),Color("e7ddbf"),2)
		draw_line(Vector2(160,-7),Vector2(160,-21),Color("e7ddbf"),2)
