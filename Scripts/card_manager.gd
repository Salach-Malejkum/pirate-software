class_name CardManager
extends Control

const starting_deck = [
	Globals.card_types.WATER,
	Globals.card_types.FIRE
]

var preloaded_card = preload("res://Scenes/card.tscn")

@onready var deck : HBoxContainer = $FullScreen/Deck
@onready var card_add_timer : Timer = $AddCardTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	for card_type in starting_deck:
		add_card(card_type)


func add_card(card_type : Globals.card_types):
	if GameManager.current_hand_size < Globals.max_cards_at_hand:
		var card_instance = preloaded_card.instantiate()
		card_instance.set_card_type(card_type)
		deck.add_child(card_instance)
		
		GameManager.current_hand_size += 1
	else:
		#ToDO: throw info that it's max hand size
		pass
