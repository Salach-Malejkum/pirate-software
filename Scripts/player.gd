class_name Player

extends CharacterBody2D

@export var SPEED = 100
@export var is_tutorial = false
@onready var anim_sprite = $AnimatedSprite2D
@onready var texture_rect = $CanvasLayer/TextureRect
@onready var light = $PointLight2D
@onready var tutorial_node = $TutorialInfo

var _current_damage_chunk : float = 0.0
var enemy_arr = []


func _ready():
	if not is_tutorial:
		GameManager.tutorial_select_blocked = false
		GameManager.merged_blocked = false


func move_player(time):
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * SPEED


func move_anim():
	var vertical_movement = Input.get_axis("move_left", "move_right")
	
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if vertical_movement == 1:
		anim_sprite.play("walking_sides")
		anim_sprite.flip_h = false
		flip_light_right()
		
	elif vertical_movement == -1:
		anim_sprite.play("walking_sides")
		anim_sprite.flip_h = true
		flip_light_left()
	
	var horizontal_movement = Input.get_axis("move_up", "move_down")
	if horizontal_movement == 0:
		return
	elif horizontal_movement == 1:
		anim_sprite.play("walking_down")
	else:
		anim_sprite.play("walking_up")

func flip_light_right():
	light.position.x = light.position.x if light.position.x > 0  else -light.position.x 


func flip_light_left():
	light.position.x = light.position.x if light.position.x < 0  else -light.position.x 


func _physics_process(delta):
	move_player(delta)
	move_anim()
	move_and_slide()
	#light_shader.material.set_shader_parameter("u_resolution", get_viewport().size)
	
	# clear dead enemies before rest
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			if light.energy <= 0.0:
				enemy.del_dmg_source(self)
	
	if enemy_arr.size() > 0 and light.energy > 0.0:
		_current_damage_chunk += delta
		if _current_damage_chunk >= 0.5:
			_current_damage_chunk = 0.0
			light.energy -= 0.05
	
	# test dodawania kart
	# Z - swieczka
	# X - elektrycznosc
	# C - woda
	# V - ogien
	if Input.is_action_just_pressed("test_candle"):
		var card_manager : CardManager = get_tree().get_first_node_in_group("CardManager")
		card_manager.add_card(Globals.card_types.CANDLE)
	elif Input.is_action_just_pressed("test_electricity"):
		var card_manager : CardManager = get_tree().get_first_node_in_group("CardManager")
		card_manager.add_card(Globals.card_types.ELECTRICITY)
	elif Input.is_action_just_pressed("test_water"):
		var card_manager : CardManager = get_tree().get_first_node_in_group("CardManager")
		card_manager.add_card(Globals.card_types.WATER)
	elif Input.is_action_just_pressed("test_fire"):
		var card_manager : CardManager = get_tree().get_first_node_in_group("CardManager")
		card_manager.add_card(Globals.card_types.FIRE)


func _on_damage_area_body_entered(body):
	if body is Enemy and self.light.energy > 0.0:
		enemy_arr.append(body)
		if light.energy > 0.0:
			body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if body is Enemy and self.light.energy > 0.0:
		enemy_arr.erase(body)
		body.del_dmg_source(self)


func _on_death_area_body_entered(body):
	if body is Enemy and self.light.energy <= 0.0:
		# todo: lose condition
		print("dead")
