class_name Ball
extends RigidBody2D

@export var DEFAULT_SPEED = 200
#@export var direction = Vector2.UP

var stop : bool = true
var _speed = DEFAULT_SPEED

signal hit_brick(brick_pos: Vector2)
signal ball_out_of_screen(ball: Ball)

func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	var lv = state.linear_velocity
	if lv.length() != DEFAULT_SPEED:
		state.linear_velocity = lv.normalized() * DEFAULT_SPEED
	
#func set_direction(dir: Vector2):
	#direction = dir.normalized()

func run():
	stop = false

#func _on_body_entered(body):
	#return
	#if body is StaticBody2D:
		#var body_name = (body as StaticBody2D).name
		#if body_name == "Ceiling" or body_name == "Floor":
			#direction = direction.reflect(Vector2(1, 0))
		#elif body_name == "LeftWall" or body_name == "RightWall":
			#direction = direction.reflect(Vector2(0, 1))
	#if body is CharacterBody2D:
		#var new_direction: Vector2 = (position - body.position).normalized()
		#if new_direction.x < 0:
			#direction = new_direction.rotated(deg_to_rad(40))
		#elif new_direction.x > 0:
			#direction = new_direction.rotated(deg_to_rad(-40))
		#else:
			#direction = new_direction
		#run()

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var tilemap = body as TileMap
		var coords := tilemap.get_coords_for_body_rid(body_rid)
		# 碰撞到的砖块中心点位置
		var brick_pos := tilemap.map_to_local(coords)
		
		tilemap.erase_cell(0, coords)
		hit_brick.emit(brick_pos)
		#stop = false


func _on_visible_on_screen_enabler_2d_screen_exited():
	ball_out_of_screen.emit(self)
