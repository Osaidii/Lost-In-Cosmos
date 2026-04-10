extends CharacterBody2D

@export var SPEED = 300

var direction: float
var spawn_position: Vector2
var spawn_rotation: float

func _ready() -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation + deg_to_rad(90)

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(direction + deg_to_rad(90))
	move_and_slide()
