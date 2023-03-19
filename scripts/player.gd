extends RigidBody2D

@export var speed:int = 250
var target_pos:Vector2
var score:int = 0
var pusher:RigidBody2D
var id:String
var reset_pos:bool

func _ready():
	name = str(get_multiplayer_authority())
	id = name.left(1)
	$Label.text = id
	randomize()
	modulate = Color.from_hsv(randf(), randf_range(0.25, 1), 1)

func _integrate_forces(state):
	if reset_pos:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.transform.origin = Vector2.ZERO
		reset_pos = false
		collision_layer = 1
		collision_mask = 1
	
	if is_multiplayer_authority():
		var dir: = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		apply_force(dir*speed)
		angular_velocity = linear_velocity.x/50
		rpc("remote_set_position",linear_velocity,angular_velocity)

@rpc("unreliable")
func remote_set_position(pos, rot):
	linear_velocity = pos
	angular_velocity = rot
	

func _process(delta):
	if $AnimationPlayer.current_animation == "lose":
		position = lerp(position,target_pos,0.05)

func lose(hole_pos):
	if pusher:
		pusher.score += 1
	else:
		if score > 0:
			score -= 1
#	if id == "1":
#		$"../Game".scores[0] = score
#	else:
#		$"../Game".scores[1] = score
	target_pos = hole_pos
	call_deferred("set_freeze_enabled",true)
	collision_layer = 0
	collision_mask = 0
	$AnimationPlayer.play("lose")
	$RespawnTimer.start()

func respawn():
	pusher = null
	visible = true
	$AnimationPlayer.play("respawn")
	call_deferred("set_freeze_enabled",false)
	reset_pos = true

func _on_body_entered(body):
	if not body.get("id") == null:
		pusher = body
		$PusherTimer.start()


func _on_respawn_timer_timeout():
	respawn()

func _on_pusher_timer_timeout():
	pusher = null
