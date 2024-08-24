extends Node
var cardName = "Stength of the grove"
var cardId = 22
var syndacate = "Lifeblood"
var control = ""
var baseCost = 0
var cost = baseCost
var immortalizeCondition = 0
var immortalizeCounter = 0
var cardType = "Immeadiete"
var text = ""
var targets = 1
var targetType = ["Ally"]
var targetList = []
var targeteText = ["Choose an ally to give +1/+1 for each other ally in play."]
var unique = false


func effect():
	get_parent().sprout(1)
	if control == "p1":
		targetList[0].bonusStrength += get_parent().p1battlefield.size()
		targetList[0].bonusDurability += get_parent().p1battlefield.size()
	if control == "p2":
		targetList[0].bonusStrength += get_parent().p2battlefield.size()
		targetList[0].bonusDurability += get_parent().p2battlefield.size()


