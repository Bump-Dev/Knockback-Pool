extends Node2D

@export var power_ups:Array[PackedScene]

const RANGE = Vector2(464,224)

func _ready():
	$CanvasLayer.show()

func _process(delta):
	$CanvasLayer/Player1.text = str("Player 1\n",$Player1.score)
	$CanvasLayer/Player2.text = str("Player 2\n",$Player2.score)

func _on_powerup_timer_timeout():
	if $Powerups.get_child_count() < 3:
		var r = randi_range(0,power_ups.size()-1)
		var p:Area2D = power_ups[r].instantiate()
		var random_x = randf_range(-RANGE.x,RANGE.x)
		var random_y = randf_range(-RANGE.y,RANGE.y)
		p.global_position = Vector2(random_x,random_y)
		$Powerups.add_child(p)
