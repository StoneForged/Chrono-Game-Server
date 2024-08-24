extends Node
var cardName = "Sanguine Resurgence"
var cardId = 149
var syndacate = "Splintergleam"
var control = ""
var baseCost = 5
var cost = baseCost
var cardType = "Slow"
var text = "Surge, Breakdown 10: Allies Flourish, Breakdown 5: All Damaged Allies Flourish"
var targets = 0
var unique = false

func effect():
	if control == "p1":
		get_parent().surge("p1")
		if get_parent().p1health <= 10:
			for i in get_parent().p1battlefield:
				get_parent().flourish(i)
		if get_parent().p1health <= 5:
			for i in get_parent().p1battlefield:
				if i.damage > 0:
					get_parent().flourish(i)
	if control == "p2":
		get_parent().surge("p2")
		if get_parent().p2health <= 10:
			for i in get_parent().p2battlefield:
				get_parent().flourish(i)
		if get_parent().p2health <= 5:
			for i in get_parent().p2battlefield:
				if i.damage > 0:
					get_parent().flourish(i)
	pass




