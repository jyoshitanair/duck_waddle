extends CharacterBody3D
#-16,7,30
@onready var detection: Area3D = $detection
const SPEED = 100.0
const JUMP_VELOCITY = 40.5
var new_position:float = 10.0
var dead = false
func _ready() -> void:
	add_to_group("player")
	position.x = 7
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("left"):
		if new_position > -85:
			new_position -= 125.0
	if Input.is_action_just_pressed("right"):
		if new_position < 165:
			new_position += 125.0
	position.x = lerp(position.x,clamp(new_position,-85.0,165.0),6*delta)
	move_and_slide()
