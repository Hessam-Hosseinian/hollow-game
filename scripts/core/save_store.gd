class_name SaveStore
extends RefCounted
const PATH := "user://ashen_vessel.cfg"
var music: float = 0.45
var sfx: float = 0.7
var shake: float = 0.65
var fullscreen: bool = false
var best_rooms: int = 0
var wins: int = 0
var cfg := ConfigFile.new()
var storage_path: String = PATH

func _init(path: String = PATH) -> void:
	storage_path = path
	if cfg.load(storage_path) == OK:
		music = clampf(cfg.get_value("audio", "music", music), 0.0, 1.0)
		sfx = clampf(cfg.get_value("audio", "sfx", sfx), 0.0, 1.0)
		shake = clampf(cfg.get_value("display", "shake", shake), 0.0, 1.0)
		fullscreen = cfg.get_value("display", "fullscreen", false)
		best_rooms = cfg.get_value("stats", "best_rooms", 0)
		wins = cfg.get_value("stats", "wins", 0)

func save() -> void:
	cfg.set_value("audio", "music", music)
	cfg.set_value("audio", "sfx", sfx)
	cfg.set_value("display", "shake", shake)
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.set_value("stats", "best_rooms", best_rooms)
	cfg.set_value("stats", "wins", wins)
	cfg.save(storage_path)
