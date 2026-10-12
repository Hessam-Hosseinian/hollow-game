extends SceneTree
var game: AshenGame
const OUT := "res://docs/screenshots/"

func _initialize() -> void:
	call_deferred("run")

func snapshot(title: String) -> void:
	await create_timer(0.18,true,false,true).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT+title+".png")
	print("RENDERED ",title)

func run() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	game = load("res://scenes/main/main.tscn").instantiate()
	game.store = SaveStore.new("user://render_qa.cfg")
	root.add_child(game)
	await snapshot("01_menu")
	game.start_run(42)
	for enemy in get_nodes_in_group("enemies"):
		enemy.set_physics_process(false)
	game.player.position = Vector2(440,300)
	for i in 4:
		game.player.shift_lock=0.0
		game.player.energy=100
		game.player.transform(i)
		await snapshot("02_form_%d" % i)
	game.pause_game()
	await snapshot("03_pause")
	game.ui.show_settings(true)
	await snapshot("04_settings")
	game.ui.show_upgrades(game.director.reward_choices())
	await snapshot("05_upgrades")
	game.resume_game()
	game.room_index=9
	game._load_room()
	game.boss.set_physics_process(false)
	game.player.position=Vector2(720,300)
	game.player.phase_time=0
	game.player.form=0
	game.player.visual.configure(game.player.forms[0].sprite_path)
	game.boss.state="telegraph"
	game.boss.pattern=1
	game.boss.state_time=.65
	await snapshot("06_boss")
	game.ui.show_result(false,{"time":345,"rooms":5,"kills":16,"combos":8,"shifts":23,"seed":42})
	await snapshot("07_defeat")
	game.ui.show_result(true,{"time":645,"rooms":10,"kills":30,"combos":17,"shifts":48,"seed":42})
	await snapshot("08_victory")
	game.sound.shutdown()
	await create_timer(0.2,true,false,true).timeout
	game.queue_free()
	await process_frame
	quit()
