extends Node2D

var multiplayer_peer := ENetMultiplayerPeer.new()
const PORT:int = 9999
const ADDRESS:String = 'localhost'
var connected_peer_ids := []
var scores := [0,0]

func _ready():
	$CanvasLayer.show()

func _process(delta):
#	$CanvasLayer/Player1.text = str("Player 1\n",scores[0])
#	$CanvasLayer/Player2.text = str("Player 2\n",scores[1])
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if !DisplayServer.window_get_mode():
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if Input.is_action_just_pressed("host"):
		print('Server')
		multiplayer_peer.create_server(PORT)
		multiplayer.multiplayer_peer = multiplayer_peer
		print(multiplayer.get_unique_id())
		
		add_player(1)
		
		multiplayer_peer.peer_connected.connect(
			func(new_peer_id):
				await get_tree().create_timer(1).timeout
				rpc("add_newly_connected_player", new_peer_id)
				rpc_id(new_peer_id, "add_previously_connected_players", connected_peer_ids)
				
				add_player(new_peer_id)
		)
	
	if Input.is_action_just_pressed("join"):
		print('Client')
		multiplayer_peer.create_client(ADDRESS, PORT)
		multiplayer.multiplayer_peer = multiplayer_peer
		print(multiplayer.get_unique_id())

func add_player(peer_id):
	connected_peer_ids.append(peer_id)
	var player = preload("res://scenes/player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)

@rpc
func add_newly_connected_player(new_peer_id):
	add_player(new_peer_id)

@rpc
func add_previously_connected_players(peer_ids):
	for peer_id in peer_ids:
		add_player(peer_id)
	
