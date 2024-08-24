extends Node
#Player Info
var player1id = 0
var player2id = 0
var player1userName = ""
var player2userName = ""
var p1diver1 = 0
var p1diver2 = 0
var p2diver1 = 0
var p2diver2 = 0
var p1deck = []
var p1deckString = ""
var p2deck = []
var p2deckString = ""
var p1health = 20
var p2health = 20
var p1mulligan = []
var p2mulligan = []
var p1attacktoken = false
var p2attacktoken = false
var p1hand = []
var p2hand = []
var activeplayer = ""
var p1energy = 0
var p1energyReserve = 0
var p1energyGems = 0
var p2energy = 0
var p2energyReserve = 0
var p2energyGems = 0
var p1battlefield = []
var p2battlefield = []
var p1graveyard = []
var p2graveyard = []
var attacking = []
var blocking = []
var attackingPlayer = ""
var passed = false
var tokenNum = 1
var startingPlayer = ""
var castingPlayer = ""
#Timeline Info
var timeline = 0
var shifts = 0
var shiftYard = []
var timelineAge = 0
var timelineName = "None"
#Other tracked stats
var p1Strength = 0
var p2Strength = 0
var p1Durability = 0
var p2Durability = 0
var p1bonusStength = 0
var p1bonusDurability = 0
var p2bonusStength = 0
var p2bonusDurability = 0
var globalStrength = 0
var globalDurability = 0
var age = 0
var preChain = []
var chain = []
var combat = false
var blocked = false
var maxBlockers = 0
var currentBlockers = 0
#Debug vars
var command = ""
var error = ""
#Networking info
var port = 0
var network = ENetMultiplayerPeer.new()
var startCount = 0
var playerCount = 0

func _ready():
	port = int(OS.get_cmdline_args()[0])
	start_server()
	
	
func start_server():
	network.create_server(port, 2)
	multiplayer.multiplayer_peer = network
	multiplayer.peer_connected.connect(onConnect)
	multiplayer.peer_disconnected.connect(onDissconect)
	print("Server Started!")
	
func onDissconect(id):
	print("Player has disconected")
	playerCount -= 1
	error = str(playerCount)
	if playerCount == 0:
		get_tree().quit()
	
@rpc("any_peer", "call_remote", "reliable")
func getClientInfo(username, deck, id):
	if id == player1id:
		player1userName = username
		p1deckString = deck
	else:
		player2userName = username
		p2deckString = deck
	
@rpc("any_peer", "call_remote", "reliable")
func updateLobby():
	pass
	
@rpc("authority", "call_remote", "reliable")
func updateClient():
	pass
	
@rpc("any_peer", "call_remote", "reliable")
func updateCard(hand, id):
	if id == player1id:
		p1hand = hand
	else:
		p2hand = hand
	pass
	
@rpc("any_peer", "call_remote", "reliable")
func logUserInfo():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func recieveClientData(data):
	command = data
	parseCommand()
	updatePlayers()
	
@rpc("authority", "call_remote", "reliable", 0)
func joinGameServer():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func createGameServer():
	pass

@rpc("authority", "call_remote", "reliable", 0)
func playCard():
	pass
	
@rpc("authority", "call_remote", "reliable", 0)
func cancel():
	pass

@rpc("authority", "call_remote", "reliable", 0)
func passUsernames():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func setDivers():
	pass
	
func updatePlayers():
	var act = ""
	if activeplayer == "p1":
		act = player1userName
	else:
		act = player2userName
	rpc_id(player1id, "updateClient", p1health, p2health, p1energy, p2energy, p1energyReserve, p2energyReserve, timelineName, act, p1attacktoken, p2attacktoken, p2hand.size(), p1battlefield, p2battlefield, p2diver1, p2diver2, attacking, blocking, combat, blocked)
	rpc_id(player2id, "updateClient", p2health, p1health, p2energy, p1energy, p2energyReserve, p1energyReserve, timelineName, act, p2attacktoken, p1attacktoken, p1hand.size(), p2battlefield, p1battlefield, p1diver1, p1diver2, attacking, blocking, combat, blocked)
	rpc_id(player1id, "updateCard", p1hand)
	rpc_id(player2id, "updateCard", p2hand)
	getCardStats()
	pass

func onConnect(id):
	playerCount += 1
	if player1id == 0:
		player1id = id
		rpc_id(id, "getClientInfo")
	else:
		player2id = id
		rpc_id(id, "getClientInfo")
		await get_tree().create_timer(1).timeout
		command = "START"
		parseCommand()
		rpc_id(player1id, "passUsernames", player1userName, player2userName)
		rpc_id(player2id, "passUsernames", player2userName, player1userName)
		rpc_id(player1id, "setDivers", [p1diver1, p1diver2, p2diver1, p2diver2], [[get_node(NodePath(p1diver1)).strength, get_node(NodePath(p1diver1)).durability, get_node(NodePath(p1diver1)).depleteEffects], [get_node(NodePath(p1diver2)).strength, get_node(NodePath(p1diver2)).durability, get_node(NodePath(p1diver2)).depleteEffects], [get_node(NodePath(p2diver1)).strength, get_node(NodePath(p2diver1)).durability, get_node(NodePath(p2diver1)).depleteEffects], [get_node(NodePath(p2diver2)).strength, get_node(NodePath(p2diver2)).durability, get_node(NodePath(p2diver2)).depleteEffects]])
		rpc_id(player2id, "setDivers", [p2diver1, p2diver2, p1diver1, p1diver2], [[get_node(NodePath(p2diver1)).strength, get_node(NodePath(p2diver1)).durability, get_node(NodePath(p2diver1)).depleteEffects], [get_node(NodePath(p2diver2)).strength, get_node(NodePath(p2diver2)).durability, get_node(NodePath(p2diver2)).depleteEffects], [get_node(NodePath(p1diver1)).strength, get_node(NodePath(p1diver1)).durability, get_node(NodePath(p1diver1)).depleteEffects], [get_node(NodePath(p1diver2)).strength, get_node(NodePath(p1diver2)).durability, get_node(NodePath(p1diver2)).depleteEffects]])
		updatePlayers()
		
@rpc("authority", "call_remote", "reliable", 0)
func attacksDeclared():
	pass
		
@rpc("any_peer", "call_remote", "reliable", 0)
func switchAttacks(id, index, player):
	var temp = attacking.pop_at(attacking.find(id))
	if index == -1:
		attacking.append(temp)
	else:
		attacking.insert(index, temp)
	if player == player1userName:
		rpc_id(player2id, "switchAttacks", id, index)
	else:
		rpc_id(player1id, "switchAttacks", id, index)
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func switchBlocks(id, index, player):
	var temp = blocking.pop_at(blocking.find(id))
	if index == -1:
		blocking.append(temp)
	else:
		blocking.insert(index, temp)
	if player == player1userName:
		rpc_id(player2id, "switchBlocks", id, index)
	else:
		rpc_id(player1id, "switchBlocks", id, index)
	pass
	
