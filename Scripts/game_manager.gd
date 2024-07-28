extends Node2D

var menu_size = Vector2(1280, 720)
var level_size = Vector2(320, 180)

var player = null
var selected_card : Card = null
var tutorial_select_blocked : bool = true
var tutorial_select_progress : bool = false
@export var merged_blocked = true
@export var merged_total_count = 0
@export var total_new_cards = 0
@export var total_kills = 0
@export var cards_used = 0
@export var boss_kills = 0
@export var current_hand : Array[Card] = []

# card used jak jest rownoczesnie callowany to lapie tez obecnie usuwana karte
# i sie jebie deck, dodatkowy sygnal po usunieciu karty naprawia problem
signal card_used
signal reshuffle_deck
signal card_merged(merged_card_type : Globals.card_types)
signal random_card_chosen(card_type : Globals.card_types)

# tutorial signals
signal tutorial_furnace
signal tutorial_select
signal tutorial_lantern
signal tutorial_engine
signal tutorial_cabin
signal tutorial_spawner
signal tutorial_random_card
signal tutorial_merge
signal tutorial_progress
signal assign_player(player)

@export var tutorial_texts : Dictionary = {
	"Hello, operator. Today we are going to show you how to control your lightbringer." : null,
	"If you wish to skip the training, you can exit through the door by pressing E or F." : null,
	"First, move your lightbringer using W A S D keys." : null,
	"Now, as you can see on the bottom of your screen, we have assigned you the standard operator deck." : null,
	"You will start with this deck on every attempt to get rid of the blessed ones." : null,
	"To select a card, press left mouse button while hovering it.": tutorial_select,
	"You can also unselect card by clicking on it again, or select different card by clicking on a different card.": null,
	"Why don't you try out one of the cards? Select FIRE or WATER card and click on the furnace." : tutorial_furnace,
	"Nice. This is not the only usage of your cards. You can try the ELECTRICITY card on the lamp on the wall." : tutorial_lantern,
	"Good. Now, about merging. You can merge FIRE and WATER to get STEAM or CANDLE and FIRE to get a CANDLE LIT." : null,
	"Select one card and then click on another card to try and merge them. Create STEAM and CANDLE LIT cards." : tutorial_merge,
	"Merging and using cards will restore your lightbringer health. You will die if the enemy catches you while your light is out." : null,
	"The CANDLE can be placed on a cabin. If you combined with FIRE, it will be lit already. Try it out!" : tutorial_cabin,
	"The STEAM card can be used on steam engine to light all the lamps at once." : tutorial_engine,
	"Now, you can choose a random card for your deck. The random cards will appear after 15 seconds have passed." : tutorial_random_card,
	"Your max deck size is 5 - if you reach maximum number of cards, you won't be able to chose a new one." : null,
	"Alright, now to the real deal - as we are in a controlled environment, we have prepared a blessed spawner." : null,
	"There should be an enemy coming at you. Don't worry, these things die pretty easily." : null,
	"Every light source will kill the enemy." : null,
	"Kill 2 enemies." : tutorial_spawner,
	"Please remember that there are more cards you can obtain, but these are not cover under basic operation manual." : null,
	"I can tell you only that some of those cards will help you with destroying spawners or other enemies." : null,
	"Now that we have explained the basics of hunting the blessed ones, you can proceed out of the controlled zone." : null,
	"It will be way darker out there, so watch out and good luck, operator." : null,
	"Please exit the through the door by pressing E or F." : null
}


func _ready():
	tutorial_merge.connect(_tutorial_unblock_merge)
	tutorial_select.connect(_tutorial_select_card)
	card_used.connect(_add_card_use_point)
	assign_player.connect(_assign_player)


func _tutorial_unblock_merge():
	merged_blocked = false


func _tutorial_select_card():
	tutorial_select_blocked = false


func _add_card_use_point():
	cards_used += 1
	

func _assign_player(new_player):
	if player == null:
		player = new_player


func set_menu_size():
	get_tree().root.content_scale_size = menu_size
	get_window().size = menu_size
	

func set_level_size():
	get_tree().root.content_scale_size = level_size
	get_window().size = menu_size
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT


func select_card(new_card : Card):
	if tutorial_select_blocked:
		return
	if not tutorial_select_progress:
		tutorial_select_progress = true
		tutorial_progress.emit()
	if selected_card != null:
		if not try_merge_cards(new_card):
			for card in current_hand:
				card.deselect_self()
	
	selected_card = new_card
	selected_card.select_connect_signal()
	AudioPlayer.play_sfx("card_selected")
	selected_card.material.set_shader_parameter("active", true)
	selected_card.is_selected = true

# O(N) worst case
func try_merge_cards(card_to_merge : Card):
	if merged_blocked:
		return false
	
	var merge_key_try_1 = "%s+%s" % [
		Globals.card_types.keys()[selected_card.card_type],
		Globals.card_types.keys()[card_to_merge.card_type]
	]
	var merge_key_try_2 = "%s+%s" % [
		Globals.card_types.keys()[card_to_merge.card_type],
		Globals.card_types.keys()[selected_card.card_type]
	]
	
	if merge_key_try_1 in Globals.card_merge_results.keys():
		card_to_merge.select_connect_signal()
		_merge_cards(merge_key_try_1)
		return true
	elif merge_key_try_2 in Globals.card_merge_results.keys():
		card_to_merge.select_connect_signal()
		_merge_cards(merge_key_try_2)
		return true
	return false


func _merge_cards(merge_key : String):
	card_used.emit()
	card_merged.emit(Globals.card_merge_results[merge_key])
	merged_total_count += 1
	if merged_total_count == 2:
		tutorial_progress.emit()


func change_scene(scene_to_load):
	AudioPlayer.change_scene()
	player.get_parent().remove_child(player)
	get_tree().change_scene_to_packed(scene_to_load)
