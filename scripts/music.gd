extends Control

@onready var music_1: AudioStreamPlayer = $"Music 1"
@onready var music_2: AudioStreamPlayer = $"Music 2"
@onready var music_3: AudioStreamPlayer = $"Music 3"

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	music_1.play()

func _on_music_1_finished() -> void:
	var number = rng.randi_range(2, 3)
	if number >= 2:
		music_3.play()
	else:
		music_2.play()

func _on_music_2_finished() -> void:
	var number = rng.randi_range(1, 3)
	if number >= 1.5:
		music_3.play()
	else:
		music_2.play()

func _on_music_3_finished() -> void:
	var number = rng.randi_range(1, 2)
	if number >= 1:
		music_3.play()
	else:
		music_2.play()
