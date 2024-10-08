extends Node2D

signal level_entered;
@onready var player = $Player

func _ready():
	GameManager.assign_player.emit(player)
	AudioPlayer.play_timed_sfx("level_bg", player.player_dead)
	emit_signal("level_entered")
