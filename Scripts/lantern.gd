class_name Lantern

extends Node2D

const light_timer_seconds : float = 5.0

var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $LanternSprite
@onready var lantern_timer : Timer = $LanternTimer

@export var managed_by_engine : bool = false
@onready var light = $PointLight2D
var enemy_arr = []

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
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			enemy.add_dmg_source(self)
	light.energy = Globals.interactable_light_energy
	anim_sprite.play("lit")


func turn_off_lantern():
	light.energy = 0.0
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			enemy.del_dmg_source(self)
	anim_sprite.play("idle")


func _on_damage_area_body_entered(body):
	if body is Enemy:
		enemy_arr.append(body)
		if light.energy > 0.0:
			body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if body is Enemy:
		enemy_arr.erase(body)
		body.del_dmg_source(self)
