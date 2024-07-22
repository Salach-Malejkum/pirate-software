class_name Enemy

extends CharacterBody2D

var player_node : Player
const SPEED : int = 20

var _damage_sources = []
var _current_hp : float = 30.0

func _physics_process(delta):
	if player_node == null:
		player_node = get_tree().get_first_node_in_group("Player")
	else:
		velocity = self.global_position.direction_to(player_node.global_position) * SPEED
		if self.global_position.distance_to(player_node.global_position) > 10:
			move_and_slide()
			look_at(player_node.global_position)
	
	_current_hp -= delta * 30 * _damage_sources.size()
	
	if _current_hp <= 0.0:
		queue_free()


func add_dmg_source(src):
	if src not in self._damage_sources:
		self._damage_sources.append(src)


func del_dmg_source(src):
	if is_instance_valid(src):
		self._damage_sources.erase(src)