@rpc("authority", "call_remote", "reliable", 0)
func endCombat(battlefield1, battlefield2):
	pass
	
@rpc("authority", "call_remote", "reliable", 0)
func updateCards():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func updateMulligans(mulligans, player):
	if player == player1userName:
		draw("p1", mulligans.size())
		for i in mulligans:
			p1deck.append(p1mulligan[i])
			p1mulligan[i] = null
		for i in p1mulligan:
			if i != null:
				p1hand.append(i)
		p1deck.shuffle()
		rpc_id(player1id, "updateCard", p1hand)
	else:
		draw("p2", mulligans.size())
		for i in mulligans:
			p2deck.append(p2mulligan[i])
			p2mulligan[i] = null
		for i in p2mulligan:
			if i != null:
				p2hand.append(i)
		p2deck.shuffle()
		rpc_id(player2id, "updateCard", p2hand)
	command = "START"
	parseCommand()
	
@rpc("any_peer", "call_remote", "reliable", 0)
func alliedPreChain(preChain):
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func enemyPreChain(preChainSize):
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func enemyChain(preChainSize):
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func cancelChain(cardName, player):
	if player == player1userName:
		if get_node(NodePath(cardName)).cardType == "Agent" or get_node(NodePath(cardName)).cardType == "Immortalized Agent":
			preChain.pop_at(preChain.find(cardName))
		else:
			p1hand.append(preChain.pop_at(preChain.find(cardName)))
			rpc_id(player2id, "enemyPreChain", preChain.size())
	else:
		if get_node(NodePath(cardName)).cardType == "Agent" or get_node(NodePath(cardName)).cardType == "Immortalized Agent":
			preChain.pop_at(preChain.find(cardName))
		else:
			p2hand.append(preChain.pop_at(preChain.find(cardName)))
			rpc_id(player1id, "enemyPreChain", preChain.size())
	if get_node(NodePath(cardName)).targets > 0:
		get_node(NodePath(cardName)).targetList = []
	updatePlayers()
	
@rpc("any_peer", "call_remote", "reliable", 0)
func commitChain(player):
	if chain.size() == 0:
		passed = true
		castingPlayer = activeplayer
	else:
		passed = false
	chain.append_array(preChain)
	if player == player1userName:
		rpc_id(player2id, "enemyChain", preChain)
		activeplayer = "p2"
	else:
		rpc_id(player1id, "enemyChain", preChain)
		activeplayer = "p1"
	for i in preChain:
		if get_node(NodePath(i)).control == "p1" and get_node(NodePath(i)).cardType != "Agent" and get_node(NodePath(i)).cardType != "Immortalized Agent":
			p1energyReserve -= get_node(NodePath(i)).cost
			if p1energyReserve < 0:
				p1energy += p1energyReserve
				p1energyReserve = 0
		elif get_node(NodePath(i)).control == "p2" and get_node(NodePath(i)).cardType != "Agent" and get_node(NodePath(i)).cardType != "Immortalized Agent":
			p2energyReserve -= get_node(NodePath(i)).cost
			if p2energyReserve < 0:
				p2energy += p2energyReserve
				p2energyReserve = 0
		if get_node(NodePath(i)).cardType != "Agent" or get_node(NodePath(i)).cardType != "Immortalized Agent":
			get_node(NodePath(i)).depleted = true
	preChain = []
	updatePlayers()
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func clearChain():
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func target(cardName, index, target):
	var card = get_node(NodePath(cardName))
	var failure = false
	if card.control == "p1":
		if card.unique:
			for i in card.targetList:
				if i == target:
					failure = true
					break
		if !failure:
			if card.targetType[index] == "Ally":
				failure = true
				for i in p1battlefield:
					if i == target:
						failure = false
				error = str(failure)
			if card.targetType[index] == "Enemy":
				failure = true
				for i in p2battlefield:
					if i == target:
						failure = false
			if card.targetType[index] == "Discard":
				failure = true
				for i in p1hand:
					if i == target:
						failure = false
			if card.targetType[index] == "AnyPlayer":
				failure = (target == "p1" or target == "p2")
		if !failure:
			card.targetList.append(target)
			if card.targetList.size() == card.targets:
				if card.cardType == "Agent" or card.cardType == "Immortalized Agent":
					preChain.append(cardName)
				else:
					play(cardName, false, 0)
				return
			else:
				index += 1
		rpc_id(player1id, "target", cardName, index, card.targetText[index])
	else:
		if card.unique:
			for i in card.targetList:
				if i == target:
					failure = true
					break
		if !failure:
			if card.targetType[index] == "Ally":
				failure = true
				for i in p2battlefield:
					if i == target:
						failure = false
				error = str(failure)
			if card.targetType[index] == "Enemy":
				failure = true
				for i in p1battlefield:
					if i == target:
						failure = false
			if card.targetType[index] == "Discard":
				failure = true
				for i in p2hand:
					if i == target:
						failure = false
			if card.targetType[index] == "AnyPlayer":
				failure = (target == "p1" or target == "p2")
		if !failure:
			card.targetList.append(target)
			if card.targetList.size() == card.targets:
				if card.cardType == "Agent" or card.cardType == "Immortalized Agent":
					preChain.append(cardName)
				else:
					play(cardName, false, 0)
				return
			else:
				index += 1
		rpc_id(player2id, "target", cardName, index, card.targetText[index])
	pass
	
@rpc("any_peer", "call_remote", "reliable", 0)
func deplete(cardName, player):
	if !get_node(NodePath(cardName)).depleted and !get_node(NodePath(cardName)).depleteing and !(combat and !blocked):
		get_node(NodePath(cardName)).deplete()
		rpc_id(player1id, "toggleDeplete", cardName)
		rpc_id(player2id, "toggleDeplete", cardName)
		if player == "p1":
			rpc_id(player2id, "enemyPreChain", preChain.size())
		else:
			rpc_id(player1id, "enemyPreChain", preChain.size())
	else:
		if player == "p1":
			rpc_id(player1id, "cancelDeplete", cardName)
		else:
			rpc_id(player2id, "cancelDeplete", cardName)
	pass

