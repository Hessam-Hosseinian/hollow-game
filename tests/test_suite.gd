extends SceneTree
var checks: int = 0
var failures: Array[String] = []
var game: AshenGame

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, title: String) -> void:
	checks += 1
	if not condition:
		failures.append(title)
		push_error("FAIL: "+title)

func frames(count: int) -> void:
	for i in count:
		await physics_frame

func freeze_enemies() -> void:
	for enemy in get_nodes_in_group("enemies"):
		enemy.set_physics_process(false)

func reset_player() -> void:
	var p := game.player
	p.energy=100
	p.shift_lock=0
	p.attack_timer=0
	p.special_timer=0
	p.parry_time=0
	p.dash_time=0
	p.phase_time=0
	p.dodge_time=0
	p.invulnerable=0
	p.special_cooldowns=PackedFloat32Array([0,0,0,0])
	p.health.configure(140)
	p.set_physics_process(false)

func run() -> void:
	print("ASHEN VESSEL automated integration suite")
	InputSetup.install()
	var vital := Vitality.new()
	root.add_child(vital)
	vital.configure(50)
	var events: Array[int] = [0]
	vital.depleted.connect(func(): events[0]+=1)
	vital.damage(20)
	check(vital.current==30,"health damage")
	vital.heal(100)
	check(vital.current==50,"healing clamped")
	vital.damage(90)
	vital.damage(90)
	vital.heal(10)
	check(vital.current==0 and events[0]==1,"death emits once and cannot heal")
	vital.queue_free()
	var mark := HollowMark.new()
	root.add_child(mark)
	mark.apply(0,4)
	check(not mark.activate(0),"same-form attack preserves mark")
	check(mark.activate(2),"cross-form mark activation")
	check(not mark.activate(1),"mark consumed once")
	mark.apply(1,.2)
	mark._process(.3)
	check(not mark.activate(0),"mark expires")
	mark.queue_free()
	var director := RunDirector.new()
	var second := RunDirector.new()
	var all_layouts: Dictionary = {}
	for seed_value in 256:
		director.begin(seed_value)
		second.begin(seed_value)
		check(director.rooms==second.rooms,"reproducible seed %d" % seed_value)
		check(director.rooms.size()==10 and director.rooms[9].kind=="boss","run structure %d" % seed_value)
		var first_six: Dictionary = {}
		for i in director.rooms.size():
			all_layouts[director.rooms[i].layout]=true
			if i<6: first_six[director.rooms[i].layout]=true
		check(first_six.size()==6,"layout bag avoids first-cycle repeats %d" % seed_value)
		var choices := director.reward_choices()
		check(choices.size()==3 and choices[0]!=choices[1] and choices[1]!=choices[2] and choices[0]!=choices[2],"unique upgrade choices %d" % seed_value)
	check(all_layouts.size()==6,"all six layouts selected")
	for layout in director.layouts:
		check(layout.width==1280,"camera-compatible room width")
		for spawn in layout.enemy_spawns:
			check(spawn.x>100 and spawn.x<layout.width-32 and spawn.y==300,"spawn on clear floor")
		for platform in layout.platforms:
			check(platform.position.y>=300.0-pow(430.0,2)/1800.0 and platform.position.y<=236,"reachable optional ledge height")
			check(platform.position.x>120 and platform.end.x<layout.width-100,"platform leaves safe entry and exit")
	game=load("res://scenes/main/main.tscn").instantiate()
	game.store=SaveStore.new("user://test_suite_qa.cfg")
	root.add_child(game)
	check(game.ui.current_screen=="menu","title/menu loads")
	game.start_run(42)
	game.player.struck_enemy.disconnect(game._on_struck_enemy)
	freeze_enemies()
	reset_player()
	var p := game.player
	var expected := [0,10,20,30,20,0,10,20,30,20,0,10,40,30,20,0]
	for from in 4:
		for to in 4:
			p.form=from
			p.energy=100
			p.shift_lock=0
			var hp_before := p.health.current
			var changed := p.transform(to)
			check(changed==(from!=to),"shift validity %d to %d" % [from,to])
			check(is_equal_approx(p.energy,100.0-expected[from*4+to]),"shift cost %d to %d" % [from,to])
			check(p.health.current==hp_before,"shared health %d to %d" % [from,to])
	p.form=0;p.energy=9;p.shift_lock=0
	check(not p.transform(1) and p.form==0 and p.energy==9,"insufficient energy rejected")
	p.energy=100
	check(p.transform(1) and not p.transform(2),"transition lock prevents repeated shifts")
	p.shift_lock=0;p.form=1;p.energy=10
	check(p.transform(2) and p.energy==0,"exact-cost shift reaches zero")
	p.spend_energy(-10)
	check(p.energy<=100,"energy bounded")
	p.energy=99;p._physics_process(1)
	check(p.energy==100,"passive regeneration clamps at max")
	reset_player()
	p.form=0
	p.invulnerable=0
	var enemy: RemnantEnemy = get_nodes_in_group("enemies")[0]
	enemy.health.configure(1000)
	p.special()
	p.energy=50
	var hp_before := p.health.current
	p.receive_hit(20,enemy)
	check(p.health.current==hp_before and p.energy==68 and enemy.state=="stagger" and enemy.mark.source_form==0,"parry negates hit, staggers and marks")
	p.parry_time=0;p.special_timer=0;p.invulnerable=0
	check(p.receive_hit(10,enemy),"damage accepted")
	var hp_after := p.health.current
	check(not p.receive_hit(10,enemy) and p.health.current==hp_after,"damage immunity frames")
	reset_player();p.form=1
	p.health.damage(30)
	p.position=enemy.position-Vector2(42,0);p.facing=1
	var pre_heal := p.health.current
	p.special()
	check(p.health.current>pre_heal,"Devour heals on a valid hit")
	p.special_timer=0;p.special_cooldowns[1]=0;p.position=Vector2(50,300)
	pre_heal=p.health.current;p.special()
	check(p.health.current==pre_heal,"Devour cannot heal without a hit")
	reset_player();p.form=2;p.position=enemy.position
	p.special();p._dash_contacts()
	check(enemy.mark.source_form==2,"Bone Dash applies mark")
	reset_player();p.form=3;p.position=enemy.position-Vector2(40,0)
	var pre_combo := p.combos
	p.attack()
	check(p.combos==pre_combo+1,"different-form attack detonates mark")
	reset_player();p.form=3;p.special()
	check(p.phase_time>0 and p.collision_mask==1 and not p.receive_hit(100,enemy),"Soul Phase evades damage while retaining world collision")
	check(not p.transform(0),"cannot chain phase through transformations")
	reset_player();p.form=0;p.dodge_cooldown=0;p.dodge()
	check(not p.receive_hit(100,enemy),"dodge avoids eligible damage")
	for upgrade in director.upgrades:
		p.apply_upgrade(upgrade)
	check(p.health.maximum==165 and p.damage_bonus>0 and p.regen_bonus>0 and p.shift_discount>0 and p.parry_bonus>0 and p.dash_bonus>0 and p.heal_bonus>0 and p.phase_bonus>0,"all eight upgrades apply")
	game.pause_game()
	check(paused and game.ui.current_screen=="pause","pause opens and stops simulation")
	game.resume_game()
	check(not paused and game.ui.current_screen=="game","resume restores game")
	var saved := SaveStore.new("user://settings_qa.cfg")
	saved.music=.25;saved.sfx=.35;saved.shake=.45;saved.fullscreen=false;saved.best_rooms=7;saved.wins=3
	saved.save()
	var restored := SaveStore.new("user://settings_qa.cfg")
	check(restored.music==.25 and restored.sfx==.35 and restored.shake==.45 and restored.best_rooms==7 and restored.wins==3,"settings and statistics round trip")
	# Actual physics traversal: no teleporting, jump or phase needed to reach any exit.
	game.start_run(43)
	game.player.struck_enemy.disconnect(game._on_struck_enemy)
	p=game.player
	p.form=2
	p.visual.configure(p.forms[2].sprite_path)
	Engine.time_scale=1
	Engine.max_physics_steps_per_frame=32
	for layout_index in 6:
		game.director.rooms[0].layout=layout_index
		game.room_index=0
		game._load_room()
		freeze_enemies()
		await frames(3)
		check(p.is_on_floor(),"floor collision layout %d" % layout_index)
		Input.action_press("move_right")
		var timeout: int = 0
		while p.position.x<1180 and timeout<600:
			await physics_frame
			timeout+=1
		Input.action_release("move_right")
		check(p.position.x>=1180 and p.position.y<=301,"physics traversal to exit layout %d" % layout_index)
		p.position.x=1260
		Input.action_press("move_right")
		await frames(3)
		Input.action_release("move_right")
		check(p.position.x<=1270,"mandatory boundary collision layout %d" % layout_index)
		for platform in game.room.data.platforms:
			p.position=Vector2(platform.get_center().x,300)
			p.velocity=Vector2.ZERO
			await frames(3)
			Input.action_press("jump")
			await frames(2)
			var landing_steps := 0
			while not p.is_on_floor() and landing_steps<100:
				await physics_frame
				landing_steps+=1
			Input.action_release("jump")
			check(absf(p.position.y-platform.position.y)<2,"physics jump reaches optional platform %d at %s" % [layout_index,str(platform.position)])
	Engine.time_scale=1
	# Actual buffered keyboard jump and variable jump height.
	p.position=Vector2(100,300);p.velocity=Vector2.ZERO
	await frames(4)
	Input.action_press("jump")
	await frames(3)
	check(p.position.y<299 and p.velocity.y<0,"keyboard jump")
	Input.action_release("jump")
	await frames(3)
	check(p.velocity.y>-180,"variable jump release")
	# Complete all ten rooms through actual attack/interaction/upgrade code paths.
	game.start_run(77)
	p=game.player
	p.struck_enemy.disconnect(game._on_struck_enemy)
	p.set_physics_process(false)
	for index in 10:
		check(game.room_index==index,"room progression %d" % index)
		freeze_enemies()
		if game.room.kind in ["combat","boss"]:
			for target in get_nodes_in_group("enemies").duplicate():
				var attempts := 0
				p.form=0;p.facing=1
				while not target.health.dead and attempts<100:
					p.position=target.position-Vector2(40,0)
					p.attack_timer=0;p.shift_lock=0;p.attack()
					attempts+=1
				check(target.health.dead,"combat death via player attacks %s" % target.data.archetype)
			if index<9:check(game.room.exit_open and game.alive==0,"combat seal opens once %d" % index)
		elif game.room.kind=="reward":
			p.position=Vector2(620,300);game._interact()
			check(paused and game.ui.current_screen=="reward","altar opens upgrade selection")
			var chosen: UpgradeData = game.director.upgrades[0]
			game._choose_upgrade(chosen)
			var old_max := p.health.maximum
			game._choose_upgrade(chosen)
			check(not paused and game.room.exit_open and p.health.maximum==old_max,"upgrade granted once and unpauses")
		elif game.room.kind=="rest":
			p.health.damage(50);p.position=Vector2(620,300)
			var old_hp := p.health.current
			game._interact()
			var new_hp := p.health.current
			game._interact()
			check(new_hp>old_hp and p.health.current==new_hp and game.room.exit_open,"rest altar heals once")
		if index<9:
			p.position=Vector2(1200,300);game._interact()
			await process_frame
	await create_timer(1.3,true,false,true).timeout
	check(game.ui.current_screen=="result" and game.rooms_cleared==10 and not game.running,"full run reaches victory")
	game.start_run(88)
	check(not paused and game.player.form==0 and game.player.health.maximum==140 and game.player.damage_bonus==0 and game.player.combos==0 and game.room_index==0,"restart resets run stats and upgrades")
	freeze_enemies();p=game.player
	# Boss patterns, phase change and transformation reward in isolation.
	game.room_index=9;game._load_room();freeze_enemies()
	var boss := game.boss
	p.set_physics_process(false);p.invulnerable=0;p.position=boss.position-Vector2(60,0)
	boss.attack_facing=-1;boss.pattern=0
	hp_before=p.health.current;boss.perform_attack()
	check(p.health.current<hp_before,"boss melee connects inside telegraphed range")
	p.invulnerable=0;p.position=boss.position-Vector2(230,0)
	hp_before=p.health.current;boss.perform_attack()
	check(p.health.current==hp_before,"boss melee has safe outside range")
	var count_before := get_nodes_in_group("projectiles").size()
	boss.pattern=1;boss.perform_attack()
	check(get_nodes_in_group("projectiles").size()==count_before+2,"boss emits two jumpable ground waves")
	boss.health.damage(boss.health.maximum*.6);boss.think(.01)
	check(boss.phase==2,"boss health phase transition")
	boss.pattern=2;count_before=get_nodes_in_group("projectiles").size();boss.perform_attack()
	check(get_nodes_in_group("projectiles").size()==count_before+3,"second-phase spectral fan")
	boss.ward_form=0;p.form=2
	hp_before=boss.health.current;boss.receive_hit(10,1)
	check(is_equal_approx(hp_before-boss.health.current,22),"boss rewards changing form")
	game.start_run(89);freeze_enemies();p=game.player;p.invulnerable=0
	p.receive_hit(999,null,false)
	await create_timer(1.3,true,false,true).timeout
	check(game.ui.current_screen=="result" and p.health.dead and not game.running,"defeat screen follows player death")
	game.show_menu()
	check(not paused and game.ui.current_screen=="menu" and not is_instance_valid(game.player),"return to menu cleans active run")
	game.sound.shutdown()
	await create_timer(0.2,true,false,true).timeout
	game.queue_free()
	await process_frame
	print("RESULT: %d checks, %d failures" % [checks,failures.size()])
	for failure in failures:print("FAILED: ",failure)
	quit(0 if failures.is_empty() else 1)
