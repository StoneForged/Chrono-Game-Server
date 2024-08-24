extends Node
var cardName = "Channel Vigor"
var cardId = 141
var syndacate = "Splintergleam"
var control = ""
var baseCost = 2
var cost = baseCost
var cardType = "Immediate"
var text = "Deal 1 to an ally to grant another ally +3/+1"
var targets = 2
var targetType = ["Ally", "Ally"]
var uniqueTargets = true
var targetList = []
var targetText = ["Deal 1 to an ally.", "Grant another ally +3/+1"]
var unique = false

func effect():
	get_parent().damageAgent(targetList[0], 1)
	get_parent().changeStatsPerm(targetList[1], 3, 1)
	pass




