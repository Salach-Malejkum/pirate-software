extends Node2D

var menu_size = Vector2(1280, 720)
var level_size = Vector2(320, 180)


func set_menu_size():
	get_tree().root.content_scale_size = menu_size
	get_window().size = menu_size
	

func set_level_size():
	get_tree().root.content_scale_size = level_size
	get_window().size = menu_size
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
