extends Node2D

@onready var player = $Player
@onready var tilemap = $TileMap


var ball_res := preload("res://ball/ball.tscn")
var triple_split_res := preload("res://power-ups/triple_split.tscn")

var balls : Array[Ball]

var init_position = Vector2(200, 760)

signal ball_colled

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%UI.set_ball_count(balls.size())
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var coords = tilemap.local_to_map(get_global_mouse_position())
			#tilemap.erase_cell(0, coords)
			for ball in balls:
				ball.force_stack.append((get_global_mouse_position() - ball.position).normalized())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			for ball in balls:
				ball.position = get_global_mouse_position()

func reset():
	player.show()
	player.position = init_position
	var ball = add_ball(player.position + Vector2(0, -30), Vector2.ZERO)
	balls.append(ball as Ball)

func add_ball(pos: Vector2, dir: Vector2):
	var ball := ball_res.instantiate() as Ball
	ball.position = pos
	ball.apply_central_force(dir.normalized())
	ball.hit_brick.connect(_on_ball_hit_brick)
	ball.ball_out_of_screen.connect(_on_ball_out_of_screen)
	
	call_deferred("add_child", ball)
	return ball
	
func add_triple_split(pos: Vector2) -> void :
	var item := triple_split_res.instantiate() as TripleSplitPower
	item.position = pos
	item.picked.connect(_on_triple_split_picked)
	
	call_deferred("add_child", item)
	
func _on_ball_hit_brick(brick_pos: Vector2):
	(%AudioStreamPlayer as AudioStreamPlayer).play()
	if randi() % 25 == 1 and balls.size() < 100:
		add_triple_split(brick_pos)
	
func _on_ball_out_of_screen(target_ball : Ball):
	balls.erase(target_ball)
	

func _on_triple_split_picked():
	var new_balls : Array[Ball] = []
	for ball in balls:
		for i in range(3):
			var new_ball = add_ball(ball.position, Vector2(randf_range(-1, 1), randf_range(-1,1)).normalized())
			new_balls.append(new_ball)
	for ball in new_balls:
		balls.append(ball as Ball)
