extends Node2D


@export var is_closed = true

var player_in_range = false
@onready var animated_sprite = $Static/AnimatedSprite2D
@onready var door_collision = $Static/CollisionShape2D

func _process(delta):
	if Input.is_action_just_pressed("open_door") && player_in_range:
		await manage_door()

func manage_door():
	if is_closed:
		is_closed = false
		animated_sprite.play("open")
		await animated_sprite.animation_finished
		door_collision.disabled = true
	else:
		is_closed = true
		animated_sprite.play("close")
		door_collision.disabled = false
		await animated_sprite.animation_finished
		


func _on_area_to_open_body_entered(body):
	player_in_range = true


func _on_area_to_open_body_exited(body):
	player_in_range = false
