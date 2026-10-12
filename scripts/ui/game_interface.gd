class_name GameInterface
extends CanvasLayer
signal start_requested(seed_value: int)
signal restart_requested
signal menu_requested
signal resume_requested
signal quit_requested
signal pause_requested
signal upgrade_selected(upgrade: UpgradeData)
var store: SaveStore
var sound: SoundDirector
var root := Control.new()
var hud := Control.new()
var overlay := Control.new()
var hp: ProgressBar
var energy: ProgressBar
var hp_text: Label
var energy_text: Label
var form_text: Label
var ability: Label
var room_text: Label
var message: Label
var banner: Label
var boss_hp: ProgressBar
var form_buttons: Array[Panel] = []
var message_time: float = 0.0
var banner_time: float = 0.0
var current_screen: String = "menu"
var player: VesselPlayer
var seed_field: LineEdit

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	root.add_child(hud)
	root.add_child(overlay)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_hud()

func frame(color: Color = Color("24242c"), border: Color = Color("555260")) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(1)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style

func label(parent: Node, text_value: String, at: Vector2, size: Vector2, font_size: int = 14, tint: Color = Color("e7ddbf"), wrap: bool = false) -> Label:
	var result := Label.new()
	result.clip_text = true
	if wrap:
		result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.text = text_value
	result.position = at
	result.size = size
	result.add_theme_font_size_override("font_size",font_size)
	result.add_theme_color_override("font_color",tint)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(result)
	result.set_deferred("size",size)
	return result

func button(parent: Node, title: String, at: Vector2, size: Vector2, action: Callable) -> Button:
	var result := Button.new()
	result.text = title
	result.position = at
	result.size = size
	result.add_theme_font_size_override("font_size",14)
	result.add_theme_color_override("font_color",Color("e7ddbf"))
	result.add_theme_stylebox_override("normal",frame(Color(0.063,0.063,0.078,0.94),Color("555260")))
	result.add_theme_stylebox_override("hover",frame(Color("24242c"),Color("b18a55")))
	result.add_theme_stylebox_override("focus",frame(Color(0,0,0,0),Color("b18a55")))
	result.add_theme_stylebox_override("pressed",frame(Color("555260"),Color("d4c5a0")))
	result.pressed.connect(func(): sound.play_sound("ui"); action.call())
	parent.add_child(result)
	result.set_deferred("size",size)
	return result

func panel(parent: Node, at: Vector2, size: Vector2, border: Color = Color("555260")) -> Panel:
	var result := Panel.new()
	result.position = at
	result.size = size
	result.add_theme_stylebox_override("panel",frame(Color(0.063,0.063,0.078,0.94),border))
	parent.add_child(result)
	result.set_deferred("size",size)
	return result

func bar(parent: Node, at: Vector2, size: Vector2, tint: Color) -> ProgressBar:
	var result := ProgressBar.new()
	result.position = at
	result.size = size
	result.show_percentage = false
	result.add_theme_font_size_override("font_size",1)
	result.add_theme_constant_override("outline_size",0)
	result.add_theme_stylebox_override("background",frame(Color("101014")))
	result.add_theme_stylebox_override("fill",frame(tint,tint))
	parent.add_child(result)
	result.set_deferred("size",size)
	return result

func _build_hud() -> void:
	panel(hud,Vector2(9,8),Vector2(190,54))
	hp = bar(hud,Vector2(16,16),Vector2(176,12),Color("973e4a"))
	energy = bar(hud,Vector2(16,35),Vector2(176,9),Color("5d8fa9"))
	hp_text = label(hud,"",Vector2(18,13),Vector2(170,15),10)
	energy_text = label(hud,"",Vector2(18,44),Vector2(170,14),10,Color("5d8fa9"))
	room_text = label(hud,"",Vector2(255,10),Vector2(372,18),12)
	room_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	form_text = label(hud,"",Vector2(255,28),Vector2(372,18),11,Color("b18a55"))
	form_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	for i in 4:
		var p := panel(hud,Vector2(12+i*51,68),Vector2(46,37))
		var titles := ["WHOLE","FLESH","BONE","SOUL"]
		label(p,str(i+1),Vector2(5,2),Vector2(30,14),11,Color("b18a55"))
		label(p,titles[i],Vector2(4,19),Vector2(40,14),8)
		form_buttons.append(p)
	ability = label(hud,"",Vector2(345,46),Vector2(282,30),12)
	ability.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	message = label(hud,"",Vector2(130,263),Vector2(380,24),12,Color("e7ddbf"))
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner = label(hud,"",Vector2(130,79),Vector2(380,30),20)
	banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_hp = bar(hud,Vector2(200,63),Vector2(240,7),Color("973e4a"))
	boss_hp.hide()
	label(hud,"A D MOVE  /  SPACE JUMP  /  J ATTACK  /  K SPECIAL  /  SHIFT DODGE  /  E INTERACT",Vector2(12,342),Vector2(616,13),9,Color("a19b8a"))

