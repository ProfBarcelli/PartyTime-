extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 300.0
const JUMP_VELOCITY = 400.0

func _ready():
	get_node("/root/livello1/Enemy")
	

##func _physics_process(delta):
	##var player = get_node("res://personaggio.tscn")
	##var direction = global_position.direction_to(player.global_position)
	##velocity = direction * SPEED
	##if not is_on_floor():
		##velocity.y += gravity * delta
		


	move_and_slide()
