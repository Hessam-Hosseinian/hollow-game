"""Exercise live AI and input for all forms. High-health test fixture; not a balance test."""
extends SceneTree
var game: AshenGame
var counts: Dictionary = {}
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func observe(kind: String, _at: Vector2, _tint: Color, archetype: String) -> void:
	if kind in ["attack","heavy","boss"]:
		counts[archetype]=counts.get(archetype,0)+1

func check(ok: bool, title: String) -> void:
	if not ok:
		failures.append(title)
		push_error(title)

func run() -> void:
	game=load("res://scenes/main/main.tscn").instantiate()
	game.store=SaveStore.new("user://live_smoke_qa.cfg")
	root.add_child(game)
	game.start_run(93)
	game.room_index=5
	game._load_room()
	game.player.health.configure(2000)
	game.player.position=Vector2(690,300)
	for enemy in get_nodes_in_group("enemies"):
		enemy.health.configure(2000)
		enemy.position.x=game.player.position.x+60+get_nodes_in_group("enemies").find(enemy)*16
		enemy.combat_event.connect(observe.bind(enemy.data.archetype))
	Engine.time_scale=2
	for step in 480:
		if step%10==0 and game.player.form!=step/120:
			game.player.transform(step/120)
		if step%45==0:Input.action_press("special")
		elif step%45==1:Input.action_release("special")
		if step>=120 and step%21==0:Input.action_press("attack")
		elif step%21==1:Input.action_release("attack")
		if step>=120 and step%100==0:Input.action_press("jump")
		elif step%100==13:Input.action_release("jump")
		await physics_frame
	check(game.player.shifts>=3,"live input reaches all four forms")
	check(game.player.health.current<2000,"live enemies can damage the player")
	for key in ["crawler","sentry","penitent"]:
		check(counts.get(key,0)>0,"live AI attack: "+key)
	game.room_index=9
	game._load_room()
	game.player.phase_time=0
	game.player.health.configure(2000)
	game.player.position=Vector2(790,300)
	game.boss.health.damage(game.boss.health.maximum*.51)
	game.boss.combat_event.connect(observe.bind("collector"))
	for step in 420:
		if step%110==0:
			game.player.shift_lock=0
			game.player.energy=100
			game.player.transform((step/110)%4)
		if step%65==0:Input.action_press("special")
		elif step%65==1:Input.action_release("special")
		if step%90==0:Input.action_press("jump")
		elif step%90==13:Input.action_release("jump")
		await physics_frame
	check(game.boss.phase==2 and counts.get("collector",0)>=3,"live boss cycles second-phase attack patterns")
	check(game.player.health.current<2000,"live boss patterns can damage player")
	for action in ["jump","special","attack"]:Input.action_release(action)
	Engine.time_scale=1
	game.sound.shutdown()
	await create_timer(.2,true,false,true).timeout
	game.queue_free()
	await process_frame
	print("LIVE AI RESULT: ",counts,"; failures: ",failures.size())
	quit(0 if failures.is_empty() else 1)
