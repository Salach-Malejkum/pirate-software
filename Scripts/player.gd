class_name Player

extends CharacterBody2D
signal player_dead

@export var SPEED = 100
@export var is_tutorial = false
@export var player_min_hp = 0.1
@onready var anim_sprite = $AnimatedSprite2D
@onready var texture_rect = $CanvasLayer/TextureRect
@onready var light = $AnimatedSprite2D/PointLight2D
@onready var tutorial_node = $TutorialInfo
@onready var shield_sprite = $shield

var _current_damage_chunk : float = 0.0
var enemy_arr = []
var deadly_enemies = 0

var _death_scene = preload("res://Scenes/end_score.tscn")
var _boss_hp_scene = preload("res://Scenes/boss_hp_bar.tscn")

func _ready():
	player_dead.connect(Callable(AudioPlayer, "player_dead"))
	GameManager.boss_spawned.connect(_show_boss_bar)
	GameManager.card_used.connect(_add_hp_on_card_use)
	if not is_tutorial:
		GameManager.tutorial_select_blocked = false
		GameManager.merged_blocked = false


func move_player():
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * SPEED


func _show_boss_bar():
	var hp_bar_instance = _boss_hp_scene.instantiate()
	add_child(hp_bar_instance)


func _add_hp_on_card_use():
	light.energy = clamp(light.energy + 0.15, player_min_hp, 1.0)


func move_anim():
	var vertical_movement = Input.get_axis("move_left", "move_right")
	
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
	move_player()
	move_anim()
	move_and_slide()
	move_sfx()
	
	# clear dead enemies before rest
	for enemy in enemy_arr:
		if not is_instance_valid(enemy):
			enemy_arr.erase(enemy)
		else:
			if light.energy <= player_min_hp:
				enemy.del_dmg_source(self)
	
	if enemy_arr.size() > 0 and light.energy > player_min_hp:
		_current_damage_chunk += delta
		if _current_damage_chunk >= 1.5:
			_current_damage_chunk = 0.0
			light.energy -= 0.05
	if light.energy <= player_min_hp:
		shield_sprite.visible = false
		if deadly_enemies > 0:
			_player_death()
	else:
		shield_sprite.visible = true
	

func take_spell_damage(damage: float):
	light.energy = clamp(light.energy - damage, player_min_hp - 0.05, 1.0)
	if light.energy <= player_min_hp:
		_player_death()


func _on_damage_area_body_entered(body):
	if body is Enemy or body is Enemy_Brute or body is Boss: 
		if self.light.energy > player_min_hp:
			enemy_arr.append(body)
			if light.energy > player_min_hp:
				body.add_dmg_source(self)


func _on_damage_area_body_exited(body):
	if body is Enemy or body is Enemy_Brute or body is Boss: 
		if self.light.energy > player_min_hp:
			enemy_arr.erase(body)
			body.del_dmg_source(self)


func _on_death_area_body_entered(body):
	if body is Enemy or body is Enemy_Brute or body is Boss:
		self.deadly_enemies += 1


func _on_death_area_body_exited(body):
	if body is Enemy or body is Enemy_Brute or body is Boss:
		self.deadly_enemies -= 1


func _player_death():
	emit_signal("player_dead")
	get_tree().change_scene_to_packed(_death_scene)
