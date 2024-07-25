extends Node

var sfx = {
	"door_open": preload("res://Audio/door_open.mp3"),
	"door_close": preload("res://Audio/door_close.mp3"),
	"put_candle": preload("res://Audio/put_candle.mp3"),
	"card_merge": preload("res://Audio/card_merge.mp3"),
	"lit_lamp": preload("res://Audio/lantern_on_electricity_card.mp3"),
	"water_card": preload("res://Audio/water_card_use.mp3"),
	"lit_candle": preload("res://Audio/candle_light.mp3"),
}

var timed_sfx = {
	"steam_engine": preload("res://Audio/steam_engine_running.mp3"),
	"furnance_fire": preload("res://Audio/furnace_fire.mp3"),
	"enemy_sound": preload("res://Audio/enemy_sound.mp3"),
	"menu_music": preload("res://Audio/menu.mp3"),
	"level_bg": preload("res://Audio/level_bg.mp3")
}

var movement_sfx = [
	preload("res://Audio/player_move_1.mp3"),
	preload("res://Audio/player_move_2.mp3"),
	preload("res://Audio/player_move_3.mp3"),
	preload("res://Audio/player_move_4.mp3"),
	preload("res://Audio/player_move_5.mp3")
]

var music_sfx_names = [
	"menu_music",
	"level_bg"
]

var is_movement_running = false

func play_sfx(sfx_name: String):
	if sfx.has(sfx_name):
		var asp = AudioStreamPlayer.new()
		asp.stream = sfx[sfx_name]
		asp.name = "SFX"
		asp = add_to_bus(asp, sfx_name)
		
		add_child(asp)
		asp.play()
		
		await asp.finished
		asp.queue_free()


func play_timed_sfx(sfx_name: String, signal_name):
	if timed_sfx.has(sfx_name):
		var asp = AudioStreamPlayer.new()
		asp.stream = timed_sfx[sfx_name]
		asp.name = "Timed_SFX"
		asp = add_to_bus(asp, sfx_name)
		
		add_child(asp)
		asp.play()
		
		await signal_name
		asp.queue_free()

func random_movement_sfx():
	if is_movement_running:
		return
	
	is_movement_running = true
	var asp = AudioStreamPlayer.new()
	asp.stream = movement_sfx[randi() % movement_sfx.size()]
	asp.name = "Movement_SFX"
	asp = add_to_bus(asp)
	
	add_child(asp)
	asp.play()
	
	await asp.finished
	asp.queue_free()
	is_movement_running = false

func player_dead():
	for child in get_children():
		if child.name == "Movement_SFX" || child.name == "SFX":
			await child.finished
		remove_child(child)
		child.queue_free()


func add_to_bus(asp, sfx_name="default"):
	if sfx_name in music_sfx_names:
		asp.bus = "Music"
	else:
		asp.bus = "SFX"
	
	return asp
