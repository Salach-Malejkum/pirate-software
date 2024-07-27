extends Control

@export var level = preload("res://Scenes/tutorial_zone.tscn")
signal menu_ended

@onready var main_tab = $MainTab
@onready var option_tab = $Options

func _ready():
	AudioPlayer.play_timed_sfx("menu_music", menu_ended)


func _on_start_pressed():
	emit_signal("menu_ended")
	#GameManager.change_scene(level)
	get_tree().change_scene_to_packed(level)



func _on_quit_pressed():
	if OS.has_feature("JavaScript"):
		pass
	else:
		get_tree().quit()


func _on_back_pressed():
	option_tab.visible  = false
	main_tab.visible  = true


func _on_options_pressed():
	main_tab.visible  = false
	option_tab.visible  = true
