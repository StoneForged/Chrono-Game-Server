extends Node
var cardName = "Opener of the Way"
var cardId = 133.5
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 5
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 6
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 5
var cost = baseCost
var cardType = "Immortalized Agent"
var bleed = 0
var text = "Advent: Shift to Torment."
var depleted = false
var triggerFlags = ["onEnter"]
var keywords = []
var age = 0
var depleteEffects = []

func onEnter():
	get_parent().shift(3)



