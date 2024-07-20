extends Node2D

var menu_size = Vector2(1280, 720)
var level_size = Vector2(320, 180)

var selected_card : Card = null
@export var current_hand : Array[Card] = []

# card used jak jest rownoczesnie callowany to lapie tez obecnie usuwana karte
# i sie jebie deck, dodatkowy sygnal po usunieciu karty naprawia problem
signal card_used
signal reshuffle_deck
signal card_merged(merged_card_type : Globals.card_types)

func set_menu_size():
	get_tree().root.content_scale_size = menu_size
	get_window().size = menu_size
	

func set_level_size():
	get_tree().root.content_scale_size = level_size
	get_window().size = menu_size
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT


func select_card(new_card : Card):
	if selected_card != null:
		if not try_merge_cards(new_card):
			selected_card.deselect_self()
	
	selected_card = new_card
	selected_card.is_selected = true

# O(N) worst case
func try_merge_cards(card_to_merge : Card):
	var merge_key_try_1 = "%s+%s" % [
		Globals.card_types.keys()[selected_card.card_type],
		Globals.card_types.keys()[card_to_merge.card_type]
	]
	var merge_key_try_2 = "%s+%s" % [
		Globals.card_types.keys()[card_to_merge.card_type],
		Globals.card_types.keys()[selected_card.card_type]
	]
	
	if merge_key_try_1 in Globals.card_merge_results.keys():
		card_used.emit()
		card_merged.emit(Globals.card_merge_results[merge_key_try_1])
		return true
	elif merge_key_try_2 in Globals.card_merge_results.keys():
		card_used.emit()
		card_merged.emit(Globals.card_merge_results[merge_key_try_2])
		return true
	return false
