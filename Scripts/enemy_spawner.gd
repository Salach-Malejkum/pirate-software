extends Node2D


@export var on_ready_timer : float = 4.0
@export var spawn_timer : float = 6.0
@export var is_tutorial : bool = false

@onready var timer_node : Timer = $SpawnTimer

var packaged_enemy = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.tutorial_spawner.connect(_on_tutorial_spawn)
	if not is_tutorial:
		timer_node.start(on_ready_timer)


func _on_tutorial_spawn():
	print("reach")
	timer_node.start(1.0)


func _on_spawn_timer_timeout():
	_spawn_enemy_details()
	
	timer_node.start(spawn_timer)

func _spawn_enemy_details():
	var enemy_instance = packaged_enemy.instantiate()
	add_child(enemy_instance)
	
	enemy_instance.connect("enemy_dead", Callable(GameManager, "increament_score"))
	pass