@rpc("any_peer", "call_remote", "reliable", 0)
func cancelDeplete(cardName):
	var card = get_node(NodePath(cardName))
	card.depleteing = false
	preChain.pop_at(preChain.find(cardName))
	if card.control == "p1":
		rpc_id(player1id, "cancelDeplete", cardName)
		rpc_id(player2id, "enemyPreChain", preChain.size())
		rpc_id(player2id, "toggleDeplete", cardName)
	else:
		rpc_id(player2id, "cancelDeplete", cardName)
		rpc_id(player1id, "enemyPreChain", preChain.size())
		rpc_id(player1id, "toggleDeplete", cardName)
	
@rpc("any_peer", "call_remote", "reliable", 0)
func toggleDeplete(cardName):
	pass

#Textbased UI
func _process(delta):
	$RichTextLabel.text = ""
	$RichTextLabel.text += "Port: " + str(port)
	$RichTextLabel.text += "\n" + str(player1userName)
	$RichTextLabel.text += "\nHealth: " + str(p1health)
	$RichTextLabel.text += "\nDiver 1: " + str(p1diver1)
	$RichTextLabel.text += "\nDiver 2: " + str(p1diver2)
	$RichTextLabel.text += "\nHand: " + str(p1hand)
	$RichTextLabel.text += "\nBattlefield: " + str(p1battlefield)
	$RichTextLabel.text += "\nGraveyard: " + str(p1graveyard)
	$RichTextLabel.text += "\nDeck: " + str(p1deck)
	$RichTextLabel.text += "\nAttack Token: " + str(p1attacktoken)
	$RichTextLabel.text += "\nEnergy: " + str(p1energy)
	$RichTextLabel.text += "\nEnergy Reserve: " + str(p1energyReserve)
	$RichTextLabel.text += "\n---------------------------------------------"
	$RichTextLabel.text += "\n" + str(player2userName)
	$RichTextLabel.text += "\nHealth: " + str(p2health)
	$RichTextLabel.text += "\nDiver 1: " + str(p2diver1)
	$RichTextLabel.text += "\nDiver 2: " + str(p2diver2)
	$RichTextLabel.text += "\nHand: " + str(p2hand)
	$RichTextLabel.text += "\nBattlefield: " + str(p2battlefield)
	$RichTextLabel.text += "\nGraveyard: " + str(p2graveyard)
	$RichTextLabel.text += "\nDeck: " + str(p2deck)
	$RichTextLabel.text += "\nAttack Token: " + str(p2attacktoken)
	$RichTextLabel.text += "\nEnergy: " + str(p2energy)
	$RichTextLabel.text += "\nEnergy Reserve: " + str(p2energyReserve)
	$RichTextLabel.text += "\n---------------------------------------------"
	$RichTextLabel.text += "\nActive Player: " + activeplayer
	$RichTextLabel.text += "\nChain: " + str(chain)
	$RichTextLabel.text += "\nCombat"
	$RichTextLabel.text += "\nAttacking: " + str(attacking)
	$RichTextLabel.text += "\nBlocking: " + str(blocking)
	$RichTextLabel.text += "\nLast Input: " + str(command)
	$RichTextLabel.text += "\nError: " + str(error)
	$RichTextLabel.text += "\nCombat: " + str(combat)
	$RichTextLabel.text += "\nPassed: " + str(passed)
	if Input.is_action_just_pressed("ui_accept") and $TextEdit.text != "" and $TextEdit.text != "\n":
		command = $TextEdit.text.replace("\n", "")
		parseCommand()
		$TextEdit.text = ""
		
#Parses commands inputted by user
func parseCommand():
	command = command.split(" ")
	if command[0] == "START":
		if startCount == 0:
			startGame()
		if startCount == 2:
			startTurn1()
		startCount += 1
	if command[0] == "PLAY":
		play(command[1], false, 0)
	if command[0] == "PLAYDIVER":
		play(command[1], true, command[2])
	if command[0] == "PASS":
		passPriority()
	if command[0] == "ATTACK":
		command.remove_at(0)
		declareAttack(activeplayer)
	if command[0] == "BLOCK":
		command.remove_at(0)
		declareBlockers()
	if command[0] == "DECATTACK":
		if command[2] == player1userName:
			decAttack(command[1], "p1")
		else:
			decAttack(command[1], "p2")
	if command[0] == "REMATTACK":
		if command[2] == player1userName:
			remAttack(command[1], "p1")
		else:
			remAttack(command[1], "p2")
	if command[0] == "DECBLOCK":
		if command[2] == player1userName:
			decBlock(command[1], "p1", command[3])
		else:
			decBlock(command[1], "p2", command[3])
	if command[0] == "REMBLOCK":
		if command[2] == player1userName:
			remBlock(command[1], "p1", command[3])
		else:
			remBlock(command[1], "p2", command[3])
	pass
	
#Turns deck strings into nodes with logic, draws starting hand and assigns starting player
func startGame():
	randomize()
	var deck1 = p1deckString.split(" ")
	var deck2 = p2deckString.split(" ")
	var diver12 = Node.new()
	diver12.name = deck1[-1] + "_1"
	diver12.set_script(load("res://Card Scripts/" + str(deck1[-1]) + ".gd"))
	diver12.control = "p1"
	deck1.remove_at(deck1.size()-1)
	add_child(diver12)
	p1diver2 = str(diver12.name)
	var diver11 = Node.new()
	diver11.name = deck1[-1] + "_1"
	diver11.set_script(load("res://Card Scripts/" + str(deck1[-1]) + ".gd"))
	diver11.control = "p1"
	deck1.remove_at(deck1.size()-1)
	add_child(diver11)
	p1diver1 = str(diver11.name)
	for i in deck1:
		var split = i.split("_")
		for copy in range(1,int(split[0]) + 1):
			var card = Node.new()
			card.name = split[1] + "_" + str(copy) + "_1"
			card.set_script(load("res://Card Scripts/" + split[1] + ".gd"))
			card.control = "p1"
			p1deck.append(str(card.name))
			add_child(card)
	var diver22 = Node.new()
	diver22.name = deck2[-1] + "_2"
	diver22.set_script(load("res://Card Scripts/" + str(deck2[-1]) + ".gd"))
	diver22.control = "p2"
	deck2.remove_at(deck2.size()-1)
	add_child(diver22)
	p2diver2 = str(diver22.name)
	var diver21 = Node.new()
	diver21.name = deck2[-1] + "_2"
	diver21.set_script(load("res://Card Scripts/" + str(deck2[-1]) + ".gd"))
	diver21.control = "p2"
	deck2.remove_at(deck2.size()-1)
	add_child(diver21)
	p2diver1 = str(diver21.name)
	for i in deck2:
		var split = i.split("_")
		for copy in range(1,int(split[0]) + 1):
			var card = Node.new()
			card.name = split[1] + "_" + str(copy) + "_2"
			card.set_script(load("res://Card Scripts/" + split[1] + ".gd"))
			card.control = "p2"
			p2deck.append(str(card.name))
			add_child(card)
	p1deck.shuffle()
	p2deck.shuffle()
	for i in range(0,4):
		p1mulligan.append(p1deck.pop_front())
		p2mulligan.append(p2deck.pop_front())
	rpc_id(player1id, "updateMulligans", p1mulligan)
	rpc_id(player2id, "updateMulligans", p2mulligan)
	pass
	
