extends Node
var cardName = "Overseer of Trials"
var cardId = 128.5
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 3
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 5
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 3
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Confront. Whenever another ally survives damage, it and I Flourish"
var depleted = false
var triggerFlags = ["onAnotherAllySurviveDamage"]
var keywords = ["Confront"]
var age = 0
var depleteEffects = []

func onAnotherAllySurviveDamage(ally):
	get_parent().flourish(ally.name)
	get_parent().flourish(name)
	pass



