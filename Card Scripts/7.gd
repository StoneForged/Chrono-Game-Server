extends Node
var cardName = "Territorial Pack"
var cardId = 7
var syndacate = "Lifeblood"
var control = ""
var baseStrength = 1
var strength = baseStrength
var bonusStrength = 0
var baseDurability = 1
var durability = baseDurability
var bonusDurability = 0
var damage = 0
var strengthRedux = 0
var baseCost = 2
var cost = baseCost
var cardType = "Agent"
var bleed = 0
var text = "Advent: Summon a Wolf. Immortalize: Round End: I do not see an allied Wolf in Play."
var depleted = false
var triggerFlags = ["onEnter", "onTurnEnd"]
var keywords = []
var wolf = true
var age = 0
var depleteable = false
var depleteEffects = []

func onEnter():
	if control == "p1":
		get_parent().createToken(7, 1, false)
	else:
		get_parent().createToken(7, 2, false)
	pass
	
func onTurnEnd():
	wolf = false
	if control == "p1":
		for i in get_parent().p1battlefield:
			if get_parent().get_node(NodePath(i)).cardId == 7.25:
				wolf = true
		if wolf == false:
			get_parent().immortalize(name)
	else:
		for i in get_parent().p2battlefield:
			if get_parent().get_node(NodePath(i)).cardId == 7.25:
				wolf = true
		if wolf == false:
			get_parent().immortalize(name)