func startTurn1():
	var coin = randi_range(0,1)
	if coin == 0:
		activeplayer = "p1"
		p1attacktoken = true
		startingPlayer = "p1"
	else:
		activeplayer = "p2"
		p2attacktoken = true
		startingPlayer = "p2"
	turnStart()

#(NodeName, Boolean, Int) plays a card second options are to specify which diver to play
func play(cardName, isDiver, diverId):
	var cardpath = NodePath(cardName)
	if get_node(cardpath).control == activeplayer:
		if activeplayer == "p1":
			if get_node(cardpath).cardType == "Agent" or get_node(cardpath).cardType == "Immortalized Agent":
				if get_node(cardpath).cost <= p1energy:
					p1energy -= get_node(cardpath).cost
					if p1battlefield.size() == 6:
						kill(p1battlefield[int(command[0])])
					if command[0] != "CANCEL":
						if get_node(cardpath).triggerFlags.find("onEnter") >= 0:
							get_node(cardpath).onEnter()
							if get_node(cardpath).get_child_count() > 0:
								for i in get_node(cardpath).get_children():
									if i.triggerFlags.find("onEnter") >= 0:
										i.onEnter()
						for i in p1battlefield:
							if get_node(NodePath(i)).triggerFlags.find("onAllyEnter") >= 0:
								get_node(NodePath(i)).onAllyEnter()
								if get_node(NodePath(i)).get_child_count() > 0:
									for x in get_node(NodePath(i)).get_children():
										if x.triggerFlags.find("onAllyEnter") >= 0:
											x.onAllyEnter()
						get_node(cardpath).age = age
						age += 1
						if isDiver == false:
							p1battlefield.append(p1hand.pop_at(p1hand.find(cardName)))
							rpc_id(player1id, "playCard", p1battlefield.find(cardName), false)
						else:
							if diverId == "1" and p1diver1 != null:
								p1battlefield.append(p1diver1)
								p1diver1 = null
								rpc_id(player1id, "playCard", 1, true)
							elif diverId == "2" and p1diver2 != null:
								p1battlefield.append(p1diver2)
								p1diver2 = null
								rpc_id(player1id, "playCard", 2, true)
						passed = false
						if activeplayer == "p1":
							activeplayer = "p2"
						else:
							activeplayer = "p1"
				else:
					error = "Not enough energy to play this card!"
					rpc_id(player1id, "cancel", error)
					updatePlayers()
			elif get_node(cardpath).cardType == "Slow" or get_node(cardpath).cardType == "Fast":
					if (get_node(cardpath).cardType == "Slow" and chain.size() == 0 and preChain.size() == 0) or get_node(cardpath).cardType == "Fast":
						var totalCost = get_node(cardpath).cost
						for i in preChain:
							if get_node(NodePath(i)).cardType != "Agent" or "Immortalized Agent":
								totalCost += get_node(NodePath(i)).cost
						if totalCost <= p1energy + p1energyReserve:
							if get_node(cardpath).targets > get_node(cardpath).targetList.size():
								get_targets(cardName, get_node(cardpath).targetList.size())
								p1hand.pop_at(p1hand.find(cardName))
							else:
								preChain.append(cardName)
								rpc_id(player1id, "alliedPreChain", preChain, true)
								rpc_id(player2id, "enemyPreChain", preChain.size())
						else:
							error = "Not enough energy to play this card!"
							rpc_id(player1id, "cancel", error)
							updatePlayers()
					else:
						error = "You can't play slow spells with other spells on the chain"
						rpc_id(player1id, "cancel", error)
						updatePlayers()
			elif get_node(cardpath).cardType == "Immediate":
				if get_node(cardpath).cost <= p1energy + p1energyReserve:
					p1energyReserve -= get_node(cardpath).cost
					if p1energyReserve < 0:
						p1energy += p1energyReserve
						p1energyReserve = 0
					p1graveyard.append(p1hand.pop_at(p1hand.find(cardName)))
					get_node(cardpath).effect()
				else:
					error = "Not enough energy to play this card!"
					rpc_id(player2id, "cancel", error)
					updatePlayers()
		else:
			if get_node(cardpath).cardType == "Agent" or get_node(cardpath).cardType == "Immortalized Agent":
				if get_node(cardpath).cost <= p2energy:
					p2energy -= get_node(cardpath).cost
					if p2battlefield.size() == 6:
						kill(p1battlefield[int(command[0])])
					if command[0] != "CANCEL":
						if get_node(cardpath).triggerFlags.find("onEnter") >= 0:
							get_node(cardpath).onEnter()
							if get_node(cardpath).get_child_count() > 0:
								for i in get_node(cardpath).get_children():
									if i.triggerFlags.find("onEnter") >= 0:
										i.onEnter()
						for i in p2battlefield:
							if get_node(NodePath(i)).triggerFlags.find("onAllyEnter") >= 0:
								get_node(NodePath(i)).onAllyEnter()
								if get_node(NodePath(i)).get_child_count() > 0:
									for x in get_node(NodePath(i)).get_children():
										if x.triggerFlags.find("onAllyEnter") >= 0:
											x.onEnter()
						get_node(cardpath).age = age
						age += 1
						if isDiver == false:
							p2battlefield.append(p2hand.pop_at(p2hand.find(cardName)))
							rpc_id(player2id, "playCard", p2battlefield.find(cardName), false)
						else:
							if diverId == "1" and p2diver1 != null:
								p2battlefield.append(p2diver1)
								p2diver1 = null
								rpc_id(player2id, "playCard", 1, true)
							elif diverId == "2" and p2diver2 != null:
								p2battlefield.append(p2diver2)
								p2diver2 = null
								rpc_id(player2id, "playCard", 1, true)
						if activeplayer == "p1":
							activeplayer = "p2"
						else:
							activeplayer = "p1"
						passed = false
				else: 
					error = "Not enough energy to play this card!"
					rpc_id(player2id, "cancel", error)
					updatePlayers()
			elif get_node(cardpath).cardType == "Slow" or get_node(cardpath).cardType == "Fast":
				if (get_node(cardpath).cardType == "Slow" and chain.size() == 0 and preChain.size() == 0) or get_node(cardpath).cardType == "Fast":
					var totalCost = get_node(cardpath).cost
					for i in preChain:
							if get_node(NodePath(i)).cardType != "Agent" or "Immortalized Agent":
								totalCost += get_node(NodePath(i)).cost
					if totalCost <= p2energy + p2energyReserve:
						if get_node(cardpath).targets > get_node(cardpath).targetList.size():
								get_targets(cardName, get_node(cardpath).targetList.size())
								p2hand.pop_at(p2hand.find(cardName))
						else:
							preChain.append(cardName)
							rpc_id(player2id, "alliedPreChain", preChain, true)
							rpc_id(player1id, "enemyPreChain", preChain.size())
					else:
						error = "Not enough energy to play this card!"
						rpc_id(player2id, "cancel", error)
						updatePlayers()
				else:
					error = "You can't play slow spells with other spells on the chain"
					rpc_id(player2id, "cancel", error)
					updatePlayers()
			elif get_node(cardpath).cardType == "Immediate":
				if get_node(cardpath).cost <= p2energy + p2energyReserve:
					p2energyReserve -= get_node(cardpath).cost
					if p2energyReserve < 0:
						p2energy += p2energyReserve
						p2energyReserve = 0
					p2graveyard.append(p2hand.pop_at(p2hand.find(cardName)))
					get_node(cardpath).effect()
				else:
					error = "Not enough energy to play this card!"
					rpc_id(player2id, "cancel", error)
					updatePlayers()
	pass
	
