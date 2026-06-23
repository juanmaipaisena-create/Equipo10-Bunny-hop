class_name HUD
extends Control

@onready var wave_label = $VBoxContainer/WaveLabel
@onready var enemies_label = $VBoxContainer/EnemiesLabel
@onready var time_label = $VBoxContainer/TimeLabel
@onready var moneda_label = $VBoxContainer/MonedaLabel

func update_wave(value:int):
	if wave_label == null:
		return
	wave_label.text = "Wave: " + str(value)

func update_enemies(value:int):
	if enemies_label == null:
		return
	enemies_label.text = "Enemigos: " + str(value)

func update_time(value:float):
	if time_label == null:
		return
	time_label.text = "Tiempo: " + str(int(value))

func update_coins(value:int):
	if moneda_label == null:
		return
	moneda_label.text = "Monedas: " + str(value)
	
func _ready():
	PlayerStats.coins_changed.connect(update_coins)
	update_coins(PlayerStats.coins)
	#print(wave_label)
	#print(enemies_label)
	#print(time_label)
