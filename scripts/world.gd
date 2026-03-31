extends Node3D
var speed = 300.0
var preloaded_file = preload("res://scenes/world.tscn")
var player
@onready var spawn_timer: Timer = $spawn_timer
func _ready() -> void:
	spawn_timer.wait_time = (3620/speed) -6.0
	spawn_timer.start()
	call_deferred("_get_player")
	if Manager.first:
		Manager.first = false
		Manager.call_deferred("_find_log")
	call_deferred("spawn_log")
func _process(delta: float) -> void:
	if player ==null:
		return
	position.z += speed*delta
	if global_position.z > (player.global_position.z +7000):
		queue_free()
func _on_spawn_timer_timeout() -> void:
	var new_road = preloaded_file.instantiate()
	get_tree().current_scene.add_child(new_road)
	var spawn_z = self.global_position.z - 3620
	new_road.global_position = Vector3(self.global_position.x,self.global_position.y, spawn_z )
	Manager.cur_body = new_road
	spawn_timer.stop()
func spawn_log() -> void:
	Manager.cur_body = self
	Manager.emit_signal("spawn_objects",Manager.cur_body)
func _get_player() -> void: 
	player = get_tree().get_first_node_in_group("player")
	
