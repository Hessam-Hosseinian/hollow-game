class_name CathedralBackdrop
extends Node2D
var texture: Texture2D = preload("res://assets/backgrounds/cathedral.png")
var camera_x: float = 320.0
var clock: float = 0.0

func _process(delta: float) -> void:
	clock += delta
	queue_redraw()

func _draw() -> void:
	draw_texture_rect(texture, Rect2(0,0,640,360), false, Color(0.62,0.66,0.73))
	draw_rect(Rect2(0,0,640,360),Color(0.04,0.04,0.06,0.2))
	for i in 6:
		var x := float(i*160)-fmod(camera_x*0.18,160.0)-45.0
		draw_rect(Rect2(x,0,13,360),Color(0.06,0.06,0.08,0.5))
		draw_line(Vector2(x+1,0),Vector2(x+1,360),Color(0.19,0.18,0.22,0.6),1)
	for i in 24:
		var x := fposmod(i*91.7-camera_x*0.3+sin(clock*0.15+i)*12.0,640.0)
		var y := fposmod(i*37.4+clock*(3.0+i%4),360.0)
		draw_rect(Rect2(roundf(x),roundf(y),1,1),Color(0.65,0.62,0.53,0.25))
