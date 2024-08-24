extends Node
var cardName = "Bloodline Tracker"
var cardId = 121
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 1
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 1
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 1
var cost = baseCost
var immortalizeCondition = 6
var immortalizeCounter = 0
var cardType = "Agent"
var bleed = 0
var text = "Deplete: Sacrifice 1: (C) Deal 1 to the enemy Core. Immortalize: I've dealt 6+ damage"
var depleted = false
var triggerFlags = ["onStrike"]
var keywords = []
var age = 0
var depleteEffects = ["Sacrifice 1: (C)\nDeal 1 to the\nenemy Core."]
var unique = false
var depleteing = false
	
func onStrike():
	immortalizeCounter += strength
	if(immortalizeCounter >= 6):
		get_parent().immortalize()
	pass
	
func deplete():
	if !depleteing:
		depleteing = true
		get_parent().preChain.append(name)
		if control == "p1":
			get_parent().rpc_id(get_parent().player1id, "alliedPreChain", get_parent().preChain, false)
			get_parent().rpc_id(get_parent().player2id, "enemyPreChain", get_parent().preChain.size())
		else:
			get_parent().rpc_id(get_parent().player2id, "alliedPreChain", get_parent().preChain, false)
			get_parent().rpc_id(get_parent().player1id, "enemyPreChain", get_parent().preChain.size())
	

func effect():
	if control == "p1":
		get_parent().damage("p1", 1)
		get_parent().lifeCheck()
		get_parent().damage("p2", 1)
	else:
		get_parent().damage("p2", 1)
		get_parent().lifeCheck()
		get_parent().damage("p1", 1)
	get_parent().lifeCheck()
	immortalizeCounter += 2
	if(immortalizeCounter >= 6):
		get_parent().immortalize()
	pass
