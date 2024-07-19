class_name CardManager
extends Control

const starting_deck = [
	Globals.card_types.WATER,
	Globals.card_types.FIRE
]

var preloaded_card = preload("res://Scenes/card.tscn")

@onready var deck : HBoxContainer = $FullScreen/Deck

# Called when the node enters the scene tree for the first time.
func _ready():
	for card_type in starting_deck:
		var card_instance = preloaded_card.instantiate()
		card_instance.set_card_type(card_type)
		deck.add_child(card_instance)


func add_card(card_type : Globals.card_types):
	var card_instance = preloaded_card.instantiate()
	card_instance.set_card_type(card_type)
	deck.add_child(card_instance)