func get_targets(cardName, index):
	error = "2"
	var card = get_node(NodePath(cardName))
	if card.control == "p1":
		rpc_id(player1id, "target", cardName, index, card.targetText[index])
	else:
		rpc_id(player2id, "target", cardName, index, card.targetText[index])
		
#Moves an agent from the battlefield to the graveyard triggering lastgrasp effects
func kill(agent):
	var cardpath = NodePath(agent)
	if get_node(cardpath).triggerFlags.find("onDeath") >= 0:
		get_node(cardpath).onDeath()
		if get_node(cardpath).get_child_count() > 0:
			for i in get_node(cardpath).get_children():
				if i.triggerFlags.find("onDeath") >= 0:
					i.onDeath()
	var dead = false
	if get_node(cardpath).control == "p1":
		for i in p1battlefield:
			if i == agent:
				p1graveyard.append(p1battlefield.pop_at(p1battlefield.find(str(get_node(cardpath).name))))
		for i in attacking:
			if i == agent:
				p1graveyard.append(attacking.pop_at(attacking.find(str(get_node(cardpath).name))))
		for i in blocking:
			if i == agent:
				p1graveyard.append(blocking.pop_at(blocking.find(str(get_node(cardpath).name))))
	else:
		for i in p2battlefield:
			if i == agent:
				p2graveyard.append(p2battlefield.pop_at(p2battlefield.find(str(get_node(cardpath).name))))
		for i in attacking:
			if i == agent:
				p2graveyard.append(attacking.pop_at(attacking.find(str(get_node(cardpath).name))))
		for i in blocking:
			if i == agent:
				p2graveyard.append(blocking.pop_at(blocking.find(str(get_node(cardpath).name))))
	pass	
	
#Resolves all spells and effects on the chain
func resolveChain():
	for i in chain:
		get_node(NodePath(i)).effect()
		if get_node(NodePath(i)).control == "p1":
			p1graveyard.append(i)
		else:
			p2graveyard.append(i)
	chain = []
	rpc("clearChain")
	if combat == false:
		if castingPlayer == "p1":
			activeplayer = "p2"
		else:
			activeplayer = "p1"
		passed = false
		
#(Attacking player, List of attacking agents) Used by a player with the attack token to declare attacks
func declareAttack(player):
	passed = true
	attackingPlayer = player
	error = attackingPlayer
	if player == "p1":
		if activeplayer == "p1" and p1attacktoken == true:
			combat = true
			if activeplayer == "p1":
				activeplayer = "p2"
			else:
				activeplayer = "p1"
			p1attacktoken = false
	else:
		if activeplayer == "p2" and p2attacktoken == true:
			combat = true
			if activeplayer == "p1":
				activeplayer = "p2"
			else:
				activeplayer = "p1"
			p2attacktoken = false
	for i in attacking:
		blocking.append("NONE")
	if attackingPlayer == "p1":
		rpc("attacksDeclared", attacking.size(), player1userName)
	else:
		rpc("attacksDeclared", attacking.size(), player2userName)
	pass

func declareBlockers():
	blocked = true
	passed = false
	
#After both players have passed while in combat, this function reslvoes damage and on hit effects
func resolveAttack():
	if "p1" == attackingPlayer:
		for i in range(0,attacking.size()):
			if blocking[i] == "NONE":
				damage("p2", get_node(NodePath(attacking[i])).strength)
				lifeCheck()
			else:
				if get_node(NodePath(attacking[i])).keywords.find("Overpower") >= 0:
					if get_node(NodePath(blocking[i])).durability < get_node(NodePath(attacking[i])).strength:
						damage("p2", get_node(NodePath(attacking[i])).strength - get_node(NodePath(blocking[i])).durability)
				damage_agent(blocking[i], get_node(NodePath(attacking[i])).strength)
				damage_agent(attacking[i], get_node(NodePath(blocking[i])).strength)
				if get_node(NodePath(blocking[i])).triggerFlags.find("onStrike") >= 0:
					get_node(NodePath(blocking[i])).onStrike()
					if get_node(NodePath(blocking[i])).get_child_count() > 0:
						for x in get_node(NodePath(blocking[i])).get_children():
							if x.triggerFlags.find("onStirke") >= 0:
								x.onStrike()
			if get_node(NodePath(attacking[i])).triggerFlags.find("onStrike") >= 0:
				get_node(NodePath(attacking[i])).onStrike()
				if get_node(NodePath(attacking[i])).get_child_count() > 0:
					for x in get_node(NodePath(attacking[i])).get_children():
						if x.triggerFlags.find("onStirke") >= 0:
							x.onStrike()
	elif "p2" == attackingPlayer:
		for i in range(0,attacking.size()):
			if blocking[i] == "NONE":
				damage("p1", get_node(NodePath(attacking[i])).strength)
				lifeCheck()
			else:
				if get_node(NodePath(attacking[i])).keywords.find("Overpower") >= 0:
					if get_node(NodePath(blocking[i])).durability < get_node(NodePath(attacking[i])).strength:
						damage("p1", get_node(NodePath(attacking[i])).strength - get_node(NodePath(blocking[i])).durability)
				damage_agent(blocking[i], get_node(NodePath(attacking[i])).strength)
				damage_agent(attacking[i], get_node(NodePath(blocking[i])).strength)
				if get_node(NodePath(blocking[i])).triggerFlags.find("onStrike") >= 0:
					get_node(NodePath(blocking[i])).onStrike()
				if get_node(NodePath(blocking[i])).get_child_count() > 0:
					for x in get_node(NodePath(blocking[i])).get_children():
						if x.triggerFlags.find("onStirke") >= 0:
							x.onStrike()
			if get_node(NodePath(attacking[i])).triggerFlags.find("onStrike") >= 0:
				get_node(NodePath(attacking[i])).onStrike()
				if get_node(NodePath(attacking[i])).get_child_count() > 0:
					for x in get_node(NodePath(attacking[i])).get_children():
						if x.triggerFlags.find("onStirke") >= 0:
							x.onStrike()
	combat = false
	for i in blocking:
		if i == "NONE":
			blocking.remove_at(blocking.find("NONE"))
	if attackingPlayer == "p1":
		p1battlefield.append_array(attacking)
		p2battlefield.append_array(blocking)
		activeplayer = "p2"
	else:
		p2battlefield.append_array(attacking)
		p1battlefield.append_array(blocking)
		activeplayer = "p1"
	attacking = []
	blocking = []
	passed = false
	blocked = false
	rpc_id(player1id, "endCombat", p1battlefield, p2battlefield)
	rpc_id(player2id, "endCombat", p2battlefield, p1battlefield)
					
	
