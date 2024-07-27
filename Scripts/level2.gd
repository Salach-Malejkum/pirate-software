extends Node2D

@onready var spawn_pos = $Marker2D.global_position


func _ready():
	GameManager.player.global_position = spawn_pos
	add_child(GameManager.player)
