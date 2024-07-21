extends Node2D

signal level_entered;

func _ready():
	emit_signal("level_entered")
