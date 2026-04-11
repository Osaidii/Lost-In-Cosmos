class_name Player
extends CharacterBody2D

@onready var flame: Sprite2D = $Ship/Flame
@onready var ship: Sprite2D = $Ship
@onready var laser := load("uid://dx1pno2t1v35i")
@onready var explosion := load("uid://tntu14kag51h")
@onready var shoot_cooldown: Timer = $"Shoot Cooldown"
@onready var collision: CollisionShape2D = $Collision
@onready var root := get_tree().current_scene
@onready var required: Label = $"../UI/Coins/Rotation/Required"
@onready var coins: Label = $"../UI/Coins/Rotation/Coins"

@export var SPEED = 150.0
@export var COOLDOWN := 0.1
@export var REQUIRED_COINS: int
@export_category("External")
@export var direction: Vector2

var stored_coins := 0
var is_alive := true
var can_shoot := true
var can_move := true

func _ready() -> void:
	# Set Cooldown
	shoot_cooldown.wait_time = COOLDOWN
	required.text = str(REQUIRED_COINS)

func _input(event: InputEvent) -> void:
	# Rotate toward Mouse
	if event is InputEventMouseMotion:
		rotation = deg_to_rad(event.relative.y + event.relative.y)

func _physics_process(delta: float) -> void:
	# Get Mouse Position
	var mouse_position = get_global_mouse_position()
		
	# Look at Mouse
	look_at(lerp(Vector2(rotation, 0), mouse_position, 1.0))
	
	# Shoot
	if Input.is_action_pressed("RMB") and can_shoot:
		shoot()
	
	# Coins
	if Shortcuts.coins_to_be_added > 0:
		stored_coins += Shortcuts.coins_to_be_added
		Shortcuts.coins_to_be_added = 0
	coins.text = str(stored_coins)
	
	# Movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("LMB") and can_move:
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
	# Instantiate and Push
	can_shoot = false
	var instance  = laser.instantiate()
	instance.EXCLUDE = self
	instance.direction = rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = rotation
	root.add_child.call_deferred(instance)
	instance.z_index = z_index - 1
	shoot_cooldown.start()

func _on_shoot_cooldown_timeout() -> void:
	# Shoot Cooldown Over
	can_shoot = true

func die() -> void:
	# Die
	is_alive = false
	can_move = false
	collision.disabled = true
	ship.visible = false
	flame.visible = false
	can_shoot = false
	shoot_cooldown.stop()
	await get_tree().create_timer(4).timeout
	self.queue_free()
