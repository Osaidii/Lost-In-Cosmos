extends Node2D

func _on_check_body_entered(body: Node2D) -> void:
	if body is Player:
		Shortcuts.coins_to_be_added += 10
		self.queue_free()
