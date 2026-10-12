class_name CombatRules
extends Resource

@export var max_energy: float = 100.0
@export var energy_regen: float = 7.0
@export var transform_lock: float = 0.16
@export var transform_costs: PackedFloat32Array = [0,10,20,30, 20,0,10,20, 30,20,0,10, 40,30,20,0]
@export var mark_duration: float = 4.0
@export var mark_bonus: float = 14.0
@export var combo_energy: float = 12.0
@export var parry_energy: float = 18.0
@export var hit_energy: float = 3.0
@export var jump_speed: float = -430.0
@export var gravity: float = 900.0
@export var coyote_time: float = 0.11
@export var jump_buffer: float = 0.12

func shift_cost(from: int, to: int) -> float:
	return transform_costs[from * 4 + to]
