extends CharacterBody2D

@onready var flame: Sprite2D = $Ship/Flame
@onready var ship: Sprite2D = $Ship

@export var SPEED = 150.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation = deg_to_rad(event.relative.y + event.relative.y)

func _physics_process(delta: float) -> void:
	# Get Mouse Position
	var mouse_position = get_global_mouse_position()
	
	# Look at Mouse
	look_at(lerp(Vector2(rotation, 0), mouse_position, 1.0))
	
	# Movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("RMB"):
		direction = (mouse_position - position).normalized()
		velocity = direction * SPEED
		flame.visible = true
	else:
		velocity.x = lerp(velocity.x, Vector2.ZERO.x * SPEED, delta)
		velocity.y = lerp(velocity.y, Vector2.ZERO.y * SPEED, delta)
		flame.visible = false
	move_and_slide()
