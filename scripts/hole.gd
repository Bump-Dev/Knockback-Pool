extends Area2D

func _on_body_entered(body):
	if not body.get("id") == null:
		body.lose(position)
