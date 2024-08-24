extends Node
var cardName = "Blazing Shifter"
var cardId = 130
var syndacate = "Splintergleam"
var control = ""
var baseStrength = 2
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 2
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 4
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: Shift to Volcanic Rivers. I have +1/+1 for each Timeline in the Timeline Stack. Immortalize: I have 7+ Strength."
var depleted = false
var triggerFlags = ["onEnter", "onShift", "onStatChange"]
var keywords = []
var age = 0
var depleteEffects = []

func onEnter():
	strength += get_parent().shifts
	durability += get_parent().shifts
	get_parent().shift(7)
	pass
	
func onShift():
	strength += 1
	durability += 1
	onStatChange()
	pass
	
func onStatChange():
	if strength >= 7:
		get_parent().immortalize(name)
	pass



