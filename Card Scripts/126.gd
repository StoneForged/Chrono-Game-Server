extends Node
var cardName = "Nascent Painforger"
var cardId = 126
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 3
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 2
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: (C) Deal 1 to me and another Agent. Sacrifice 2: Instead deal 2. Immortalize: Breakdown 15."
var depleted = false
var deplete = true
var triggerFlags = ["onSelfCoreDamge", "onEnters"]
var keywords = []
var addCost = false
var targets = 1
var targetType = ["agent"]
var age = 0
var unique = false

	
func onEnter():
	if(get_parent().additionalCostQuery("Would you like to sacrifice 2?")):
		damage += 2
	else:
		damage += 1
	get_parent().chain.append(name)
	
func effect(target):
	if addCost:
		get_parent().damageAgent(target, 2)
	else:
		get_parent().damageAgent(target, 1)
	pass
	
func onSelfCoreDamage():
	if control == "p1":
		if get_parent().p1health <= 15:
			get_parent().immortalize(name)
	if control == "p2":
		if get_parent().p2health <= 15:
			get_parent().immortalize(name)
	




