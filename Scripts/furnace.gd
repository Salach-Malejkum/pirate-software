class_name Furnace

extends Node2D

var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $Static/FurnaceSprite

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


func _card_interaction():
	if GameManager.selected_card.card_type == Globals.card_types.FIRE:
		
		pass
