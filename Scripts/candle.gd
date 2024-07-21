extends Node2D

const fire_timer_seconds : float = 5.0

var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $CandleSprite
@onready var fire_timer : Timer = $BurnTimer

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
		if GameManager.selected_card.card_type == Globals.card_types.FIRE:
			GameManager.card_used.emit()
			light_candle()
		elif  GameManager.selected_card.card_type == Globals.card_types.WATER:
			GameManager.card_used.emit()
			fire_timer.stop()
			fire_timer.timeout.emit()


func light_candle():
	fire_timer.start(fire_timer_seconds)
	anim_sprite.play("fire")


func _on_fire_timer_timeout():
	anim_sprite.play("idle")
