extends Node

var sfx = {
	"door_open": preload("res://Audio/door_open.mp3"),
	"door_close": preload("res://Audio/door_close.mp3"),
	"put_candle": preload("res://Audio/put_candle.mp3"),
	"card_merge": preload("res://Audio/card_merge.mp3"),
	"lit_lamp": preload("res://Audio/lantern_on_electricity_card.mp3"),
	"water_card": preload("res://Audio/water_card_use.mp3"),
	"fire_card": preload("res://Audio/fire_card_use.mp3"),
	"lit_candle": preload("res://Audio/candle_light.mp3"),
	"card_selected": preload("res://Audio/card_selected.mp3"),
	"card_unselected": preload("res://Audio/card_unselected.mp3"),
	"card_draw": preload("res://Audio/card_draw.mp3"),
	"steam_card": preload("res://Audio/steam_card.mp3"),
	"candle_card": preload("res://Audio/candle_card.mp3"),
	"essence_card": preload("res://Audio/essence_card.mp3"),
	"cultist_card": preload("res://Audio/cultist_card.mp3"),
	"cultist_attack": preload("res://Audio/cultist_attack.mp3"),
	"mouse_clicked": preload("res://Audio/mouse_clicked.mp3"),
	"scene_switch": preload("res://Audio/scene_switch.mp3"),
	"boss_spawn": preload("res://Audio/boss_spawn.mp3"),
	"lock_open": preload("res://Audio/lock_open.mp3"),
	"boss_attack": preload("res://Audio/boss_atack.mp3"),
	"boss_morph": preload("res://Audio/boss_morph.mp3"),
}

var timed_sfx = {
	"steam_engine": preload("res://Audio/steam_engine_running.mp3"),
	"furnance_fire": preload("res://Audio/furnace_fire.mp3"),
	"enemy_sound": preload("res://Audio/enemy_sound.mp3"),
	"menu_music": preload("res://Audio/menu.mp3"),
	"level_bg": preload("res://Audio/level_bg.mp3"),
	"boss_fight": preload("res://Audio/bossfight.mp3"),
	"boss_idle_1": preload("res://Audio/boss_idle.mp3"),
	"boss_idle_2": preload("res://Audio/boss_idle_2.mp3")
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
var is_clicked_sound = false

func _input(event):
	if event is InputEventMouseButton && event.pressed && !is_clicked_sound:
		is_clicked_sound = true
		var asp = AudioStreamPlayer.new()
		asp.stream = sfx["mouse_clicked"]
		asp.name = "SFX"
		asp = add_to_bus(asp, "clicked")
		
		add_child(asp)
		asp.play()
		
		await asp.finished
		asp.queue_free()
		is_clicked_sound = false


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
		if sfx_name == "level_bg":
			asp.name = "level_bg"
		else:
			asp.name = "Timed_SFX"
		asp = add_to_bus(asp, sfx_name)
		
		add_child(asp)
		asp.play()
		
		await signal_name
		if asp != null:
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
		if child == null:
			continue
		if child.name == "Movement_SFX" || child.name == "SFX":
			await child.finished
		remove_child(child)
		child.queue_free()


func change_scene(boss_fight=false):
	print(len(get_children()))
	var sfx_to_del = []
	for child in get_children():
		if !boss_fight && child.name == "level_bg":
			continue
		sfx_to_del.append(child)
		
	for child in sfx_to_del:
		if child == null:
			continue
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


func boss_fight_music():
	change_scene(true)
	AudioPlayer.play_sfx("boss_spawn")
	play_timed_sfx("boss_fight", GameManager.boss_ended)
	
