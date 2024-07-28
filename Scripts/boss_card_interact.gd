extends Area2D

var is_mouse_hovering = false
var packed_boss = preload("res://Scenes/enemy_boss.tscn")

var _boss_spawned = false
var placed_candles = 0
var boss_spawnable = false

func _process(delta):
	placed_candles = get_tree().get_nodes_in_group("Candle").size()
	if placed_candles >= 5:
		boss_spawnable = true


func _on_mouse_entered():
	is_mouse_hovering = true


func _on_mouse_exited():
	is_mouse_hovering = false


func _on_input_event(viewport, event, shape_idx):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_card_interaction()

# poki co - ogien zapala na x czasu, woda gasi
# nie mam pomyslu jak to zrobic ladniej wiec moze sie bedzie dalo poprawic
func _card_interaction():
	# nested ifs to ensure no exceptions
	if GameManager.selected_card != null and not _boss_spawned and boss_spawnable:
		if GameManager.selected_card.card_type == Globals.card_types.BEAST_HEAD:
			AudioPlayer.boss_fight_music()
			GameManager.card_used.emit()
			var boss_instance = packed_boss.instantiate()
			boss_instance.position.y -= 20
			add_child(boss_instance)
			_boss_spawned = true
