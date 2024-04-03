class_name Ball extends Area2D

@export var DEFAULT_SPEED = 200
@export var direction = Vector2.UP
@onready var _initial_pos = position

var stop : bool = true
var _speed = DEFAULT_SPEED

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
		var name = (body as StaticBody2D).name
		if name == "Ceiling" or name == "Floor":
			direction = direction.reflect(Vector2(1, 0))
		elif name == "LeftWall" or name == "RightWall":
			direction = direction.reflect(Vector2(0, 1))
	if body is CharacterBody2D:
		direction = Vector2(position.x - body.position.x, position.y - body.position.y).normalized()
		run()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var tilemap = body as TileMap
		var coords = tilemap.get_coords_for_body_rid(body_rid)
		print("ball:",position,"\tbody:", tilemap.map_to_local(coords))
		# 球心到碰撞块中心的向量
		var coll_direction = (tilemap.map_to_local(coords) - position).normalized()
		var angle = coll_direction.angle()
		
		var new_direction
		# left
		if angle >= -PI / 4 and angle < PI / 4:
			print("ball 碰撞左边")
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
			print("ball 碰撞上边")
		# bottom
		elif angle < -PI / 4 and angle > -PI / 4 * 3:
			if angle < -PI /2:
				new_direction = direction.reflect(Vector2(-1, 0))
			else:
				new_direction = direction.reflect(Vector2(1, 0))
			# 如果小球同时碰到两个砖块，直接反射会反转方向向上
			if new_direction.y > 0:
				direction = new_direction
			print("ball 碰撞下边")
		# right
		else:
			if angle > 0:
				new_direction = direction.reflect(Vector2(0, 1))
			else:
				new_direction = direction.reflect(Vector2(0, -1))
			if new_direction.x > 0:
				direction = new_direction				
			print("ball 碰撞右边")
		tilemap.erase_cell(0, coords)
		if _speed > 50:
			_speed /= 2
