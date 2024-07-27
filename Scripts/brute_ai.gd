class_name Enemy_Brute

extends CharacterBody2D
signal enemy_dead

var player_node : Player
const SPEED : int = 45

var _damage_sources = []
var _current_hp : float = 30.0

@export var patrol_points : Array[Marker2D]
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("walk")
#	AudioPlayer.play_timed_sfx("enemy_sound", enemy_dead)


var next_positions: Array
var current_position

func _physics_process(delta):
	if current_position:
		velocity = self.global_position.direction_to(current_position.global_position) * SPEED
		if velocity.x < 0.0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		if self.global_position.distance_to(current_position.global_position) > 10:
			move_and_slide()
		elif not current_position is Player:
			_get_next_position()
	else:
		_get_next_position()
	
	_current_hp -= delta * 30 * _damage_sources.size()
	
	if _current_hp <= 0.0:
		GameManager.total_kills += 1
		if GameManager.total_kills == 2:
			GameManager.tutorial_progress.emit()
		queue_free()
		emit_signal("enemy_dead")


func _get_positions():
	next_positions = patrol_points.duplicate()
	next_positions.shuffle()


func _get_next_position():
	if next_positions.is_empty():
		_get_positions()
	current_position = next_positions.pop_front()
	


func set_max_hp(max_hp):
	_current_hp = max_hp


func add_dmg_source(src):
	if src not in self._damage_sources:
		self._damage_sources.append(src)


func del_dmg_source(src):
	if is_instance_valid(src):
		self._damage_sources.erase(src)


func _on_player_spotted_body_entered(body):
	if body is Player:
		current_position = body


func _on_player_spotted_body_exited(body):
	if body is Player:
		_get_next_position()
