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
		animated_sprite.play("open")
		await animated_sprite.animation_finished
		is_closed = false
		door_collision.disabled = true
	else:
		animated_sprite.play("close")
		door_collision.disabled = false
		await animated_sprite.animation_finished
		is_closed = true


func _on_area_to_open_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true


func _on_area_to_open_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
	
