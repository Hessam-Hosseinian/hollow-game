class_name AshenGame
extends Node2D
var store := SaveStore.new()
var director := RunDirector.new()
var sound := SoundDirector.new()
var ui := GameInterface.new()
var backdrop := CathedralBackdrop.new()
var room: CathedralRoom
var player: VesselPlayer
var camera := Camera2D.new()
var effects := PixelFX.new()
var boss: CollectorBoss
var room_index: int = 0
var alive: int = 0
var running: bool = false
var elapsed: float = 0.0
var shake_time: float = 0.0
var shake_strength: float = 0.0
var reward_claimed: bool = false
var rooms_cleared: int = 0
var run_serial: int = 0
var transition_lock: bool = false
var return_seed: int = 0

func _ready() -> void:
	InputSetup.install()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if store.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var layer := CanvasLayer.new()
	layer.layer = -10
	add_child(layer)
	layer.add_child(backdrop)
	backdrop.process_mode = Node.PROCESS_MODE_ALWAYS
	sound.store = store
	add_child(sound)
	ui.store = store
	ui.sound = sound
	add_child(ui)
	ui.start_requested.connect(start_run)
	ui.restart_requested.connect(func(): start_run(int(Time.get_unix_time_from_system())))
	ui.menu_requested.connect(show_menu)
	ui.resume_requested.connect(resume_game)
	ui.pause_requested.connect(pause_game)
	ui.quit_requested.connect(quit_game)
	get_tree().auto_accept_quit = false
	ui.upgrade_selected.connect(_choose_upgrade)
	camera.position = Vector2(320,180)
	camera.position_smoothing_enabled = false
	camera.limit_smoothed = false
	add_child(camera)
	camera.make_current()
	add_child(effects)
	show_menu()
	var args := OS.get_cmdline_user_args()
	if "--autostart" in args:
		var seed_value := 12345
		for arg in args:
			if arg.begins_with("--seed="):
				seed_value = arg.trim_prefix("--seed=").to_int()
		start_run(seed_value)

func start_run(seed_value: int) -> void:
	get_tree().paused = false
	run_serial += 1
	_discard_room()
	if is_instance_valid(player):
		remove_child(player)
		player.queue_free()
	player = VesselPlayer.new()
	add_child(player)
	player.died.connect(_on_player_died)
	player.feedback.connect(ui.notify)
	player.combat_event.connect(_combat_event)
	player.struck_enemy.connect(_on_struck_enemy)
	director.begin(seed_value)
	return_seed = seed_value
	room_index = 0
	rooms_cleared = 0
	elapsed = 0.0
	running = true
	transition_lock = false
	ui.show_game(player)
	_load_room()
	sound.set_music(false)

func _discard_room() -> void:
	if is_instance_valid(room):
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.remove_from_group("enemies")
		remove_child(room)
		room.queue_free()
		room = null
	boss = null

func _load_room() -> void:
	_discard_room()
	var info: Dictionary = director.rooms[room_index]
	room = CathedralRoom.new()
	room.data = director.layouts[info.layout]
	room.kind = info.kind
	add_child(room)
	player.position = Vector2(100,300)
	player.spawn_point = player.position
	player.velocity = Vector2.ZERO
	player.knockback = 0.0
	player.invulnerable = 0.45
	alive = 0
	reward_claimed = false
	camera.position = Vector2(320,180)
	ui.boss_hp.hide()
	var room_name: String = room.data.title
	if info.kind == "boss": room_name = "The Collector's Sanctum"
	elif info.kind == "reward": room_name = "Altar of Fragments"
	elif info.kind == "rest": room_name = "The Last Ember"
	ui.room_text.text = "%02d / 10   ·   %s" % [room_index+1,room_name]
	ui.announce(room_name)
	match info.kind:
		"combat":
			var count := mini(5,3+room_index/3)
			for i in count:
				var key: String = ["crawler","sentry","penitent"][(i+room_index)%3]
				if room_index==0 and i==2: key="crawler"
				_spawn_enemy(key,room.data.enemy_spawns[i],float(info.tier))
			ui.notify("DEFEAT THE REMNANTS TO BREAK THE SEAL")
		"boss":
			_spawn_enemy("collector",Vector2(850,300),1.0)
			sound.set_music(true)
			ui.notify("THE COLLECTOR  /  WATCH ITS WINDUP")
		"reward":
			ui.notify("E AT THE ALTAR  /  CHOOSE A FRAGMENT")
		"rest":
			ui.notify("E AT THE EMBER  /  RECOVER VITALITY")

func _spawn_enemy(key: String, at: Vector2, tier_value: float) -> void:
	var enemy: RemnantEnemy = CollectorBoss.new() if key=="collector" else RemnantEnemy.new()
	enemy.data = load("res://resources/enemies/%s.tres" % key)
	enemy.tier = 1.0+0.15*(tier_value-1.0)
	enemy.player = player
	enemy.position = at
	enemy.died.connect(_enemy_died)
	enemy.combat_event.connect(_combat_event)
	room.add_child(enemy)
	alive += 1
	if key=="collector":
		boss = enemy as CollectorBoss
		boss.phase_changed.connect(func(_phase: int): ui.notify("SECOND RITE  /  CHANGE FORMS TO SHATTER ITS WARD"))
		ui.boss_hp.show()

