extends Node2D

@onready var player = $Player
@onready var tilemap = $TileMap
@export var ball_scene : PackedScene 

var balls : Array[Ball]

var init_position = Vector2(360, 1200)

signal ball_colled

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Vector2(0.1, 1).normalized().reflect(Vector2(-1, 0)))
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%Label.text = str("balls: ", balls.size())
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var coords = tilemap.local_to_map(get_global_mouse_position())
			print("at: ", coords)
			tilemap.erase_cell(0, coords)
			for ball in balls:
				ball.set_direction(get_global_mouse_position() - ball.position)
				ball.run()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			for ball in balls:
				ball.position = get_global_mouse_position()
	

func reset():
	player.show()
	player.position = init_position
	var ball = add_ball(player.position + Vector2(0, -30), Vector2.UP)
	balls.append(ball as Ball)
	
func add_ball(pos: Vector2, dir: Vector2):
	var ball: Ball = ball_scene.instantiate()
	ball.position = pos
	ball.direction = dir
	ball.set_ball_coll(ball_colled)
	add_child(ball)
	return ball

func _on_m_3_pressed():
	var new_balls : Array[Ball]
	for ball in balls:
		var pos = ball.position
		for i in range(3):
			print(1)
			var new_ball = add_ball(ball.position, Vector2(randf_range(-1, 1), randf_range(-1,1)).normalized())
			new_balls.append(new_ball)
	for ball in new_balls:
		ball.run()
		balls.append(ball as Ball)

func _on_ball_colled():
	(%AudioStreamPlayer as AudioStreamPlayer).play()
