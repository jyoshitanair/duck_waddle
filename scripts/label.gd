extends Label
var score= 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score += delta
	Manager.score = int(score)
	text = "Score %d"%score
