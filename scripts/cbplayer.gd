extends CharacterBody2D

@export var speed: = 500
@export var acceleration: = 1
@export var friction: = 0.5
var target_pos:Vector2
var id

func _ready():
	id = name.right(1)
	$Label.text = id
	randomize()
	modulate = Color.from_hsv(randf(), randf_range(0.25, 1), 1)
	
func _physics_process(delta):
	if $AnimationPlayer.current_animation == "lose":
		position = lerp(position,target_pos,0.05)
	else:
		var direction = Vector2(Input.get_axis("left"+id, "right"+id),Input.get_axis("up"+id, "down"+id))
		if direction:
			velocity = velocity.lerp(direction * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction)
		move_and_slide()

func lose(hole_pos):
	target_pos = hole_pos
	$AnimationPlayer.play("lose")
