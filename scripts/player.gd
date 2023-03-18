extends RigidBody2D

@export var speed:int = 250
var id

func _ready():
	id = name.right(1)
	$Label.text = id
	randomize()
	modulate = Color.from_hsv(randf(), randf_range(0.25, 1), 1)

func _integrate_forces(state):
	var dir: = Vector2(
		Input.get_action_strength("right"+id) - Input.get_action_strength("left"+id),
		Input.get_action_strength("down"+id) - Input.get_action_strength("up"+id)
	)
	apply_force(dir*speed)
