extends Area2D

@export var speed:int = 1000
@export var mass:float = 10
@export_range(0,1) var friction:float = 1
var color:Color

func _ready():
	color = $Sprite2D.texture.get_image().get_pixel(64,64)
	
func _on_body_entered(body):
	if "Player" in body.name:
		body.speed = speed
		body.mass = mass
		body.friction = friction
		body.Forcefield.modulate = Color(color.r,color.g,color.b)
		if body.Forcefield.modulate.a == 0:
			body.ForcefieldAnim.play("show_forcefield")
		body.PowerUpTimer.start()
		queue_free()


