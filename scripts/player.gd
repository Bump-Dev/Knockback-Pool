extends RigidBody2D

const DEFAULT_SPEED = 1000
const DEFAULT_MASS = 10.0
const DEFAULT_FRICTION: = 1.0

@onready var Sprite := $Sprite2D
@onready var Collision := $CollisionShape2D
@onready var Text := $Label
@onready var Anim := $AnimationPlayer
@onready var RespawnTimer := $RespawnTimer
@onready var PusherTimer := $PusherTimer
@onready var PowerUpTimer := $PowerUpTimer
@onready var Forcefield := $Forcefield
@onready var ForcefieldAnim := $ForcefieldAnim

var speed := 2000
var friction := physics_material_override.friction
var target_pos:Vector2
var score:int = 0
var pusher:RigidBody2D
var id:String
var lost:bool
var effect:String
var dir

func _ready():
	id = name.right(1)
	Text.text = id
	randomize()
	Sprite.modulate = Color.from_hsv(randf(), randf_range(0.25, 1), 1)
	Text.modulate = Sprite.modulate


func _integrate_forces(state):
	if Anim.current_animation == "respawn":
		state.transform = Transform2D(0,Vector2.ZERO)
	if id == "0":
		dir = global_position.direction_to(get_parent().get_node("Player1").global_position)
	else:
		dir = Vector2(
			Input.get_action_strength("right"+id) - Input.get_action_strength("left"+id),
			Input.get_action_strength("down"+id) - Input.get_action_strength("up"+id)
		)
	apply_force(dir*speed)
	angular_velocity = linear_velocity.x/50
	
func _process(_delta):
	if Anim.current_animation == "lose":
		position = lerp(position,target_pos,0.05)

func lose(hole_pos):
	lost = true
	if pusher:
		pusher.score += 1
	else:
		if score > 0:
			score -= 1
	target_pos = hole_pos
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	collision_layer = 0
	collision_mask = 0
	call_deferred("set_freeze_enabled",true)
	if Anim.current_animation != "lose":
		Anim.play("lose")
	RespawnTimer.start()

func respawn():
	position = Vector2.ZERO
	pusher = null
	visible = true
	collision_layer = 1
	collision_mask = 1
	speed = DEFAULT_SPEED
	call_deferred("set_freeze_enabled",false)
	Anim.play("respawn")
	Forcefield.modulate.a = 0

func respawned():
	lost = false

func _on_body_entered(body):
	if 'Player' in body.name:
		pusher = body
		PusherTimer.start()

func _on_respawn_timer_timeout():
	respawn()

func _on_pusher_timer_timeout():
	pusher = null
	
func _on_power_up_timer_timeout():
	if Forcefield.modulate.a == 1:
		speed = DEFAULT_SPEED
		mass = DEFAULT_MASS
		friction = DEFAULT_FRICTION
		ForcefieldAnim.play_backwards("show_forcefield")
