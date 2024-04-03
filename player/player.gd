extends CharacterBody2D

@export var MOTION_SPEED = 30
@export var FRICTION_FACTOR = 0.89

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_axis(&"move_left", &"move_right")
	motion.y = Input.get_axis(&"move_up", &"move_down")
	# Make diagonal movement fit for hexagonal tiles.
	velocity += motion.normalized() * MOTION_SPEED
	# Apply friction.
	velocity *= FRICTION_FACTOR
	move_and_slide()
