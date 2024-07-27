extends Node2D

var _sees_player : bool = false
var packaged_enemy = preload("res://Scenes/enemy.tscn")
var packaged_spell = preload("res://Scenes/cult_mark_spell.tscn")

@onready var sprite_node : AnimatedSprite2D = $body_hitbox/AnimatedSprite2D
@onready var cd_timer : Timer = $Cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _cultist_skill():
	var enemy_1 = packaged_enemy.instantiate()
	# mniejsze HP zeby nie karac gracza za bardzo
	enemy_1.set_max_hp(30.0)
	enemy_1.position.x -= 10.0
	var enemy_2 = packaged_enemy.instantiate()
	# mniejsze HP zeby nie karac gracza za bardzo
	enemy_2.set_max_hp(30.0)
	enemy_2.position.x += 10.0
	add_child(enemy_1)
	add_child(enemy_2)
	var spell_instance = packaged_spell.instantiate()
	add_child(spell_instance)

func _on_sight_area_body_entered(body):
	if body is Player:
		sprite_node.play("player_seen")
		cd_timer.start(1.0)
		_sees_player = true


func _on_sight_area_body_exited(body):
	if body is Player:
		_sees_player = false
		sprite_node.play_backwards("player_seen")


func _on_cooldown_timeout():
	if _sees_player:
		_cultist_skill()
		cd_timer.start(5.0)


var is_mouse_hovering = false

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
	if GameManager.selected_card != null:
		if GameManager.selected_card.card_type == Globals.card_types.CULT_MARK:
			GameManager.card_used.emit()
			sprite_node.play_backwards("player_seen")
			await sprite_node.animation_finished
			queue_free()
