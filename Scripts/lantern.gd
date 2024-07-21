class_name Lantern

extends Node2D

const light_timer_seconds : float = 5.0

var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $LanternSprite
@onready var lantern_timer : Timer = $LanternTimer

@export var managed_by_engine : bool = false

func _ready():
	anim_sprite.play("idle")

func _on_interact_area_mouse_entered():
	is_mouse_hovering = true


func _on_interact_area_mouse_exited():
	is_mouse_hovering = false


func _on_interact_area_input_event(viewport, event, shape_idx):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_card_interaction()

# poki co - ogien zapala na x czasu, woda gasi
# nie mam pomyslu jak to zrobic ladniej wiec moze sie bedzie dalo poprawic
func _card_interaction():
	# nested ifs to ensure no exceptions
	if GameManager.selected_card != null:
		if GameManager.selected_card.card_type == Globals.card_types.ELECTRICITY:
			GameManager.card_used.emit()
			lantern_timer.start(light_timer_seconds)
			turn_on_lantern()


func turn_on_lantern():
	anim_sprite.play("lit")


func turn_off_lantern():
	anim_sprite.play("idle")


func _on_lantern_timer_timeout():
	if not managed_by_engine:
		turn_off_lantern()
