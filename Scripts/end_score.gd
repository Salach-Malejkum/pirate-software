extends Control

@export var restart_scene = preload("res://Scenes/tutorial_zone.tscn")

var _merged_score_txt = "Cards merged: %d"
var _new_card_score_txt = "New cards acquired: %d"
var _kills_score_txt = "Enemies killed: %d"
var _card_use_score_txt = "Cards used: %d"
var _total_score_txt = "Total: %d"

var _merged_score = 0
var _random_card_score = 0
var _kills_score = 0
var _card_used_score = 0
var _total_score = 0

@onready var merge_score_node = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/MergeScore
@onready var random_card_node = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/NewCardScore
@onready var kills_score_node = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/EnemiesKilledScore
@onready var card_used_node = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/CardsUsedScore
@onready var total_score_node = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/TotalScore

# Called when the node enters the scene tree for the first time.
func _ready():
	_merged_score = GameManager.merged_total_count * 100
	_random_card_score = GameManager.total_new_cards * 50
	_kills_score = GameManager.total_kills * 200
	_card_used_score = GameManager.cards_used * 50
	_total_score = _merged_score + _random_card_score + _kills_score + _card_used_score
	
	merge_score_node.text = _merged_score_txt % _merged_score
	random_card_node.text = _new_card_score_txt % _random_card_score
	kills_score_node.text = _kills_score_txt % _kills_score
	card_used_node.text = _card_use_score_txt % _card_used_score
	total_score_node.text = _total_score_txt % _total_score


func _on_restart_pressed():
	get_tree().change_scene_to_packed(restart_scene)
