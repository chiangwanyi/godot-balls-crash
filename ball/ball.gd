class_name Ball
extends Area2D

@export var DEFAULT_SPEED = 200
@export var direction = Vector2.UP

var stop : bool = true
var _speed = DEFAULT_SPEED

signal hit_brick(brick_pos: Vector2)
signal ball_out_of_screen(ball: Ball)

func _ready():
	pass # Replace with function body.

func _process(delta):
	if stop:
		return
	_speed += delta * 2
	position += _speed * delta * direction
	
func set_direction(dir: Vector2):
	direction = dir.normalized()

func run():
	stop = false

func _on_body_entered(body):
	if body is StaticBody2D:
		var body_name = (body as StaticBody2D).name
		if body_name == "Ceiling" or body_name == "Floor":
			direction = direction.reflect(Vector2(1, 0))
		elif body_name == "LeftWall" or body_name == "RightWall":
			direction = direction.reflect(Vector2(0, 1))
	if body is CharacterBody2D:
		var new_direction: Vector2 = (position - body.position).normalized()
		if new_direction.x < 0:
			direction = new_direction.rotated(deg_to_rad(40))
		elif new_direction.x > 0:
			direction = new_direction.rotated(deg_to_rad(-40))
		else:
			direction = new_direction
		run()

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var tilemap = body as TileMap
		var coords := tilemap.get_coords_for_body_rid(body_rid)
		var brick_pos := tilemap.map_to_local(coords)
		#print("ball:",position,"\tbody:", tilemap.map_to_local(coords))
		# 球心到碰撞块中心的向量
		var coll_direction = (brick_pos - position).normalized()
		var angle = coll_direction.angle()
		
		var new_direction
		# left
		if angle >= -PI / 4 and angle < PI / 4:
			#print("ball 碰撞左边")
			if angle > 0:
				new_direction = direction.reflect(Vector2(0, 1))
			else:
				new_direction = direction.reflect(Vector2(0, -1))
			if new_direction.x < 0:
				direction = new_direction
		# top
		elif angle >= PI / 4 and angle < PI / 4 * 3:
			if angle > PI / 2:
				new_direction = direction.reflect(Vector2(-1, 0))
			else:
				new_direction = direction.reflect(Vector2(1, 0))
			if new_direction.y < 0:
				direction = new_direction
			#print("ball 碰撞上边")
		# bottom
		elif angle < -PI / 4 and angle > -PI / 4 * 3:
			if angle < -PI /2:
				new_direction = direction.reflect(Vector2(-1, 0))
			else:
				new_direction = direction.reflect(Vector2(1, 0))
			# 如果小球同时碰到两个砖块，直接反射会反转方向向上
			if new_direction.y > 0:
				direction = new_direction
			#print("ball 碰撞下边")
		# right
		else:
			if angle > 0:
				new_direction = direction.reflect(Vector2(0, 1))
			else:
				new_direction = direction.reflect(Vector2(0, -1))
			if new_direction.x > 0:
				direction = new_direction
			#print("ball 碰撞右边")
		tilemap.erase_cell(0, coords)
		hit_brick.emit(brick_pos)


func _on_visible_on_screen_enabler_2d_screen_exited():
	ball_out_of_screen.emit(self)