func clear_overlay() -> void:
	for child in overlay.get_children():
		overlay.remove_child(child)
		child.queue_free()

func shade() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.02,0.02,0.03,0.84)
	dim.size = Vector2(640,360)
	overlay.add_child(dim)

func show_menu() -> void:
	current_screen = "menu"
	hud.hide()
	clear_overlay()
	shade()
	label(overlay,"A S H E N",Vector2(65,51),Vector2(460,64),48)
	label(overlay,"V E S S E L",Vector2(66,111),Vector2(460,55),39)
	label(overlay,"FOUR FORMS. ONE REMAINING SOUL.",Vector2(69,177),Vector2(510,22),12,Color("b18a55"))
	button(overlay,"ENTER THE CATHEDRAL",Vector2(70,216),Vector2(258,35),func(): start_requested.emit(_parse_seed())).grab_focus()
	button(overlay,"SETTINGS",Vector2(70,260),Vector2(124,30),func(): show_settings(false))
	button(overlay,"QUIT",Vector2(204,260),Vector2(124,30),func(): quit_requested.emit())
	label(overlay,"RUN SEED (optional)",Vector2(372,218),Vector2(196,20),11,Color("b18a55"))
	seed_field = LineEdit.new()
	seed_field.position = Vector2(372,242)
	seed_field.size = Vector2(185,28)
	seed_field.placeholder_text = "random"
	seed_field.max_length = 12
	seed_field.add_theme_font_size_override("font_size",13)
	overlay.add_child(seed_field)
	label(overlay,"BEST: %d / 10 ROOMS   |   VICTORIES: %d" % [store.best_rooms,store.wins],Vector2(70,313),Vector2(520,18),11,Color("a19b8a"))
	label(overlay,"PLAYABLE ALPHA  ·  ORIGINAL TEMPORARY SPRITES & AUDIO",Vector2(70,337),Vector2(520,14),9,Color("555260"))

func _parse_seed() -> int:
	return seed_field.text.to_int() if seed_field.text.is_valid_int() else int(Time.get_unix_time_from_system())

func show_game(vessel: VesselPlayer) -> void:
	player = vessel
	current_screen = "game"
	clear_overlay()
	hud.show()

func show_pause() -> void:
	current_screen = "pause"
	clear_overlay()
	shade()
	panel(overlay,Vector2(190,62),Vector2(260,245),Color("b18a55"))
	label(overlay,"THE ASH RESTS",Vector2(215,80),Vector2(220,36),22)
	button(overlay,"RESUME",Vector2(216,135),Vector2(208,33),func(): resume_requested.emit()).grab_focus()
	button(overlay,"SETTINGS",Vector2(216,178),Vector2(208,33),func(): show_settings(true))
	button(overlay,"ABANDON RUN",Vector2(216,221),Vector2(208,33),func(): menu_requested.emit())
	label(overlay,"ESC TO RESUME",Vector2(216,271),Vector2(208,18),10,Color("a19b8a"))

func show_settings(from_run: bool) -> void:
	current_screen = "settings_pause" if from_run else "settings_menu"
	clear_overlay()
	shade()
	panel(overlay,Vector2(110,33),Vector2(420,292),Color("b18a55"))
	label(overlay,"SETTINGS",Vector2(136,49),Vector2(340,33),24)
	_slider("MUSIC",103,store.music,func(value: float): store.music=value; sound.apply_volumes(); store.save())
	_slider("SOUND EFFECTS",149,store.sfx,func(value: float): store.sfx=value; sound.apply_volumes(); store.save())
	_slider("CAMERA SHAKE",195,store.shake,func(value: float): store.shake=value; store.save())
	var check := CheckButton.new()
	check.text = "FULLSCREEN"
	check.position = Vector2(134,234)
	check.button_pressed = store.fullscreen
	check.add_theme_font_size_override("font_size",12)
	check.toggled.connect(func(value: bool):
		store.fullscreen=value
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)
		store.save())
	overlay.add_child(check)
	button(overlay,"BACK",Vector2(360,278),Vector2(140,30),func():
		if from_run: show_pause()
		else: show_menu()).grab_focus()

