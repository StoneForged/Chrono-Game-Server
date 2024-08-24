extends Node
var cardName = "Go for the heart"
var cardId = 147
var syndacate = "Splintergleam"
var control = ""
var baseCost = 5
var cost = baseCost
var cardType = "Slow"
var text = "Deal 3 to the enemy core, Breakdown 10: Deal 4 instead, Breakdown 1: Deal 5 instead"
var targets = 0
var unique = false

func effect():
	var damage = 3
	if control == "p1":
		if get_parent().p1health <= 10:
			damage += 1
		if get_parent().p1health <= 1:
			damage += 1
		get_parent().damage("p2", damage)
	if control == "p2":
		if get_parent().p2health <= 10:
			damage += 1
		if get_parent().p2health <= 1:
			damage += 1
		get_parent().damage("p1", damage)


