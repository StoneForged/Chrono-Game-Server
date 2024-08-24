extends Node
var cardName = "Bronk the Calm"
var cardId = 9.5
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 3
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 4
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 3
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Advent: Summon a Wolf and Shift to Abundant Growth."
var depleted = false
var triggerFlags = ["onEnter"]
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
	get_parent().shift(1)



