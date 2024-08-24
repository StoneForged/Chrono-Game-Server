extends Node
var cardName = "Panicked Refugee"
var cardId = 9
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 2
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 3
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: Summon a Wolf. Immortalize: Round End: I do not see an allied Wolf in play. When I Immortalize, Shift to Abundant Growth."
var depleted = false
var triggerFlags = ["onEnter", "onEndOfTurn"]
var keywords = []
var wolf = true
var age = 0
var depleteable = false
var depleteEffects = []

func onEnter():
	if control == "p1":
		get_parent().createToken(7.25, 1, false)
	else:
		get_parent().createToken(7.25, 2, false)
	
func onEndOfTurn():
	wolf = false
	if control == "p1":
		for i in get_parent().p1battlefield:
			if i.cardId == 7.25:
				wolf = true
		if wolf == false:
			get_parent().shift(1)
			get_parent().immortalize()
	else:
		for i in get_parent().p2battlefield:
			if i.cardId == 7.25:
				wolf = true
		if wolf == false:
			get_parent().shift(1)
			get_parent().immortalize()



