extends Node
var cardName = "Spark of Bounty"
var cardId = 14
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 4
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 4
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 5
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: Shift to Abundant Growth. Immortalize: Round End: You have 15+ Strength in play."
var depleted = false
var triggerFlags = ["onEnter", "onEndOfTurn"]
var keywords = []
var age = 0
var depleteable = false
var depleteEffects = []

func onEnter():
	get_parent().shift(1)
	pass
	
func onEndOfTurn():
	if control == "p1":
		if get_parent().p1Stregnth >= 15:
			get_parent().immortalize()
	if control == "p2":
		if get_parent().p2Stregnth >= 15:
			get_parent().immortalize()

