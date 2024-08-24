extends Node
var cardName = "Magnus Lavaborn"
var cardId = 122.5
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 3
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 1
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 1
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Advent: Shift to Volcanic Rivers twice. Strike: Deal 1 to the enemy Core."
var depleted = false
var triggerFlags = ["onStrike", "onEnter"]
var keywords = []
var age = 0
var depleteable = false
var depleteEffects = []

func onStrike():
	if control == "p1":
		get_parent().damage("p2", 1)
	if control == "p2":
		get_parent().damage("p1", 1)
	pass
	
func onEnter():
	get_parent().shift(7)
	get_parent().shift(7)
	pass



