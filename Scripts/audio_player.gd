extends Node

var sfx = {
	"door_open": preload("res://Audio/door_open.mp3"),
	"door_close": preload("res://Audio/door_close.mp3"),
	"put_candle": preload("res://Audio/put_candle.mp3"),
	"card_merge": preload("res://Audio/card_merge.mp3"),
	"lit_lamp": preload("res://Audio/lantern_on_electricity_card.mp3")
}

func play_sfx(sfx_name: String):
	if sfx.has(sfx_name):
		var asp = AudioStreamPlayer.new()
		asp.stream = sfx[sfx_name]
		asp.name = "SFX"
		
		add_child(asp)
		asp.play()
		
		await asp.finished
		asp.queue_free()
