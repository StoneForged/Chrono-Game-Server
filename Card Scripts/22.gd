extends Node
var cardName = "Convergent Pack"
var cardId = 22
var syndacate = "Lifeblood"
var control = ""
var baseCost = 4
var cost = baseCost
var cardType = "Slow"
var text = "Shift to Abundant Growth. For every two Timelines in the Timeline Stack summon an attacking Wolf Confronting the weakest unconfronted enemy."
var targets = 0
var depleteable = false
var unique = false

func effect():
	get_parent().error = "Spell Resolved!"
	pass



