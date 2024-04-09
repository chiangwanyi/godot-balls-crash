class_name Ball
extends RigidBody2D

@export var DEFAULT_SPEED = 200
#@export var direction = Vector2.UP

var stop := true
var _speed = DEFAULT_SPEED
var force_stack : Array[Vector2] = []

signal hit_brick(brick_pos: Vector2)
signal ball_out_of_screen(ball: Ball)

func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	if force_stack.is_empty():
		var lv = state.linear_velocity
		if lv.length() != DEFAULT_SPEED:
			state.linear_velocity = lv.normalized() * DEFAULT_SPEED
	else:
		state.linear_velocity = force_stack.pop_front().normalized() * DEFAULT_SPEED
		
func _physics_process(delta: float) -> void:
	if position.y > 800:
		ball_out_of_screen.emit(self)
		queue_free()

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var tilemap = body as TileMap
		var coords := tilemap.get_coords_for_body_rid(body_rid)
		# 碰撞到的砖块中心点位置
		var brick_pos := tilemap.map_to_local(coords)
		
		tilemap.erase_cell(0, coords)
		hit_brick.emit(brick_pos)
	elif body is CharacterBody2D:
		force_stack.append(position - body.position)

# 当游戏中的ball过多时，VisibleOnScreenEnable不一定生效
func _on_visible_on_screen_enabler_2d_screen_exited():
	pass
	#ball_out_of_screen.emit(self)
	#queue_free()
