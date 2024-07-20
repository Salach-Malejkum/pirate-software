extends Node2D

var menu_size = Vector2(1280, 720)
var level_size = Vector2(320, 180)

var selected_card : Card = null
@export var current_hand_size : int = 0


func set_menu_size():
	get_tree().root.content_scale_size = menu_size
	get_window().size = menu_size
	

func set_level_size():
	get_tree().root.content_scale_size = level_size
	get_window().size = menu_size
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT


func select_card(new_card : Card):
	if selected_card != null:
		selected_card.deselect_self()
	
	selected_card = new_card
	selected_card.is_selected = true
