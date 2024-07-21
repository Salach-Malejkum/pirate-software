extends Node2D


@export var scene_to_load = preload("res://Scenes/main_menu.tscn")
var player_in_range = false
@onready var animated_sprite = $Static/AnimatedSprite2D
@onready var door_collision = $Static/CollisionShape2D

func _process(delta):
	if Input.is_action_just_pressed("open_door") && player_in_range:
		await manage_stairs()
		

func manage_stairs():
	#get_tree().change_scene_to_packed(scene_to_load)
	get_tree().reload_current_scene()


func _on_area_2d_body_entered(body):
	print("out")
	if body.is_in_group("Player"):
		player_in_range = true


func _on_area_2d_body_exited(body):
	print("in")
	if body.is_in_group("Player"):
		player_in_range = false
