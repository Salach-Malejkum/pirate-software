class_name Player

extends CharacterBody2D

@export var SPEED = 100
@export var is_tutorial = false
@export var player_min_hp = 0.1
@onready var anim_sprite = $AnimatedSprite2D
@onready var texture_rect = $CanvasLayer/TextureRect
@onready var light = $PointLight2D
@onready var tutorial_node = $TutorialInfo

var _current_damage_chunk : float = 0.0
var enemy_arr = []

var _death_scene = preload("res://Scenes/end_score.tscn")

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


func move_sfx():
	if not velocity.is_zero_approx():
		AudioPlayer.random_movement_sfx()


func _physics_process(delta):
	move_player(delta)
	move_anim()
	move_and_slide()
	move_sfx()
	#light_shader.material.set_shader_parameter("u_resolution", get_viewport().size)
	
	# clear dead enemies before rest
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			if light.energy <= player_min_hp:
				enemy.del_dmg_source(self)
	
	if enemy_arr.size() > 0 and light.energy > player_min_hp:
		_current_damage_chunk += delta
		if _current_damage_chunk >= 0.5:
			_current_damage_chunk = 0.0
			light.energy -= 0.05


func _on_damage_area_body_entered(body):
	if body is Enemy and self.light.energy > player_min_hp:
		enemy_arr.append(body)
		if light.energy > player_min_hp:
			body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if body is Enemy and self.light.energy > player_min_hp:
		enemy_arr.erase(body)
		body.del_dmg_source(self)


func _on_death_area_body_entered(body):
	if body is Enemy and self.light.energy <= player_min_hp:
		get_tree().change_scene_to_packed(_death_scene)
