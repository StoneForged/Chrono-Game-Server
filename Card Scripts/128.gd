extends Node
var cardName = "Bright-Eyed Supplicant"
var cardId = 128
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 4
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 3
var cost = baseCost
var immortalizeCondition = 2
var immortalizeCounter = 0
var cardType = "Agent"
var bleed = 0
var text = "Confront. Immortalize: I've survived damage twice."
var depleted = false
var triggerFlags = ["onSurviveDamage"]
var keywords = ["Confront"]
var age = 0
var depleteEffects = []

func onSurviveDamage():
	immortalizeCounter += 1
	immortalizeCounter >= immortalizeCondition
	get_parent().immortalize(name)
	pass