#(CardID of token to create, player creating, boolean) Creates a token of the choosen ID under the choosen players control
func createToken(tokenId, player, isAttacking):
	var token = Node.new()
	token.set_script(load("res://Card Scripts/" + str(tokenId) + ".25.gd"))
	token.name = str(tokenId) + "a25_" + str(tokenNum) + "_" + str(player)
	add_child(token)
	tokenNum += 1
	if isAttacking == false:
		if player == 1:
			token.control = "p1"
			p1battlefield.append(str(token.name))
			if p1battlefield.size() > 6:
				kill(token)
		if player == 2:
			token.control = "p2"
			p2battlefield.append(str(token.name))
			if p2battlefield.size() > 6:
				kill(token)
	pass
	
func getCardStats():
	var battlefieldStats1 = []
	var battlefieldStats2 = []
	var handStats = []
	for i in p1hand:
		if get_node(NodePath(i)).cardType == "Agent" or get_node(NodePath(i)).cardType == "Immortalized Agent" or get_node(NodePath(i)).cardType == "Token":
			handStats.append([get_node(NodePath(i)).strength, get_node(NodePath(i)).durability, get_node(NodePath(i)).depleteEffects])
		else:
			handStats.append(null)
	for i in p1battlefield:
		if get_node(NodePath(i)).cardType == "Agent" or get_node(NodePath(i)).cardType == "Immortalized Agent" or get_node(NodePath(i)).cardType == "Token":
			battlefieldStats1.append([get_node(NodePath(i)).strength, get_node(NodePath(i)).durability, get_node(NodePath(i)).depleteEffects])
		else:
			battlefieldStats1.append(null)
	for i in p2battlefield:
		if get_node(NodePath(i)).cardType == "Agent" or get_node(NodePath(i)).cardType == "Immortalized Agent" or get_node(NodePath(i)).cardType == "Token":
			battlefieldStats2.append([get_node(NodePath(i)).strength, get_node(NodePath(i)).durability, get_node(NodePath(i)).depleteEffects])
		else:
			battlefieldStats2.append(null)
	rpc_id(player1id, "updateCards", battlefieldStats1, battlefieldStats2, handStats)
	handStats = []
	for i in p2hand:
		if get_node(NodePath(i)).cardType == "Agent" or get_node(NodePath(i)).cardType == "Immortalized Agent" or get_node(NodePath(i)).cardType == "Token":
			handStats.append([get_node(NodePath(i)).strength, get_node(NodePath(i)).durability, get_node(NodePath(i)).depleteEffects])
		else:
			handStats.append(null)
	rpc_id(player2id, "updateCards", battlefieldStats2, battlefieldStats1, handStats)
	
#(Agent name) Updates agents stats as well as checks if they have sustained lethal damage
func updateAgent(agent):
	var agentNode = get_node(NodePath(agent))
	if agentNode.control == "p1":
		agentNode.durability = agentNode.durability + agentNode.bonusDurability - agentNode.damage + p2bonusDurability + globalDurability
		agentNode.strength = agentNode.strength + agentNode.bonusStrength - agentNode.strengthRedux + p2bonusStength + globalStrength
	else:
		agentNode.durability = agentNode.durability + agentNode.bonusDurability - agentNode.damage + p2bonusDurability + globalDurability
		agentNode.strength = agentNode.strength + agentNode.bonusStrength - agentNode.strengthRedux+ p2bonusStength + globalStrength
	if agentNode.strength < 0:
		agentNode.strength = 0
	if agentNode.durability <= 0:
		kill(agent)
		

#Resets Energy draws cards and triggers on turn start effects
func turnStart():
	passed = false
	if p1energyGems < 10:
		p1energyGems += 1
	p1energy = p1energyGems
	if p2energyGems < 10:
		p2energyGems += 1
	p2energy = p2energyGems
	draw("p1", 1)
	draw("p2", 1)
	var effectChain = []
	for i in p1battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onTurnStart") >= 0:
			get_node(NodePath(i)).onAllyEnter()
			effectChain.append(get_node(NodePath(i)))
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onTurnStart") >= 0:
						effectChain.append(x)
	for i in p2battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onTurnStart") >= 0:
			get_node(NodePath(i)).onAllyEnter()
			effectChain.append(get_node(NodePath(i)))
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onTurnStart") >= 0:
						effectChain.append(x)
	effectChain.sort_custom(ageSort)
	for i in effectChain:
		i.onTurnStart()
	updatePlayers()

