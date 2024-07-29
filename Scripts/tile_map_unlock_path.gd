extends TileMap

@onready var candles = [$"../Objects/Candle", $"../Objects/Candle2"]
var is_opening = false

func _process(_delta):
	if !is_opening:
		check_open_cond()


func delete_tile(x: int, y: int):
	set_cell(1, Vector2i(x, y), -1)  # Setting the tile ID to -1 removes the tile


func start_path_opening():
	AudioPlayer.play_sfx("lock_open")
	await get_tree().create_timer(1.0).timeout
	delete_tile(31, 14)
	delete_tile(31, 13)
	AudioPlayer.play_sfx("lock_open")
	await get_tree().create_timer(1.0).timeout
	delete_tile(29, 14)
	delete_tile(29, 13)
	AudioPlayer.play_sfx("lock_open")
	await get_tree().create_timer(1.0).timeout
	delete_tile(27, 14)
	delete_tile(27, 13)
	AudioPlayer.play_sfx("lock_open")
	await get_tree().create_timer(1.0).timeout
	delete_tile(25, 14)
	delete_tile(25, 13)
	

func check_open_cond():
	if check_light_energy(0) && check_light_energy(1):
		is_opening = true
		start_path_opening()
		
		
func check_light_energy(ind: int):
	return candles[ind].light.energy > 0
