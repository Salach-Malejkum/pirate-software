extends Camera2D


@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0
@export var shaking_length: float = 1.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var is_shaking: bool = false
var timer: Timer

signal shaking_stopped


func _ready():
	GameManager.shake_screen.connect(apply_shake)
	shaking_stopped.connect(stop_shaking)
	


func _process(delta: float):
	if !is_shaking:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()


func apply_shake() -> void:
	shake_strength = random_strength
	timer = Timer.new()
	timer.wait_time = shaking_length


func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, -shake_strength), rng.randf_range(-shake_strength, -shake_strength))


func stop_shaking() -> void:
	is_shaking = false