#Sets energy reserves, triggers end of turn effects, sets next turns starting player and attack token
func endOfTurn():
	p1energyReserve += p1energy
	if p1energyReserve > 3:
		p1energyReserve = 3
	p2energyReserve += p2energy
	if p2energyReserve > 3:
		p2energyReserve = 3
	var effectChain = []
	for i in p1battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onTurnEnd") >= 0:
			effectChain.append(get_node(NodePath(i)))
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onTurnEnd") >= 0:
						effectChain.append(x)
	for i in p2battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onTurnEnd") >= 0:
			effectChain.append(get_node(NodePath(i)))
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onTurnEnd") >= 0:
						effectChain.append(x)
	effectChain.sort_custom(ageSort)
	for i in effectChain:
		i.onTurnEnd()
	if startingPlayer == "p1":
		startingPlayer = "p2"
		activeplayer = "p2"
		p2attacktoken = true
		p1attacktoken = false
	else:
		startingPlayer = "p1"
		activeplayer = "p1"
		p1attacktoken = true
		p2attacktoken = false
	turnStart()
	
#A sorting method to sort effects by age
func ageSort(a, b):
	if a.age > b.age:
		return true
	return false

#(Player drawing, Int number of cards to draw) Draws cards
func draw(player, cards) :
	if player == "p1" :
		for i in range(1,cards + 1):
			p1hand.append(p1deck.pop_front())
	else:
		for i in range(1,cards + 1):
			p2hand.append(p2deck.pop_front())
		
#Passes priority and ends combat/turn, also resolves chain
func passPriority():
	if activeplayer == "p1":
		activeplayer = "p2"
	else:
		activeplayer = "p1"
	if passed == false and chain.size() == 0:
		passed = true
	else:
		if combat == true or chain.size() > 0:
			if chain.size() > 0:
				resolveChain()
			if combat:
				resolveAttack()
		else:
			endOfTurn()
			
#Checks both players life total
func lifeCheck():
	if(p1health <= 0 and p2health <= 0):
		endGame("draw")
	if(p1health <= 0):
		endGame("p1")
	if(p2health <= 0):
		endGame("p2")
	pass

#(Player to damage, Int amount of damage) Damages a player
func damage(player, damage):
	if player == "p1":
		p1health -= damage
		for y in p1battlefield:
			if get_node(NodePath(y)).triggerFlags.find("onSelfCoreDamage") >= 0:
				get_node(NodePath(y)).onSelfCoreDamage()
				if get_node(NodePath(y)).get_child_count() > 0:
					for x in get_node(NodePath(y)).get_children():
						if x.triggerFlags.find("onSelfCoreDamage") >= 0:
							x.onSelfCoreDamage()
	else:
		if player == "p2":
			p2health -= damage
			for y in p2battlefield:
				if get_node(NodePath(y)).triggerFlags.find("onSelfCoreDamage") >= 0:
					get_node(NodePath(y)).onSelfCoreDamage()
					if get_node(NodePath(y)).get_child_count() > 0:
						for x in get_node(NodePath(y)).get_children():
							if x.triggerFlags.find("onSelfCoreDamage") >= 0:
								x.onSelfCoreDamage()
	lifeCheck()
	pass
	
#(Player to gain attack token)Gives a player the attack token
func surge(player):
	if player == "p1":
		p1attacktoken = true
	else:
		p2attacktoken = true
		
#(Player who lost)Currently deletes game object
func endGame(losser):
	queue_free()
	pass
	
#(Name of target node)Flourishes a node
func flourish(nodeName):
	changeAgentStatsPerm(get_node(NodePath(nodeName)), 1, 1)
	pass

#(Int instances of sprout, Player sprouting)Sprouts X times for a player
func sprout(instances, player):
	for i in range(1,instances+1):
		if player == "p1":
			if p1battlefield.size() < 6:
				createToken(3.25, 1, false)
			else:
				changeAgentStatsPerm(get_node(NodePath(determineWeakest(3.25, true, "p1"))), 1, 1)
		else:
			if p2battlefield.size() < 6:
				createToken(3.25, 2, false)
			else:
				changeAgentStatsPerm(get_node(NodePath(determineWeakest(3.25, true, "p1"))), 1, 1)
	pass
	
#(CardId, boolean if we are searching for the weakest copy of a specific card or not, player whose battlefield is being searched)Determines weakestes agent
func determineWeakest(id, search, player):
	var weakest = []
	if player == "p1":
		weakest.append(get_node(NodePath(p1battlefield[0])))
		for i in p1battlefield:
			if (get_node(NodePath(i)).strength == weakest[0].strength and get_node(NodePath(i)).cardId == id and search == true) or (search == false and get_node(NodePath(i)).strength == weakest[0].strength):
				weakest.append(get_node(NodePath(i)))
			elif get_node(NodePath(i)).strength < weakest[0].strength:
				weakest.clear()
				weakest.append(get_node(NodePath(i)))
			if weakest.size > 1:
				if get_node(NodePath(i)).durability == weakest[0].durability:
					weakest.append(get_node(NodePath(i)))
				elif get_node(NodePath(i)).durability < weakest[0].durability:
					weakest.clear()
					weakest.append(get_node(NodePath(i)))
				if weakest.size > 1:
					if get_node(NodePath(i)).cost == weakest[0].cost:
						weakest.append(get_node(NodePath(i)))
					elif get_node(NodePath(i)).cost < weakest[0].cost:
						weakest.clear()
						weakest.append(get_node(NodePath(i)))
					if weakest.size > 1:
						if get_node(NodePath(i)).age > weakest[0].age:
							weakest.clear()
							weakest.append(get_node(NodePath(i)))
	else:
		for i in p2battlefield:
			if (get_node(NodePath(i)).strength == weakest[0].strength and get_node(NodePath(i)).cardId == id and search == true) or (search == false and get_node(NodePath(i)).strength == weakest[0].strength):
				weakest.append(get_node(NodePath(i)))
			elif get_node(NodePath(i)).strength < weakest[0].strength:
				weakest.clear()
				weakest.append(get_node(NodePath(i)))
			if weakest.size > 1:
				if get_node(NodePath(i)).durability == weakest[0].durability:
					weakest.append(get_node(NodePath(i)))
				elif get_node(NodePath(i)).durability < weakest[0].durability:
					weakest.clear()
					weakest.append(get_node(NodePath(i)))
				if weakest.size > 1:
					if get_node(NodePath(i)).cost == weakest[0].cost:
						weakest.append(get_node(NodePath(i)))
					elif get_node(NodePath(i)).cost < weakest[0].cost:
						weakest.clear()
						weakest.append(get_node(NodePath(i)))
					if weakest.size > 1:
						if get_node(NodePath(i)).age > weakest[0].age:
							weakest.clear()
							weakest.append(get_node(NodePath(i)))
	return weakest[0]
		
	
