class_name CardManager
extends Control

const starting_deck = [
	Globals.card_types.WATER,
	Globals.card_types.FIRE,
	Globals.card_types.CANDLE,
	Globals.card_types.ELECTRICITY
]

var preloaded_card = preload("res://Scenes/card.tscn")

@onready var deck : HBoxContainer = $CanvasLayer/FullScreen/Deck
@onready var card_add_timer : Timer = $AddCardTimer
@onready var max_deck_warning : Label = $CanvasLayer/FullScreen/Label
@onready var warning_timer : Timer = $WarningTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	for card_type in starting_deck:
		add_card(card_type)
	
	GameManager.reshuffle_deck.connect(_reshuffle_deck)
	GameManager.card_merged.connect(_merge_card)


func _reshuffle_deck():
	for idx in range(GameManager.current_hand.size()):
		GameManager.current_hand[idx].refresh_lerp_idx(idx)


func _merge_card(merged_card_type : Globals.card_types):
	add_card(merged_card_type)


func add_card(card_type : Globals.card_types):
	if GameManager.current_hand.size() < Globals.max_cards_at_hand:
		var card_instance = preloaded_card.instantiate()
		card_instance.set_card_type(card_type)
		card_instance.index_at_hand = GameManager.current_hand.size()
		deck.add_child(card_instance)
		
		GameManager.current_hand.append(card_instance)
	else:
		max_deck_warning.visible = true
		warning_timer.start(2.0)


func _on_warning_timer_timeout():
	max_deck_warning.visible = false
