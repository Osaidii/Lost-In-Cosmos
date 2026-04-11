extends CharacterBody2D

@onready var laser := load("uid://dx1pno2t1v35i")
@onready var shoot_cooldown: Timer = $"Shoot Cooldown"
@onready var collision: CollisionShape2D = $Collision
@onready var ship: Sprite2D = $Ship
@onready var flame: Sprite2D = $Ship/Flame
@onready var root := get_tree().get_root().get_node("World")

@export var SPEED = 150.0
@export var COOLDOWN := 0.1

var can_shoot := true
var can_move := true

func _ready() -> void:
	shoot_cooldown.wait_time = COOLDOWN

func _physics_process(delta: float) -> void:
	var direction = null
	if direction and can_move:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	if can_shoot:
		shoot()
	move_and_slide()

func die() -> void:
	can_move = false
	can_shoot = false
	collision.disabled = true
	ship.visible = false
	flame.visible = false
	shoot_cooldown.stop()
	await get_tree().create_timer(1).timeout
	self.queue_free()

func shoot() -> void:
	can_shoot = false
	var instance  = laser.instantiate()
	instance.EXCLUDE = self
	instance.direction = rotation
	instance.spawn_position = global_position
	instance.spawn_rotation = rotation
	instance.z_index = z_index - 1
	root.add_child.call_deferred(instance)
	shoot_cooldown.start()
	can_shoot = false
	shoot_cooldown.start()

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
