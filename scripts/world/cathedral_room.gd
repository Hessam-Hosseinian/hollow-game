class_name CathedralRoom
extends Node2D
var data: RoomData
var kind: String = "combat"
var exit_open: bool = false
var clock: float = 0.0
var tiles := TileMapLayer.new()
var stone: Texture2D = preload("res://assets/environments/stone.png")

func _ready() -> void:
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(32,32)
	tile_set.add_physics_layer()
	tile_set.set_physics_layer_collision_layer(0,1)
	tile_set.set_physics_layer_collision_mask(0,6)
	var source := TileSetAtlasSource.new()
	source.texture = stone
	source.texture_region_size = Vector2i(32,32)
	tile_set.add_source(source,0)
	for x in 3:
		source.create_tile(Vector2i(x,0))
		var tile := source.get_tile_data(Vector2i(x,0),0)
		tile.set_collision_polygons_count(0,1)
		tile.set_collision_polygon_points(0,0,PackedVector2Array([Vector2(-16,-16),Vector2(16,-16),Vector2(16,16),Vector2(-16,16)]))
	tiles.tile_set = tile_set
	tiles.position.y = 12
	add_child(tiles)
	for x in range(-1,data.width/32+1):
		for y in range(9,12):
			tiles.set_cell(Vector2i(x,y),0,Vector2i(1 if y==9 else 0,0))
	for rect in data.platforms:
		if kind != "boss":
			add_collider(rect,true)
	add_collider(Rect2(-32,-120,32,600))
	add_collider(Rect2(data.width,-120,32,600))
	add_collider(Rect2(0,-160,data.width,32))

func add_collider(rect: Rect2, one_way: bool = false) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 6
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.get_center()
	shape.one_way_collision = one_way
	body.add_child(shape)
	add_child(body)

func _process(delta: float) -> void:
	clock += delta
	queue_redraw()

func _draw() -> void:
	if data == null:
		return
	if kind != "boss":
		for rect in data.platforms:
			for x in range(int(rect.position.x),int(rect.end.x),32):
				draw_texture_rect_region(stone,Rect2(x,rect.position.y,32,16),Rect2(32,0,32,16))
			for x in range(int(rect.position.x+8),int(rect.end.x),48):
				draw_line(Vector2(x,rect.end.y),Vector2(x,rect.end.y+24),Color("24242c"),3)
	for x in range(192,data.width-80,192):
		draw_rect(Rect2(x-14,275,28,25),Color("24242c"))
		draw_line(Vector2(x-18,275),Vector2(x+18,275),Color("555260"),3)
		for offset in [-7,0,7]:
			draw_rect(Rect2(x+offset,264,2,11),Color("d4c5a0"))
			var f := 3.0+sin(clock*7.0+x+offset)*1.2
			draw_rect(Rect2(x+offset,264-f,2,f),Color("973e4a"))
			draw_rect(Rect2(x+offset,263-f,1,2),Color("e7ddbf"))
	for i in 7:
		var x := 175+i*143
		draw_line(Vector2(x,0),Vector2(x,45+i%3*24),Color("555260"),1)
		for y in range(4,45+i%3*24,6):
			draw_rect(Rect2(x-1,y,3,4),Color("555260"),false,1)
	var door_x := data.width-62
	var color := Color("5d8fa9") if exit_open else Color("555260")
	draw_rect(Rect2(door_x-23,215,46,85),Color("101014"))
	draw_polyline(PackedVector2Array([Vector2(door_x-26,300),Vector2(door_x-26,239),Vector2(door_x,206),Vector2(door_x+26,239),Vector2(door_x+26,300)]),color,3)
	if not exit_open:
		for x in range(door_x-18,door_x+20,9):
			draw_line(Vector2(x,231),Vector2(x,300),color,2)
	else:
		draw_rect(Rect2(door_x-12,239,24,61),Color(0.36,0.56,0.66,0.12+sin(clock*3)*0.04))
	if kind in ["reward","rest"]:
		var center := Vector2(620,270)
		draw_rect(Rect2(center.x-24,center.y,48,30),Color("24242c"))
		draw_rect(Rect2(center.x-28,center.y,56,4),Color("b18a55"))
		draw_circle(center-Vector2(0,16),7,Color("973e4a") if kind=="rest" else Color("5d8fa9"))
		draw_arc(center-Vector2(0,16),12,0,TAU,12,Color("d4c5a0"),1)
