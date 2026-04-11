extends Control

@onready var WORLD = load("uid://jlyujdd31grn") as PackedScene
@onready var transition: AnimationPlayer = $Transition

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)

func _on_exit_pressed() -> void:
	get_tree().quit()
