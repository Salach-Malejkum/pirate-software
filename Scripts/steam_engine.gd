extends Node2D

const engine_timer_seconds : float = 5.0
signal steam_engine_stop

var is_mouse_hovering : bool = false
@onready var anim_sprite : AnimatedSprite2D = $Static/SteamEngineTop
@onready var engine_timer : Timer = $EnginePowerTimer
@export var is_tutorial : bool = false
var _is_tutorial_progressed : bool = false

func _ready():
	GameManager.tutorial_engine.connect(_on_tutorial_allow_interaction)
	anim_sprite.play("idle")


func _on_tutorial_allow_interaction():
	self.is_tutorial = false


func _on_interact_area_mouse_entered():
	is_mouse_hovering = true


func _on_interact_area_mouse_exited():
	is_mouse_hovering = false


func _on_interact_area_input_event(_viewport, event, _shape_idx):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_card_interaction()

# poki co - ogien zapala na x czasu, woda gasi
# nie mam pomyslu jak to zrobic ladniej wiec moze sie bedzie dalo poprawic
func _card_interaction():
	# nested ifs to ensure no exceptions
	if is_tutorial and not GameManager.merged_blocked and GameManager.merged_total_count < 2:
		return
	if GameManager.selected_card != null and not is_tutorial:
		if GameManager.selected_card.card_type == Globals.card_types.STEAM:
			AudioPlayer.play_sfx("steam_card")
			GameManager.card_used.emit()
			start_engine()
		
		if not _is_tutorial_progressed:
			_is_tutorial_progressed = true
			GameManager.tutorial_progress.emit()


func start_engine():
	for child in get_children():
		if child is Lantern:
			child.turn_on_lantern()
			child.managed_by_engine = true
	engine_timer.start(engine_timer_seconds)
	anim_sprite.play("running")
	AudioPlayer.play_timed_sfx("steam_engine", steam_engine_stop)


func _on_engine_power_timer_timeout():
	for child in get_children():
		if child is Lantern:
			child.turn_off_lantern()
			child.managed_by_engine = false
	anim_sprite.play("idle")
	emit_signal("steam_engine_stop")
