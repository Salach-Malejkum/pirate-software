extends Control

@export var level1 = preload("res://Scenes/level1.tscn")

func _ready():
	GameManager.set_menu_size()

func _on_start_pressed():
	get_tree().change_scene_to_packed(level1)



func _on_quit_pressed():
	if OS.has_feature("JavaScript"):
		pass
	else:
		get_tree().quit()
