extends Node2D


var spell_target : Player = null
@onready var activate_timer : Timer = $Activate
@onready var sprite = $AnimatedSprite2D

func _ready():
	self.global_position = get_tree().get_first_node_in_group("Player").global_position
	sprite.play("warning")
	call_deferred("_lag_spell_timer")
	AudioPlayer.play_sfx("cultist_attack")


func _lag_spell_timer():
	activate_timer.start(1.0)


func _on_area_2d_body_entered(body):
	if body is Player:
		spell_target = body


func _on_area_2d_body_exited(body):
	if body is Player:
		spell_target = null


func _on_activate_timeout():
	if spell_target != null:
		spell_target.take_spell_damage(0.10)
	sprite.play("fire")
	GameManager.shake_screen.emit()
	await sprite.animation_finished
	queue_free()
