extends Node2D


@export var is_closed = true
@export var flip_h = false
@export var open_anim_name = "open"
@export var close_anim_name = "close"
@export var is_exit : bool = false
@export var exit_scene : PackedScene

var player_in_range = false
@onready var animated_sprite = $Static/AnimatedSprite2D
@onready var door_collision = $Static/CollisionShape2D


func _process(delta):
	animated_sprite.animation = open_anim_name
	animated_sprite.flip_h = flip_h
	if Input.is_action_just_pressed("open_door") && player_in_range:
		await manage_door()

func manage_door():
	if is_closed:
		animated_sprite.play(open_anim_name)
		manage_oclussion()
		AudioPlayer.play_sfx("door_open")
		await animated_sprite.animation_finished
		if is_exit:
			get_tree().change_scene_to_packed(exit_scene)
		is_closed = false
		door_collision.disabled = true
	else:
		animated_sprite.play_backwards(open_anim_name)
		door_collision.disabled = false
		AudioPlayer.play_sfx("door_close")
		await animated_sprite.animation_finished
		manage_oclussion()
		is_closed = true

func try_get_child(child_name: String) -> Node:
	if has_node(child_name):
		return get_node(child_name)
	else:
		return null
		

func manage_oclussion():
	var oclussion = try_get_child("LightOccluder2D")
	if oclussion != null:
		oclussion.visible  = not oclussion.visible 


func _on_area_to_open_body_entered(body):
	if body is Player:
		player_in_range = true


func _on_area_to_open_body_exited(body):
	if body is Player:
		player_in_range = false
	
