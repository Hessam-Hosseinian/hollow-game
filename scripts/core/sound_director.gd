class_name SoundDirector
extends Node
var store: SaveStore
var music_player: AudioStreamPlayer
var boss_music: bool = false
var sounds: Dictionary = {}
var shutting_down: bool = false
var voices: Array[AudioStreamPlayer] = []

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.finished.connect(func():
		if not shutting_down: music_player.play())
	for i in 12:
		var voice := AudioStreamPlayer.new()
		add_child(voice)
		voices.append(voice)
	for key in ["attack","heavy","parry","dash","shift","phase","hurt","hit","death","jump","land","step","ui","boss","combo"]:
		sounds[key] = load("res://assets/audio/%s.wav" % key)
	set_music(false)

func apply_volumes() -> void:
	music_player.volume_db = linear_to_db(store.music * 0.65)
	for voice in voices:
		voice.volume_db = linear_to_db(store.sfx)

func set_music(boss: bool) -> void:
	boss_music = boss
	music_player.stream = load("res://assets/audio/%s.wav" % ("boss_drone" if boss else "ambient"))
	apply_volumes()
	music_player.play()

func play_sound(key: String) -> void:
	if not sounds.has(key):
		return
	for voice in voices:
		if not voice.playing:
			voice.stream = sounds[key]
			voice.pitch_scale = randf_range(0.94, 1.06)
			voice.play()
			return

func shutdown() -> void:
	shutting_down = true
	music_player.stop()
	music_player.stream = null
	for voice in voices:
		voice.stop()
		voice.stream = null

func _exit_tree() -> void:
	shutdown()
