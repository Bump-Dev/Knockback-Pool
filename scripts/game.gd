extends Node2D

func _ready():
	$CanvasLayer.show()

func _process(delta):
	$CanvasLayer/Player1.text = str("Player 1\n",$Player1.score)
	$CanvasLayer/Player2.text = str("Player 2\n",$Player2.score)
