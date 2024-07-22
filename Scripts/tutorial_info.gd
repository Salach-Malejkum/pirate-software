extends Control


@onready var tutorial_text = $CanvasLayer/Label
@onready var next_text_timer = $Timer

var current_text_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial_text.visible = true if get_parent().is_tutorial else false
	GameManager.tutorial_progress.connect(_progress_tutorial)
	_show_hint_text()


func _progress_tutorial():
	current_text_idx += 1
	_show_hint_text()


func _show_hint_text():
	if current_text_idx < GameManager.tutorial_texts.keys().size():
		var curr_key = GameManager.tutorial_texts.keys()[current_text_idx]
		tutorial_text.text = curr_key
		
		if GameManager.tutorial_texts[curr_key] == null:
			next_text_timer.start(Globals.tutorial_text_timer)
		else:
			GameManager.tutorial_texts[curr_key].emit()


func _on_timer_timeout():
	current_text_idx += 1
	_show_hint_text()
