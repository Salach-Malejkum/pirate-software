class_name Cabin

extends Node2D

var is_mouse_hovering : bool = false

var packed_candle = preload("res://Scenes/candle.tscn")
@export var is_tutorial : bool = false
var _is_tutorial_progressed : bool = false


func _ready():
	GameManager.tutorial_cabin.connect(_on_tutorial_allow_interaction)


func _on_tutorial_allow_interaction():
	self.is_tutorial = false


func _on_interact_area_mouse_entered():
	is_mouse_hovering = true


func _on_interact_area_mouse_exited():
	is_mouse_hovering = false


func _on_interact_area_input_event(_viewport, event, _shape_idx):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_card_interaction()

# poki co - ogien zapala na x czasu, woda gasi
# nie mam pomyslu jak to zrobic ladniej wiec moze sie bedzie dalo poprawic
func _card_interaction():
	# nested ifs to ensure no exceptions
	if is_tutorial and not GameManager.merged_blocked and GameManager.merged_total_count < 2:
		return
	if GameManager.selected_card != null and not is_tutorial:
		if GameManager.selected_card.card_type == Globals.card_types.CANDLE:
			AudioPlayer.play_sfx("candle_card")
			_spawn_candle_on_mouse(false)
		elif GameManager.selected_card.card_type == Globals.card_types.CANDLE_LIT:
			AudioPlayer.play_sfx("candle_card")
			_spawn_candle_on_mouse(true)
		
		if not _is_tutorial_progressed:
			_is_tutorial_progressed = true
			GameManager.tutorial_progress.emit()


func _spawn_candle_on_mouse(is_lit : bool):
	var mouse_position = get_local_mouse_position()
	var candle_instantiate = packed_candle.instantiate()
	candle_instantiate.position = Vector2(mouse_position.x, mouse_position.y - 8.0)
	AudioPlayer.play_sfx("put_candle")
	if is_lit:
		candle_instantiate.call_deferred("light_candle")
	add_child(candle_instantiate)
	GameManager.card_used.emit()
