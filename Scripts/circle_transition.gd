extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer
@export var scene_to_load = preload("res://Scenes/main_menu.tscn")
signal exit_anim_finished

func _ready():
	color_rect.material.set_shader_parameter("u_resolution", get_viewport().size)


func _on_level_1_level_entered():
	anim_player.play("fade_in")



func _on_stairs_level_exit():
	anim_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		AudioPlayer.play_sfx("scene_switch")
		emit_signal("exit_anim_finished")
