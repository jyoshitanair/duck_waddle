extends Node2D
var loaded = false
@onready var line_edit: LineEdit = $LineEdit
@onready var button: Button = $Button
@onready var fail: Label = $fail
@onready var timer: Timer = $Timer
func _ready() -> void:
	await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	loaded = true 
func _on_button_pressed() -> void:
	button.disabled = true
	button.text = "hang on..."
	if not loaded:
		return
	if check_name():
		fail.show()
		timer.start()
		button.disabled = false
		button.text = "SUBMIT"
	else:
		Manager.player_name = line_edit.text
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		Manager.first = true 
func check_name()-> bool:
	for score_data in SilentWolf.Scores.scores:
			if score_data["player_name"].strip_edges().to_lower() ==  line_edit.text.strip_edges().to_lower():
				return true
	return false

func _on_timer_timeout() -> void:
	fail.hide()
