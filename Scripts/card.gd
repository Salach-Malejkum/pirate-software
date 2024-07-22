class_name Card

extends TextureRect

@export var card_type : Globals.card_types
@export var index_at_hand : int

const lerp_offset : float = 20.0
const lerp_weight : float = 0.3
var max_y_pos : Vector2
var min_y_pos : Vector2
var is_selected : bool = false

var is_mouse_hovering : bool = false

@onready var hint_type_label = $Label


func _ready():
	texture = load(Globals.card_texture_paths[card_type])
	
	# got values from debugging
	max_y_pos = Vector2(36.0 * index_at_hand, -lerp_offset)
	min_y_pos = Vector2(36.0 * index_at_hand, 0.0)
	hint_type_label.text = Globals.card_types.keys()[self.card_type].replace("_", " ")
	hint_type_label.visible = false


func refresh_lerp_idx(new_idx : int):
	self.index_at_hand = new_idx
	self.max_y_pos = Vector2(36.0 * index_at_hand, -lerp_offset)
	self.min_y_pos = Vector2(36.0 * index_at_hand, 0.0)


func _on_card_used():
	GameManager.current_hand.remove_at(index_at_hand)
	GameManager.reshuffle_deck.emit()
	queue_free()


func set_card_type(new_type : Globals.card_types):
	card_type = new_type
	texture = load(Globals.card_texture_paths[new_type])


func _process(delta):
	if is_mouse_hovering:
		self.position = lerp(self.position, max_y_pos, lerp_weight)
	elif not is_selected:
		self.position = lerp(self.position, min_y_pos, lerp_weight)


func _on_mouse_entered():
	hint_type_label.visible = true
	is_mouse_hovering = true


func _on_mouse_exited():
	hint_type_label.visible = false
	is_mouse_hovering = false


func _on_gui_input(event):
	# nested ifs to ensure no exceptions
	if is_mouse_hovering and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_selected:
				deselect_self()
			else:
				GameManager.card_used.connect(_on_card_used)
				GameManager.select_card(self)

func deselect_self():
	GameManager.card_used.disconnect(_on_card_used)
	GameManager.selected_card = null
	is_selected = false

