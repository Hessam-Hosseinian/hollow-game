class_name RunDirector
extends RefCounted
var seed_value: int
var rng := RandomNumberGenerator.new()
var rooms: Array[Dictionary] = []
var layouts: Array[RoomData] = []
var upgrades: Array[UpgradeData] = []

func _init() -> void:
	for i in 6:
		layouts.append(load("res://resources/rooms/room_%d.tres" % i))
	for i in 8:
		upgrades.append(load("res://resources/upgrades/upgrade_%d.tres" % i))

func begin(run_seed: int) -> void:
	seed_value = run_seed
	rng.seed = run_seed
	rooms.clear()
	var kinds := ["combat", "combat", "reward", "combat", "rest", "combat", "combat", "reward", "combat", "boss"]
	var bag: Array[int] = [0, 1, 2, 3, 4, 5]
	for i in kinds.size():
		if bag.is_empty():
			bag = [0, 1, 2, 3, 4, 5]
		var choice := rng.randi_range(0, bag.size() - 1)
		var layout := bag.pop_at(choice) as int
		rooms.append({"kind": kinds[i], "layout": layout, "tier": 1 + i / 3})

func reward_choices() -> Array[UpgradeData]:
	var pool := upgrades.duplicate()
	var result: Array[UpgradeData] = []
	for i in 3:
		var choice := rng.randi_range(0, pool.size() - 1)
		result.append(pool.pop_at(choice))
	return result
