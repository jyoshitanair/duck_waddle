extends Node3D
var speed = 300.0
var preloaded_file = preload("res://scenes/world.tscn")
@onready var queue_timer: Timer = $queue_timer
@onready var spawn_timer: Timer = $spawn_timer
func _ready() -> void:
	if Manager.first:
		Manager.first = false
		Manager.call_deferred("_find_log")
	call_deferred("spawn_log")
func _process(delta: float) -> void:
	position.z += speed*delta
func _on_queue_timer_timeout() -> void:
	queue_free()
func _on_spawn_timer_timeout() -> void:
	var new_road = preloaded_file.instantiate()
	new_road.name = "world!!"
	get_tree().current_scene.add_child(new_road)
	var spawn_z = self.global_transform.origin.z - 3600
	new_road.transform.origin = Vector3(self.global_position.x,self.global_position.y,spawn_z)
	queue_timer.start()
func spawn_log() -> void :
	Manager.cur_body = self
	Manager.emit_signal("spawn_objects",Manager.cur_body)
