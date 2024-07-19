class_name Card

extends TextureRect

@export var card_type : Globals.card_types

const lerp_offset : float = 20.0
const lerp_weight : float = 0.3
var max_y_pos : Vector2
var min_y_pos : Vector2
var is_selected : bool = false

var is_mouse_hovering : bool = false

func _ready():
	texture = load(Globals.card_texture_paths[card_type])
	call_deferred("_lag_fetch_pos")


func _lag_fetch_pos():
	max_y_pos = Vector2(self.position.x, self.position.y - lerp_offset)
	min_y_pos = self.position


func set_card_type(new_type : Globals.card_types):
	card_type = new_type
	texture = load(Globals.card_texture_paths[new_type])


func _process(delta):
	if is_mouse_hovering:
		self.position = lerp(self.position, max_y_pos, lerp_weight)
	elif not is_selected:
		self.position = lerp(self.position, min_y_pos, lerp_weight)


func _on_mouse_entered():
	is_mouse_hovering = true


func _on_mouse_exited():
	is_mouse_hovering = false


func _on_gui_input(event):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameManager.select_card(self)

func deselect_self():
	is_selected = false

