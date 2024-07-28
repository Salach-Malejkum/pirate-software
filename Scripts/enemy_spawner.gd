extends Node2D


@export var on_ready_timer : float = 4.0
@export var spawn_timer : float = 6.0
@export var is_tutorial : bool = false
@export var max_enemies_for_spawner : int = 5
@export var enemy_hp_on_spawn : float = 100.0
@onready var timer_node : Timer = $SpawnTimer
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var packaged_enemy = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.tutorial_spawner.connect(_on_tutorial_spawn)
	if not is_tutorial:
		timer_node.start(on_ready_timer)


func _on_tutorial_spawn():
	is_tutorial = false
	timer_node.start(1.0)


func _on_spawn_timer_timeout():
	# -2 bo ma 2 children defaultowo
	if self.get_children().size() - 2 < max_enemies_for_spawner:
		sprite.play("spawning")
		_spawn_enemy_details()
	
	timer_node.start(spawn_timer)

func _spawn_enemy_details():
	var enemy_instance = packaged_enemy.instantiate()
	enemy_instance.set_max_hp(enemy_hp_on_spawn)
	add_child(enemy_instance)


var is_mouse_hovering : bool = false


func _on_interact_area_mouse_entered():
	is_mouse_hovering = true


func _on_interact_area_mouse_exited():
	is_mouse_hovering = false


func _on_interact_area_input_event(viewport, event, shape_idx):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_card_interaction()


func _card_interaction():
	# nested ifs to ensure no exceptions
	if GameManager.selected_card != null and not is_tutorial:
		if GameManager.selected_card.card_type == Globals.card_types.ESSENCE:
			GameManager.card_used.emit()
			sprite.play("destroy")
			await sprite.animation_finished
			queue_free()
			if GameManager.total_kills < 3:
				GameManager.tutorial_progress.emit()
