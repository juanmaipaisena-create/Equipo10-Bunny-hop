extends Node

#variables de mejoras
signal stats_updated

enum upgrades {ADD_VELOCIDAD_ATAQUE, ADD_VELOCIDAD}

#mejoras
var attackSpeedMulti = 0
var velocityMulti = 0

func add_upgrade(upgrade, stats):
	if upgrade == upgrades.ADD_VELOCIDAD_ATAQUE:
		attackSpeedMulti += stats 
	elif upgrade == upgrades.ADD_VELOCIDAD:
		velocityMulti += stats 
