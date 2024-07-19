extends Control

@export var level1 = preload("res://Scenes/level1.tscn")

func _ready():
	GameManager.set_menu_size()

func _on_start_pressed():
	get_tree().change_scene_to_packed(level1)
