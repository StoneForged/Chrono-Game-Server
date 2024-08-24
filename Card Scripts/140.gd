extends Node
var cardName = "Bathe in Flames"
var cardId = 140
var syndacate = "Splintergleam"
var control = ""
var baseCost = 2
var cost = baseCost
var cardType = "Fast"
var text = "Deal 2 damage to an ally to deal 2 to an Agent. Shift to Volcanic Rivers"
var targets = 2
var targetType = ["Ally", "Enemy"]
var targetList = []
var targetText = ["Deal 2 damage to an ally.", "Deal 2 damage to an agent."]
var unique = false

func effect():
	get_parent().error = "Bathe in Flames resolving"
	get_parent().damage_agent(targetList[0], 2)
	get_parent().damage_agent(targetList[1], 2)
	get_parent().shift(7)
	get_parent().error = "Bathe in Flames resolved"
	pass




