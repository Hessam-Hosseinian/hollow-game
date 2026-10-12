class_name Vitality
extends Node
signal changed(current: float, maximum: float)
signal depleted
var maximum: float = 100.0
var current: float = 100.0
var dead: bool = false

func configure(value: float) -> void:
	maximum = value
	current = value
	dead = false
	changed.emit(current, maximum)

func damage(amount: float) -> bool:
	if dead or amount <= 0.0:
		return false
	current = maxf(0.0, current - amount)
	changed.emit(current, maximum)
	if current == 0.0:
		dead = true
		depleted.emit()
	return true

func heal(amount: float) -> void:
	if dead:
		return
	current = minf(maximum, current + maxf(amount, 0.0))
	changed.emit(current, maximum)

func increase_maximum(amount: float) -> void:
	maximum += maxf(amount, 0.0)
	heal(amount)
