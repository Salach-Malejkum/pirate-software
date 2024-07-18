extends CharacterBody2D

@export var SPEED = 300


func move_player(time):
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * SPEED


func _physics_process(delta):
	move_player(delta)
	move_and_slide()
