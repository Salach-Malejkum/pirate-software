class_name Candle
extends Node2D

const fire_timer_seconds : float = 5.0

@export var is_idle = false
@export var never_expire = false
@export var is_lit = false
var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $CandleSprite
var enemy_arr = []
@onready var light = $PointLight2D
@onready var heat_disortion = $HeatDisortion

func _ready():
	anim_sprite.play("idle")
	if is_lit:
		light_candle()

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
	if GameManager.selected_card != null:
		if GameManager.selected_card.card_type == Globals.card_types.FIRE:
			AudioPlayer.play_sfx("fire_card")
			GameManager.card_used.emit()
			light_candle()
		elif  GameManager.selected_card.card_type == Globals.card_types.WATER:
			heat_disortion.visible = false
			AudioPlayer.play_sfx("water_card")
			GameManager.card_used.emit()
			light.energy = 0.0
			anim_sprite.play("idle")


func light_candle():
	heat_disortion.visible = true
	light.energy = Globals.interactable_light_energy
	anim_sprite.play("fire")
	AudioPlayer.play_sfx("lit_candle")


func _process(delta):
	if light.energy <= 0.1:
		anim_sprite.play("idle")
		heat_disortion.visible = false
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			if light.energy <= 0.1:
				enemy.del_dmg_source(self)
			else:
				enemy.add_dmg_source(self)
	
	if light.energy > 0.0 && !never_expire:
		light.energy -= delta / Globals.light_delta_modifier


func _on_damage_area_body_entered(body):
	if !is_idle && body is Enemy or body is Boss:
		enemy_arr.append(body)
		if light.energy > 0.0:
			body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if !is_idle && body is Enemy or body is Boss:
		enemy_arr.erase(body)
		body.del_dmg_source(self)
