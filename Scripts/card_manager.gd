class_name CardManager
extends Control

const starting_deck = [
	Globals.card_types.WATER,
	Globals.card_types.FIRE,
	Globals.card_types.CANDLE,
	Globals.card_types.ELECTRICITY
]

const tutorial_merge_deck = [
	Globals.card_types.WATER,
	Globals.card_types.FIRE,
	Globals.card_types.CANDLE,
	Globals.card_types.FIRE
]

var preloaded_card = preload("res://Scenes/card.tscn")

@onready var deck : HBoxContainer = $CanvasLayer/FullScreen/Deck
@onready var random_deck_parent = $CanvasLayer/FullScreen/PullDeckMarginBase
@onready var randomized_deck : HBoxContainer = $CanvasLayer/FullScreen/PullDeckMarginBase/DeckMargin/ChooseCard
@onready var card_add_timer : Timer = $NextCardPull
@onready var max_deck_warning : Label = $CanvasLayer/FullScreen/InfoLabel
@onready var warning_timer : Timer = $WarningTimer
@onready var score_label : Label = $CanvasLayer/FullScreen/MarginContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	swap_deck(starting_deck)
	GameManager.reshuffle_deck.connect(_reshuffle_deck)
	GameManager.card_merged.connect(_merge_card)
	GameManager.random_card_chosen.connect(_add_chosen_card)
	GameManager.tutorial_random_card.connect(_start_random_card)
	GameManager.tutorial_merge.connect(_merge_deck_swap)
	if not get_parent().is_tutorial:
		score_label.visible = true
		card_add_timer.start(Globals.random_card_pull_time)

var total_score

func _process(delta):
	total_score = GameManager.merged_total_count * 100 + GameManager.total_new_cards * 50 + GameManager.total_kills * 200 + GameManager.cards_used * 50
	score_label.text = "Total score: %d" % total_score


func swap_deck(new_deck : Array):
	GameManager.current_hand = []
	for child in deck.get_children():
		child.queue_free()
	for card_type in new_deck:
		add_card(card_type)


func _start_random_card():
	card_add_timer.start(3.0)


func _merge_deck_swap():
	swap_deck(tutorial_merge_deck)


func _reshuffle_deck():
	for idx in range(GameManager.current_hand.size()):
		GameManager.current_hand[idx].refresh_lerp_idx(idx)


func _merge_card(merged_card_type : Globals.card_types):
	AudioPlayer.play_sfx("card_merge")
	add_card(merged_card_type)


func _add_chosen_card(chosen_card : Globals.card_types):
	random_deck_parent.visible = false
	for child in randomized_deck.get_children():
		child.queue_free()
	add_card(chosen_card)
	card_add_timer.start(Globals.random_card_pull_time)
	AudioPlayer.play_sfx("card_draw")
	GameManager.total_new_cards += 1
	if GameManager.total_new_cards == 1:
		GameManager.tutorial_progress.emit()


func _randomize_card_selection():
	var random_idx = []
	for i in range(Globals.card_types.size()):
		random_idx.append(i)
	random_idx.shuffle()
	
	for idx in random_idx.slice(0, 3):
		var card_instance = preloaded_card.instantiate()
		card_instance.set_card_type(idx)
		card_instance.index_at_hand = GameManager.current_hand.size()
		card_instance.is_random = true
		randomized_deck.add_child(card_instance)


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


func _on_next_card_pull_timeout():
	if GameManager.current_hand.size() < Globals.max_cards_at_hand:
		random_deck_parent.visible = true
		_randomize_card_selection()
	else:
		max_deck_warning.visible = true
		card_add_timer.start(Globals.random_card_pull_time)
		warning_timer.start(2.0)
