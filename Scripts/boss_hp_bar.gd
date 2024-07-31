extends Control

@onready var bar = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.max_value = GameManager.boss_max_hp
	bar.value = GameManager.boss_max_hp
	GameManager.boss_ended.connect(_boss_killed)

func _boss_killed():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	bar.value = GameManager.boss_hp
