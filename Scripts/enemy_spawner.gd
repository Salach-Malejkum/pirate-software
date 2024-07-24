extends Node2D


@export var on_ready_timer : float = 4.0
@export var spawn_timer : float = 6.0
@export var is_tutorial : bool = false
@export var max_enemies_for_spawner : int = 5
@export var enemy_hp_on_spawn : float = 100.0
@onready var timer_node : Timer = $SpawnTimer

var packaged_enemy = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.tutorial_spawner.connect(_on_tutorial_spawn)
	if not is_tutorial:
		timer_node.start(on_ready_timer)


func _on_tutorial_spawn():
	timer_node.start(1.0)


func _on_spawn_timer_timeout():
	# -2 bo ma 2 children defaultowo
	if self.get_children().size() - 2 < max_enemies_for_spawner:
		_spawn_enemy_details()
	
	timer_node.start(spawn_timer)

func _spawn_enemy_details():
	var enemy_instance = packaged_enemy.instantiate()
	enemy_instance.set_max_hp(enemy_hp_on_spawn)
	add_child(enemy_instance)
