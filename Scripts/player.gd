class_name Player

extends CharacterBody2D

@export var SPEED = 100
@onready var anim_sprite = $AnimatedSprite2D
@onready var texture_rect = $CanvasLayer/TextureRect

func move_player(time):
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * SPEED


func move_anim():
	var vertical_movement = Input.get_axis("move_left", "move_right")
	
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if vertical_movement == 1:
		anim_sprite.play("walking_sides")
		anim_sprite.flip_h = false
	elif vertical_movement == -1:
		anim_sprite.play("walking_sides")
		anim_sprite.flip_h = true
	
	var horizontal_movement = Input.get_axis("move_up", "move_down")
	if horizontal_movement == 0:
		return
	elif horizontal_movement == 1:
		anim_sprite.play("walking_down")
	else:
		anim_sprite.play("walking_up")



func _physics_process(delta):
	move_player(delta)
	move_anim()
	move_and_slide()
