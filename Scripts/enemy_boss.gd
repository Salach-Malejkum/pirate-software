class_name Boss

extends CharacterBody2D

var player_node : Player
var _damage_sources = []
var _current_hp : float = 1000.0

@onready var sprite_anim = $AnimatedSprite2D
@onready var spell_timer = $SpellCd
@onready var morph_timer = $MorphTimer
@onready var spawn_timer = $SpawnCd
@onready var health_bar = $ProgressBar

var packaged_enemy = preload("res://Scenes/enemy.tscn")
var packaged_spell = preload("res://Scenes/cult_mark_spell.tscn")
var _current_phase = 1

func _ready():
	health_bar.max_value = _current_hp
	sprite_anim.play("idle")
	spell_timer.start(3.0)


func _physics_process(delta):
	if player_node == null:
		player_node = get_tree().get_first_node_in_group("Player")
	
	_current_hp -= delta * 30 * _damage_sources.size()
	health_bar.value = _current_hp
	if _current_hp <= 0.0:
		GameManager.total_kills += 1
		if GameManager.total_kills == 2:
			GameManager.tutorial_progress.emit()
		queue_free()
		emit_signal("enemy_dead")


func set_max_hp(max_hp):
	_current_hp = max_hp


func add_dmg_source(src):
	if src not in self._damage_sources:
		self._damage_sources.append(src)


func del_dmg_source(src):
	if is_instance_valid(src):
		self._damage_sources.erase(src)


func _on_spell_cd_timeout():
	if _current_phase == 2:
		return
	sprite_anim.play("attack 1")
	await sprite_anim.animation_finished
	var spell_instance = packaged_spell.instantiate()
	add_child(spell_instance)
	spell_timer.start(0.5)
	if morph_timer.is_stopped():
		morph_timer.start(10.0)


func _on_morph_timer_timeout():
	_current_phase = 1 if _current_phase == 2 else 2
	print(_current_phase)
	spell_timer.stop()
	spawn_timer.stop()
	if _current_phase == 2:
		sprite_anim.play("morph_1_2")
		await sprite_anim.animation_finished
		sprite_anim.play("idle_2")
		spawn_timer.start(1.0)
	elif _current_phase == 1:
		sprite_anim.play_backwards("morph_1_2")
		await sprite_anim.animation_finished
		sprite_anim.play("idle")
		spell_timer.start(0.5)


func _on_spawn_cd_timeout():
	if _current_phase == 1:
		return
	var enemy_1 = packaged_enemy.instantiate()
	enemy_1.set_max_hp(30.0)
	enemy_1.position.x -= 10.0
	var enemy_2 = packaged_enemy.instantiate()
	enemy_2.set_max_hp(30.0)
	enemy_2.position.x += 10.0
	add_child(enemy_1)
	add_child(enemy_2)
	spawn_timer.start(1.0)
	if morph_timer.is_stopped():
		morph_timer.start(10.0)
