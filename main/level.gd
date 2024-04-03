extends Node2D

@onready var player = $Player
@onready var tilemap = $TileMap
@export var ball_scene : PackedScene 

var balls : Array[Ball]

var init_position = Vector2(360, 1200)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Vector2(0.1, 1).normalized().reflect(Vector2(-1, 0)))
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
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
	add_ball(player.position + Vector2(0, -30))
	
func add_ball(pos: Vector2):
	var ball = ball_scene.instantiate()
	ball.position = pos
	add_child(ball)
	balls.append(ball as Ball)