#(Agent target, Int damage amount)Deals X damage to an aganet
func damage_agent(agent, damage):
	get_node(NodePath(agent)).damage += damage
	if get_node(NodePath(agent)).triggerFlags.find("onSelfDamage") >= 0:
		get_node(NodePath(agent)).onSelfDamage()
		if get_node(NodePath(agent)).get_child_count() > 0:
			for x in get_node(NodePath(agent)).get_children():
				if x.triggerFlags.find("onSelfDamage") >= 0:
					x.onSelfDamage()
	if get_node(NodePath(agent)).durability > get_node(NodePath(agent)).damage:
		if get_node(NodePath(agent)).triggerFlags.find("onSurviveDamage") >= 0:
			get_node(NodePath(agent)).onSurviveDamage()
			if get_node(NodePath(agent)).get_child_count() > 0:
				for x in get_node(NodePath(agent)).get_children():
					if x.triggerFlags.find("onSurviveDamage") >= 0:
						x.onSurviveDamage()
		if get_node(NodePath(agent)).control == "p1":
			for i in p1battlefield:
				if get_node(NodePath(i)).triggerFlags.find("onAllySurviveDamage") >= 0 and i != agent:
					get_node(NodePath(agent)).onAllySurviveDamage()
					if get_node(NodePath(agent)).get_child_count() > 0:
						for x in get_node(NodePath(agent)).get_children():
							if x.triggerFlags.find("onAllySurviveDamag") >= 0:
								x.onAllySurviveDamag()
		else:
			for i in p2battlefield:
				if get_node(NodePath(i)).triggerFlags.find("onAllySurviveDamage") >= 0 and i != agent:
					get_node(NodePath(agent)).onAllySurviveDamage()
					if get_node(NodePath(agent)).get_child_count() > 0:
						for x in get_node(NodePath(agent)).get_children():
							if x.triggerFlags.find("onAllySurviveDamag") >= 0:
								x.onAllySurviveDamag()
	updateAgent(agent)
	pass
	
#(Agent name target, strength value, durability value)Permanently changes an agents stats the amount
func changeAgentStatsPerm(agent, strength, durability):
	get_node(NodePath(agent)).strength += strength
	get_node(NodePath(agent)).durability += durability
	if get_node(NodePath(agent)).triggerFlags.find("onStatChange") >= 0:
		get_node(NodePath(agent)).onStatChange()
		if get_node(NodePath(agent)).get_child_count() > 0:
			for x in get_node(NodePath(agent)).get_children():
				if x.triggerFlags.find("onStatChange") >= 0:
					x.onStatChange()
	pass

#(Agent name)Finds all agents with the same Id and immortalizes them
func immortalize(nodeName):
	if get_node(NodePath(nodeName)).control == "p1":
		for i in p1battlefield:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p1battlefield.find(i)
				var tags = p1battlefield.pop_at(index).split("_")
				p1battlefield.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p1hand:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p1hand.find(i)
				var tags = p1hand.pop_at(index).split("_")
				p1hand.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p1deck:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p1deck.find(i)
				var tags = p1deck.pop_at(index).split("_")
				p1deck.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p1graveyard:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p1graveyard.find(i)
				var tags = p1graveyard.pop_at(index).split("_")
				p1graveyard.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
	else:
		for i in p2battlefield:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p2battlefield.find(i)
				var tags = p2battlefield.pop_at(index).split("_")
				p2battlefield.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p2hand:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p2hand.find(i)
				var tags = p2hand.pop_at(index).split("_")
				p2hand.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p2deck:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p2deck.find(i)
				var tags = p2deck.pop_at(index).split("_")
				p2deck.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
		for i in p2graveyard:
			if get_node(NodePath(i)).cardId == get_node(NodePath(nodeName)).cardId:
				immortalizeCard(i)
				var index = p2graveyard.find(i)
				var tags = p2graveyard.pop_at(index).split("_")
				p2graveyard.insert(index, tags[0]+"a5_" + tags[1] + "_" + tags[2])
	
#(Agent name)Immortalizes a card
func immortalizeCard(nodeName):
	nodeName = NodePath(nodeName)
	var immortalized = Node.new()
	immortalized.set_script(load("res://Card Scripts/" + str(get_node(nodeName).cardId+0.5) + ".gd"))
	immortalized.damage = get_node(nodeName).damage
	immortalized.strengthRedux = get_node(nodeName).strengthRedux
	for i in get_node(nodeName).keywords:
		if immortalized.keywords.has(i) == false:
			immortalized.keywords.append(i)
	immortalized.bleed = get_node(nodeName).bleed
	var tags = get_node(nodeName).name.split("_")
	immortalized.name = nodeName + "a" + "5" + "_" + tags[1] + "_" + tags[2]
	self.add_child(immortalized)
	#get_node(nodeName).queue_free()
	pass 
	
func decAttack(agent, player):
	if !get_node(NodePath(agent)).depleted and !get_node(NodePath(agent)).depleteing:
		if player == "p1":
			attacking.append(p1battlefield.pop_at(p1battlefield.find(agent)))
		else:
			attacking.append(p2battlefield.pop_at(p2battlefield.find(agent)))
		pass
	
func remAttack(agent, player):
	if player == "p1":
		p1battlefield.append(attacking.pop_at(attacking.find(agent)))
	else:
		p2battlefield.append(attacking.pop_at(attacking.find(agent)))
	pass
	
func decBlock(agent, player, index):
	if !get_node(NodePath(agent)).depleted and !get_node(NodePath(agent)).depleteing:
		if player == "p1":
			p1battlefield.pop_at(p1battlefield.find(agent))
		else:
			p2battlefield.pop_at(p2battlefield.find(agent))
		for i in blocking:
			if i == "NONE":
				blocking[blocking.find(i)] = agent
				break
	pass
	
func remBlock(agent, player, index):
	if player == "p1":
		p1battlefield.append(agent)
		blocking[blocking.find(agent)] = "NONE"
	else:
		p2battlefield.append(agent)
		blocking[blocking.find(agent)] = "NONE"
	pass

#(Id of a timeline)Shifts to a timeline and triggers onShift triggers
func shift(timelineID):
	shiftYard.append(timeline)
	timeline = timelineID
	shifts += 1
	if timelineID == 7:
		damage("p1", 1)
		damage("p2", 1)
		timelineName = "Volcanic Rivers"
	for i in p1battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onShift") >= 0:
			get_node(NodePath(i)).onShift()
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onShift") >= 0:
						x.onShift()
	for i in p2battlefield:
		if get_node(NodePath(i)).triggerFlags.find("onShift") >= 0:
			get_node(NodePath(i)).onShift()
			if get_node(NodePath(i)).get_child_count() > 0:
				for x in get_node(NodePath(i)).get_children():
					if x.triggerFlags.find("onShift") >= 0:
						x.onShift()
	pass
