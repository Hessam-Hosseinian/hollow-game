extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var game = load("res://scenes/main/main.tscn").instantiate()
	game.store=SaveStore.new("user://pack_smoke_qa.cfg")
	root.add_child(game)
	for layout in game.director.layouts:
		if layout.enemy_spawns.size()!=5:
			push_error("Packed room lost enemy spawn data")
			game.sound.shutdown()
			await create_timer(.2,true,false,true).timeout
			quit(1)
			return
	game.start_run(42)
	await create_timer(2.0,true,false,true).timeout
	if not game.running or game.player.forms.size()!=4 or game.room.data==null or game.alive!=3:
		push_error("Packed game did not start correctly")
		quit(1)
		return
	game.sound.shutdown()
	await create_timer(.2,true,false,true).timeout
	game.queue_free()
	await process_frame
	print("PACK SMOKE: PASS")
	quit()