func _process(delta: float) -> void:
	if is_instance_valid(player):
		var width := 1280.0
		camera.position.x = clampf(roundf(player.position.x),320.0,width-320.0)
		camera.position.y = 180
		backdrop.camera_x = camera.position.x
		if running:
			elapsed += delta
			if Input.is_action_just_pressed("interact"):
				_interact()
		if is_instance_valid(boss) and not boss.health.dead:
			ui.boss_hp.max_value = boss.health.maximum
			ui.boss_hp.value = boss.health.current
	shake_time = maxf(0.0,shake_time-delta)
	if shake_time > 0.0:
		camera.offset = Vector2(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength)).round()*store.shake
	else:
		camera.offset = Vector2.ZERO

func _interact() -> void:
	if not is_instance_valid(room) or transition_lock or player.health.dead:
		return
	if room.kind in ["reward","rest"] and not reward_claimed and absf(player.position.x-620)<65.0 and player.position.y>270.0:
		if room.kind=="reward":
			get_tree().paused = true
			ui.show_upgrades(director.reward_choices())
		else:
			player.health.heal(45.0)
			player.energy = player.rules.max_energy
			reward_claimed = true
			room.exit_open = true
			rooms_cleared += 1
			_combat_event("phase",Vector2(620,255),Color("5d8fa9"))
			ui.notify("EMBER RESTORED  /  THE WAY IS OPEN")
		return
	if player.position.x > room.data.width-130 and player.position.y > 255.0:
		if not room.exit_open:
			ui.notify("THE SEAL HOLDS  /  CLEAR THIS ROOM FIRST")
			return
		if room_index < director.rooms.size()-1:
			room_index += 1
			_load_room()
	elif room.exit_open:
		ui.notify("E AT THE BLUE GATE TO ADVANCE")

func _choose_upgrade(upgrade: UpgradeData) -> void:
	if not running or reward_claimed:
		return
	player.apply_upgrade(upgrade)
	reward_claimed = true
	room.exit_open = true
	rooms_cleared += 1
	get_tree().paused = false
	ui.show_game(player)
	ui.notify("%s  /  THE WAY IS OPEN" % upgrade.title.to_upper())

func _enemy_died(enemy: RemnantEnemy) -> void:
	if not running:
		return
	player.kills += 1
	player.energy = minf(player.rules.max_energy,player.energy+8.0)
	alive = maxi(0,alive-1)
	if enemy is CollectorBoss:
		finish_run(true)
	elif alive == 0:
		room.exit_open = true
		rooms_cleared += 1
		ui.notify("SEAL BROKEN  /  E AT THE BLUE GATE")
		_combat_event("parry",Vector2(room.data.width-62,255),Color("5d8fa9"))

func _on_struck_enemy(_enemy: Node, combo: bool) -> void:
	shake_time = 0.11
	shake_strength = 3.0 if combo else 1.5
	# Small hit-stop affects only simulation and resumes using a real-time timer.
	Engine.time_scale = 0.3
	get_tree().create_timer(0.045,true,false,true).timeout.connect(func(): Engine.time_scale=1.0)

func _combat_event(kind: String, at: Vector2, tint: Color) -> void:
	sound.play_sound(kind)
	if kind in ["shift","phase","parry","combo"]:
		effects.burst(at,tint,20,110)
	elif kind in ["hit","hurt","death","dash"]:
		effects.burst(at,tint,10,80)
	elif kind in ["attack","heavy","boss"]:
		var direction: int = player.facing if is_instance_valid(player) else 1
		effects.slash(at,direction,tint,kind!="attack")
	if kind in ["hurt","heavy","boss","parry"]:
		shake_time = 0.16
		shake_strength = 3.0

func _on_player_died() -> void:
	finish_run(false)

func finish_run(won: bool) -> void:
	if not running:
		return
	running = false
	transition_lock = true
	if won:
		rooms_cleared = 10
	store.best_rooms = maxi(store.best_rooms,rooms_cleared)
	if won: store.wins += 1
	store.save()
	var serial := run_serial
	await get_tree().create_timer(1.1).timeout
	if serial != run_serial or not is_instance_valid(player):
		return
	get_tree().paused = true
	ui.show_result(won,{"time": elapsed,"rooms": rooms_cleared,"kills": player.kills,"combos": player.combos,"shifts": player.shifts,"seed": director.seed_value})

func pause_game() -> void:
	if running:
		get_tree().paused = true
		ui.show_pause()

func resume_game() -> void:
	get_tree().paused = false
	ui.show_game(player)

func show_menu() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	run_serial += 1
	running = false
	_discard_room()
	if is_instance_valid(player):
		remove_child(player)
		player.queue_free()
		player = null
	camera.position = Vector2(320,180)
	ui.show_menu()
	sound.set_music(false)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_game()

func quit_game() -> void:
	sound.shutdown()
	await get_tree().create_timer(0.2,true,false,true).timeout
	get_tree().quit()
