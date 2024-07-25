extends HSlider

@export var bus_name : String

var bus_index : int
const INITIAL_VOL = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(INITIAL_VOL))
	
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
