class_name HollowMark
extends Node
var source_form: int = -1
var remaining: float = 0.0

func _process(delta: float) -> void:
	remaining = maxf(0.0, remaining - delta)
	if remaining == 0.0:
		source_form = -1

func apply(form: int, duration: float) -> void:
	source_form = form
	remaining = duration

func activate(form: int) -> bool:
	if remaining > 0.0 and form != source_form:
		remaining = 0.0
		source_form = -1
		return true
	return false
