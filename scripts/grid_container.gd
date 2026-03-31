extends GridContainer

var player_list_with_pos = []
var pos 
@onready var text: Label = $"../../text"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	await add_players_to_grid(player_list_with_pos)
	text.text = "You are %d%s place out of %d ducks. Quack. "%[pos,get_suffix(pos),SilentWolf.Scores.scores.size()]
func sort_players_and_add_position(player_list): 
	var position = 1
	for player in player_list:
		player["position"]= position
		position += 1
	return player_list
func add_players_to_grid(player_list)-> void: 
	var pos_vbox = VBoxContainer.new()
	var name_vbox = VBoxContainer.new()
	var score_vbox = VBoxContainer.new()
	#position
	for score_data in player_list_with_pos:
		var pos_label = Label.new()
		var name = score_data["player_name"]
		pos_label.text = str(score_data["position"])
		if name == Manager.player_name:
			pos = int(score_data["position"])
			pos_label.add_theme_color_override("font_color",Color.CRIMSON)
		pos_label.show()
		pos_vbox.add_child(pos_label)
	add_child(pos_vbox)
	#name
	for score_data in player_list_with_pos:
		var name_label = Label.new()
		var name = score_data["player_name"]
		name_label.text = str(name)
		if name == Manager.player_name:
			name_label.add_theme_color_override("font_color",Color.CRIMSON)	
		name_label.show()
		name_vbox.add_child(name_label)
	add_child(name_vbox)
	#score
	for score_data in player_list_with_pos:
		var score_label = Label.new()
		var name = score_data["player_name"]
		score_label.text = str(score_data["score"])
		if name == Manager.player_name:
			score_label.add_theme_color_override("font_color",Color.CRIMSON)
		score_label.show()
		score_vbox.add_child(score_label)
	add_child(score_vbox)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over_page.tscn")
func get_suffix(position)-> String: 
	if (position % 100) in [11,12,13]: #english irregulars...sigh
		return "th"
	else:
		match (position%10):
			1: return "st"
			2: return "nd"
			3: return "rd"
			_: return "th"
