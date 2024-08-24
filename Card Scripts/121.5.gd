extends Node
var cardName = "Master of Ceremonies"
var cardId = 121.5
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
var immortalizeCondition = 0
var immortalizeCounter = 0
var cardType = "Immortalized Agent"
var bleed = 0
var text = ""
var depleted = false
var triggerFlags = []
var keywords = []
var age = 0
var depleteable = true
var depleteEffects = []

func effect():
	if control == "p1":
		get_parent().damage("p1", 2)
		get_parent().lifeCheck()
		get_parent().damage("p2", 2)
	else:
		get_parent().damage("p2", 2)
		get_parent().lifeCheck()
		get_parent().damage("p1", 2)
	get_parent().lifeCheck()
	pass

