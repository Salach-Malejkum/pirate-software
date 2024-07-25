extends Control

@export var level1 = preload("res://Scenes/tutorial_zone.tscn")
signal menu_ended


func _ready():
	AudioPlayer.play_timed_sfx("menu_music", menu_ended)


func _on_start_pressed():
	emit_signal("menu_ended")
	get_tree().change_scene_to_packed(level1)



func _on_quit_pressed():
	if OS.has_feature("JavaScript"):
		pass
	else:
		get_tree().quit()
