extends CanvasLayer
#class_name HUD
#extends Control
#
#@onready var wave_label = $WaveLabel
#@onready var enemies_label = $EnemiesLabel
#@onready var time_label = $TimeLabel
#@onready var health_bar = $HealthBar
#
#func update_wave(value:int):
	#wave_label.text = "Wave: " + str(value)
#
#func update_enemies(value:int):
	#enemies_label.text = "Enemigos: " + str(value)
#
#func update_time(value:float):
	#time_label.text = "Tiempo: " + str(int(value))
#
#func update_health(value:int):
	#health_bar.value = value
