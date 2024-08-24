extends Node
var cardName = "Denizen of Flames"
var cardId = 122
var syndacate = "Spintergleam"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 1
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 1
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: Shift to Volcanic Rivers. Immortalize: I've seen you Shift to Volcanic Rivers while Volcanic Rivers is the current Timeline."
var depleted = false
var triggerFlags = ["onEnter", "onShift"]
var keywords = []
var age = 0
var depleteable = false
var depleteEffects = []

func onEnter():
	get_parent().shift(7)
	pass
	
func onShift():
	if get_parent().shiftYard.last() == get_parent().timeline and get_parent().timeline == 3:
		get_parent().immortalize()



