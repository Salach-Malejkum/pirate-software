class_name Furnace

extends Node2D

const fire_timer_seconds : float = 5.0
signal furnance_stop

var is_mouse_hovering : bool = false
var enemy_arr = []
@onready var anim_sprite : AnimatedSprite2D = $Static/FurnaceSprite
@onready var light = $PointLight2D
@export var is_tutorial : bool = false
var _is_tutorial_progressed : bool = false

func _ready():
	GameManager.tutorial_furnace.connect(_on_tutorial_allow_interaction)
	anim_sprite.play("idle")


func _on_tutorial_allow_interaction():
	self.is_tutorial = false


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
	if is_tutorial and not GameManager.merged_blocked and GameManager.merged_total_count < 2:
		return
	if GameManager.selected_card != null and not is_tutorial:
		if GameManager.selected_card.card_type == Globals.card_types.FIRE:
			GameManager.card_used.emit()
			light.energy = Globals.interactable_light_energy
			anim_sprite.play("fire")
			AudioPlayer.play_timed_sfx("furnance_fire", furnance_stop)
		elif  GameManager.selected_card.card_type == Globals.card_types.WATER:
			AudioPlayer.play_sfx("water_card")
			GameManager.card_used.emit()
			light.energy = 0.0
			emit_signal("furnance_stop")
			
		
		if not _is_tutorial_progressed:
			_is_tutorial_progressed = true
			GameManager.tutorial_progress.emit()


func _process(delta):
	if light.energy <= 0.1:
		anim_sprite.play("idle")
		emit_signal("furnance_stop")

	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			if light.energy <= 0.1:
				enemy.del_dmg_source(self)
			else:
				enemy.add_dmg_source(self)
	
	if light.energy > 0.0:
		light.energy -= delta / Globals.light_delta_modifier


func _on_damage_area_body_entered(body):
	if body is Enemy:
		enemy_arr.append(body)
		if light.energy > 0.0:
			body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if body is Enemy:
		enemy_arr.erase(body)
		body.del_dmg_source(self)
