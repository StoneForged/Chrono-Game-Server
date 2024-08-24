extends Node
var cardName = "Devoted Bloodletter"
var cardId = 133
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 4
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 5
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 5
var cost = baseCost
var immortalizeCondition = 3
var immortalizeCounter = 0
var cardType = "Agent"
var bleed = 0
var text = "Whenever I take damage, Draw 1. Immortalize: I've Drawn 3+ cards. When I Immortalize, Shift to Torment."
var depleted = false
var triggerFlags = ["OnSelfDamage"]
var keywords = []
var age = 0
var depleteEffects = []

func onSelfDamage():
	get_parent().draw(control, 1)
	immortalizeCounter += 1
	if immortalizeCounter == immortalizeCondition and (durability - damage > 0):
		get_parent().shift(3)
		get_parent().immortalize(name)



