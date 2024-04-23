extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player:CharacterBody2D = null

const SPEED = 100.0

func _ready():
	get_node("/root/livello1/Enemy")
	

func _physics_process(delta):
	if player==null or player.global_position.distance_to(global_position)>250:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	if not is_on_floor():
		velocity.y += gravity * delta
		


	move_and_slide()
