extends Node
var cardName = "Welcoming Glade"
var cardId = 8
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 0
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 1
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 2
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "When another ally enters play I Flourish, Immortalize: I have 6+ power"
var depleted = false
var triggerFlags = ["onAllyEnter", "onStatChange"]
var keywords = []
var age = 0
var depleteable = false
var depleteEffects = []

func onAllyEnter():
	get_parent().flourish(name)
	pass
	
func onStatChange():
	if strength >= 6:
		get_parent().immortalize(name)
	pass




