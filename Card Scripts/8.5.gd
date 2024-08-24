extends Node
var cardName = "Dominance of Unity"
var cardId = 8.5
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
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Overpower, When another ally enters play I Flourish"
var depleted = false
var triggerFlags = ["onAllyEnter"]
var keywords = ["overpower"]
var age = 0
var depleteable = false
var depleteEffects = []

func onAllyEnter():
	get_parent().flourish(name)
	pass




