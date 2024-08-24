extends Node

var network = ENetMultiplayerPeer.new()
var port = 9999
var maxPlayers = 3000
var playerList = {}
var gamePortId = 8000

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, maxPlayers)
	multiplayer.multiplayer_peer = network
	multiplayer.peer_connected.connect(onConnect)
	multiplayer.peer_disconnected.connect(func(id): print("Player dissconected. ID: ", id))
	print("Server Started!")

func uptickId():
	gamePortId += 1
	if gamePortId == 9999:
		gamePortId = 8000

func onConnect(id):
	print(id)
	rpc_id(id, "logUserInfo", id)
	
@rpc("any_peer", "call_remote", "reliable")
func updateLobby(list):
	playerList = list.duplicate()
	rpc("updateLobby", playerList)
	pass
	
@rpc("any_peer", "call_remote", "reliable")
func logUserInfo(id, username):
	playerList[username] = id
	print(playerList)
	rpc("updateLobby", playerList)
	
@rpc("any_peer", "call_remote", "reliable", 0)
func recieveClientData(data):
	print(data)
	pass
	
@rpc("authority", "call_remote", "reliable", 0)
func joinGameServer():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func createGameServer(player1, player2):
	print("Creating game lobby for " + player1 + " and " + player2)
	var game = load("res://Debug.tscn").instantiate()
	game.port = gamePortId
	uptickId()
	add_child(game)
	rpc_id(int(playerList[player1]), "joinGameServer", game.port)
	rpc_id(int(playerList[player2]), "joinGameServer", game.port)
	pass
