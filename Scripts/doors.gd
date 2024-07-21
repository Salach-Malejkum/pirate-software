extends Node2D


@export var is_closed = true
@export var flip_h = false
@export var open_anim_name = "open"
@export var close_anim_name = "close"

var player_in_range = false
@onready var animated_sprite = $Static/AnimatedSprite2D
@onready var door_collision = $Static/CollisionShape2D

func _process(delta):
	animated_sprite.animation = open_anim_name
	animated_sprite.flip_h = flip_h
	if Input.is_action_just_pressed("open_door") && player_in_range:
		await manage_door()

func manage_door():
	print(is_closed)
	if is_closed:
		animated_sprite.play(open_anim_name)
		await animated_sprite.animation_finished
		print("reach")
		is_closed = false
		door_collision.disabled = true
	else:
		animated_sprite.play_backwards(open_anim_name)
		print(animated_sprite.animation)
		door_collision.disabled = false
		await animated_sprite.animation_finished
		is_closed = true


func _on_area_to_open_body_entered(body):
	if body is Player:
		player_in_range = true


func _on_area_to_open_body_exited(body):
	if body is Player:
		player_in_range = false
	
