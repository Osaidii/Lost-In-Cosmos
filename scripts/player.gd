extends CharacterBody2D

@onready var flame: Sprite2D = $Ship/Flame
@onready var ship: Sprite2D = $Ship
@onready var root := get_tree().get_root().get_node("World")
@onready var laser := load("uid://dx1pno2t1v35i")
@onready var shoot_cooldown: Timer = $"Shoot Cooldown"

@export var SPEED = 150.0
@export var COOLDOWN := 0.1
@export_category("External")
@export var direction: Vector2

func _ready() -> void:
	shoot_cooldown.wait_time = COOLDOWN

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation = deg_to_rad(event.relative.y + event.relative.y)

func _physics_process(delta: float) -> void:
	# Get Mouse Position
	var mouse_position = get_global_mouse_position()
	
	# Look at Mouse
	look_at(lerp(Vector2(rotation, 0), mouse_position, 1.0))
	
	# Shoot
	if Input.is_action_pressed("LMB"):
		shoot()
	
	# Movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("RMB"):
		direction = (mouse_position - position).normalized()
		var target_velocity = direction * SPEED
		velocity = lerp(velocity, target_velocity, delta * 2.0)
		flame.visible = true
	else:
		velocity.x = lerp(velocity.x, Vector2.ZERO.x * SPEED, delta)
		velocity.y = lerp(velocity.y, Vector2.ZERO.y * SPEED, delta)
		flame.visible = false
	move_and_slide()

func shoot() -> void:
	var instance  = laser.instantiate()
	instance.direction = rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = rotation
	root.add_child.call_deferred(instance)
