extends Node2D

func _ready():
	$CanvasLayer.show()

func _process(delta):
	$CanvasLayer/Player1.text = str("Player 1\n",$Player1.score)
	$CanvasLayer/Player2.text = str("Player 2\n",$Player2.score)
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if !DisplayServer.window_get_mode():
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
