extends Node3D
@onready var timer: Timer = $Timer
var lane_number 
var previous_lane_number = null
var obstacle_number = 1
var file = preload("res://scenes/log.tscn")
var x_value = [-85,40,165]
var cur_road = null
var player
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	Manager.spawn_objects.connect(_on_load, CONNECT_ONE_SHOT)
func _on_timer_timeout() -> void:
	randomize()
	timer.wait_time = randf_range(0.5,1.0)
	if cur_road != null: 
		_on_load(Manager.cur_body)
func _on_load(body) -> void:
	if body == null:
		return
	randomize()
	if Manager.cur_body == body && self == Manager.cur_log:
		cur_road = body
		var mesh = body.get_node("road/MeshInstance3D")
		var bounds = mesh.get_aabb()
		var back= mesh.global_position.z + bounds.position.z
		var front = back + bounds.size.z
		var end_z = player.global_position.z - 500
		var start_z = min(back,front)
		if start_z >= end_z:
			return
		obstacle_number = randi_range(1,2)
		for i in range(obstacle_number):
			lane_number = randi_range(0,2)
			while lane_number == previous_lane_number:
				lane_number = randi_range(0,2)
			var new_x = x_value[lane_number]
			var final_z = 0
			var success = false
			for a in range(10):
				var test_z = randf_range(start_z,end_z)
				var test_but_global = Vector3(new_x,0,test_z)
				var is_blocked = false
				for log_spawned in body.get_children():
					if log_spawned is Node3D and log_spawned.global_position.distance_to(test_but_global)<300:
						is_blocked = true
						break
				if not is_blocked:
					final_z = test_z
					success = true
					break
			if success:
				previous_lane_number = lane_number
				var log_i = file.instantiate()
				Manager.cur_log = log_i 
				body.add_child(log_i)
				log_i.global_position = Vector3(new_x,0,final_z)
				log_i.rotation_degrees.y = randf_range(0,360)
	Manager.cur_log = self
func _on_diee_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not body.dead:
		body.dead = true
		SilentWolf.Scores.save_score(Manager.player_name, int(Manager.score)).sw_save_score_complete
		call_deferred("_change_scene")
func _change_scene() -> void: 
		if not is_inside_tree():
			return
		get_tree().change_scene_to_file("res://scenes/game_over_page.tscn")
