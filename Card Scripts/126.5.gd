extends Node
var cardName = "Khaela the Hungry"
var cardId = 126.5
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 5
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 2
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Advent: (C) Deal 1 to me and another Agent. Sacrifice 2: Instead deal 2. Immortalize: Breakdown 15."
var depleted = false
var triggerFlags = ["onEnters"]
var keywords = []
var addCost = false
var targets = 1
var targetType = ["agent"]
var uniqueTargets = false
var age = 0
var depleteable = true
var depleteEffects = []

func deplete():
	if(get_parent().additionalCostQuery("Would you like to sacrifice 2?")):
		damage += 2
	else:
		damage += 1
	get_parent().chain.append(name)
	get_parent().chooseTarget()
	
func onEnter():
	if(get_parent().additionalCostQuery("Would you like to sacrifice 2?")):
		damage += 2
	else:
		damage += 1
	get_parent().chain.append(name)
	get_parent().chooseTarget()
	
func effect(target):
	if addCost:
		get_parent().damageAgent(target, 2)
	else:
		get_parent().damageAgent(target, 1)
	pass




