extends Node

@export
var PlayerScene = preload("res://app/nodes/actors/player.tscn")

@export
var PORT :int
@export
var IPADDRESS = "127.0.0.1"
@onready
var ref_to_player_manager = get_node('../players')

func _enter_tree():
#	# Start the server if Godot is passed the '--server' argument,
#	# and start a client otherwise
#	if '--server' in OS.get_cmdline_args():
#		start_network(true)
#	else:
#		start_network(false)
	pass

func _ready():
	gamestate.connect("try_host_game", self._host_game)
	gamestate.connect("try_join_game", self._join_game)
	pass

func _host_game():
	print('host game')
	start_network(true)
	pass


func _join_game():
	print('join game')
	start_network(false)
	pass


func start_network(server : bool) -> void:
	var peer = ENetMultiplayerPeer.new()
	if server:
		# Listen to peer connections, and create new player for them
		multiplayer.peer_connected.connect(self._create_player)
		
		# Listen to peer disocnnections, and destroy their players
		multiplayer.peer_disconnected.connect(self._destroy_player)
		
		peer.create_server(PORT)
		print('server listening on localhost port ' + str(PORT))
		
		# need to create host player manually because peer_connected never fires on the server
		# server id is always 1
		multiplayer.set_multiplayer_peer(peer)
		_create_player(multiplayer.get_unique_id())
	else:
		peer.create_client(IPADDRESS, PORT)
		multiplayer.set_multiplayer_peer(peer)
	
	

func _create_player(id : int) -> void:
	print('create player : ' + str(multiplayer.get_unique_id()))
	# Instantiate a new player this this clinet
	var p = PlayerScene.instantiate()
	p.name = str(id)
	ref_to_player_manager.add_child(p)

func _destroy_player(id : int) -> void:
	print('destroy player')
	ref_to_player_manager.get_node(str(id)).queue_free()
