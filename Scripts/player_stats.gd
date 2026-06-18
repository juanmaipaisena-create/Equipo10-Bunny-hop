extends Node

enum upgrades {
	SPEED,
	ATTACK_SPEED,
	DAMAGE,
	MAX_HP,
	CRIT_CHANCE,
	PROJECTILE_SPEED
}

#diccionario de nombres
const UPGRADE_NAMES = {
	upgrades.SPEED: "Velocidad",
	upgrades.ATTACK_SPEED: "Velocidad de ataque",
	upgrades.DAMAGE: "Danio",
	upgrades.MAX_HP: "Vida maxima",
	upgrades.CRIT_CHANCE: "Critico",
	upgrades.PROJECTILE_SPEED: "Velocidad de bala"
}

# Guardamos el historial de mejoras por si lo necesitás para otra cosa
var total_speed_upgrades: float = 0.0
var total_attack_speed_upgrades: float = 0.0

func add_upgrade(upgrade_type, stats, player):
	if upgrade_type == upgrades.SPEED:
		total_speed_upgrades += stats
		
		#Si el jugador está vivo en la escena, le subimos su velocidad local
		if player != null:
			player.speed += stats
			print("Velocidad del personaje aumentada a: ", player.speed)
		
	elif upgrade_type == upgrades.ATTACK_SPEED:
		total_attack_speed_upgrades += stats
		
		# Si el jugador está vivo, le bajamos el cooldown local para que dispare más rápido
		if player != null:
			# Ejemplo: si el texto dice "+10%", 'stats' es 10. Le restamos 0.05 segundos.
			player.shoot_cooldown = max(0.05, player.shoot_cooldown - 0.1)
			print("Cooldown de disparo del personaje reducido a: ", player.shoot_cooldown)
