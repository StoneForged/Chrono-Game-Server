extends Node
var cardName = "The Beating Heart"
var cardId = 14.5
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 5
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 5
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 5
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Advent: Shift to Abundant Growth. Round End: Allies Flourish."
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
		for i in get_parent().p1battlefield:
			get_parent().flourish(i)
	if control == "p2":
		for i in get_parent().p1battlefield:
			get_parent().flourish(i)