func _slider(title: String, y: float, value: float, action: Callable) -> void:
	label(overlay,title,Vector2(137,y),Vector2(340,18),11,Color("d4c5a0"))
	var slider := HSlider.new()
	slider.position = Vector2(137,y+22)
	slider.size = Vector2(360,15)
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = value
	slider.value_changed.connect(action)
	overlay.add_child(slider)

func show_upgrades(choices: Array[UpgradeData]) -> void:
	current_screen = "reward"
	clear_overlay()
	shade()
	label(overlay,"A FRAGMENT TO CARRY",Vector2(66,53),Vector2(520,35),26)
	label(overlay,"Choose one blessing. It lasts only for this run.",Vector2(66,91),Vector2(520,20),12,Color("b18a55"))
	for i in choices.size():
		var upgrade: UpgradeData = choices[i]
		var card := panel(overlay,Vector2(58+i*178,126),Vector2(168,180),Color("b18a55"))
		var title := label(card,upgrade.title,Vector2(12,16),Vector2(143,41),16,Color("e7ddbf"),true)
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title.size = Vector2(143,41)
		var description := label(card,upgrade.description,Vector2(12,69),Vector2(142,60),12,Color("a19b8a"),true)
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.size = Vector2(142,60)
		var b := button(card,"CLAIM",Vector2(12,140),Vector2(144,28),func(): upgrade_selected.emit(upgrade))
		if i == 0: b.grab_focus()

func show_result(won: bool, stats: Dictionary) -> void:
	current_screen = "result"
	clear_overlay()
	shade()
	var color := Color("5d8fa9") if won else Color("973e4a")
	panel(overlay,Vector2(114,44),Vector2(412,273),color)
	label(overlay,"THE VESSEL ENDURES" if won else "RETURNED TO ASH",Vector2(137,67),Vector2(375,35),25,color)
	label(overlay,"The Collector releases what it could not keep." if won else "Your fragments scatter. Another vessel will rise.",Vector2(138,111),Vector2(367,22),12)
	var minutes: int = int(stats.time)/60
	var seconds: int = int(stats.time)%60
	label(overlay,"ROOMS   %d / 10       TIME   %02d:%02d\nREMNANTS   %d       HOLLOW COMBOS   %d\nSHIFTS   %d       SEED   %d" % [stats.rooms,minutes,seconds,stats.kills,stats.combos,stats.shifts,stats.seed],Vector2(138,156),Vector2(370,70),12,Color("a19b8a"))
	button(overlay,"RISE AGAIN",Vector2(137,255),Vector2(173,35),func(): restart_requested.emit()).grab_focus()
	button(overlay,"MAIN MENU",Vector2(324,255),Vector2(173,35),func(): menu_requested.emit())

func notify(text: String) -> void:
	message.text = text
	message_time = 2.3

func announce(text: String) -> void:
	banner.text = text
	banner_time = 2.6

func _process(delta: float) -> void:
	message_time = maxf(0.0,message_time-delta)
	banner_time = maxf(0.0,banner_time-delta)
	message.modulate.a = minf(1.0,message_time*2)
	banner.modulate.a = minf(1.0,banner_time)
	if not is_instance_valid(player) or not hud.visible:
		return
	hp.max_value = player.health.maximum
	hp.value = player.health.current
	energy.max_value = player.rules.max_energy
	energy.value = player.energy
	hp_text.text = "VITALITY  %d / %d" % [player.health.current,player.health.maximum]
	energy_text.text = "HOLLOW  %d / 100" % player.energy
	form_text.text = "%s  /  %s" % [player.forms[player.form].title.to_upper(),player.forms[player.form].role]
	var cooldown: float = player.special_cooldowns[player.form]
	ability.text = "K  %s  %s" % [player.forms[player.form].special_name,"READY" if cooldown<=0.0 else "%.1fs" % cooldown]
	ability.add_theme_color_override("font_color",player.forms[player.form].tint)
	for i in 4:
		var tint: Color = player.forms[i].tint if i==player.form else Color("555260")
		form_buttons[i].add_theme_stylebox_override("panel",frame(Color("24242c") if i==player.form else Color("101014"),tint))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match current_screen:
			"game": pause_requested.emit()
			"pause": resume_requested.emit()
			"settings_pause": show_pause()
			"settings_menu": show_menu()
		get_viewport().set_input_as_handled()
