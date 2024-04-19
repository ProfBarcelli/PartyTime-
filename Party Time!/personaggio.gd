extends CharacterBody2D
const g = 9.81
var health = 100
var n_salti = 0 
var max_salti = 2
var dir_sx = false
func play_Animation():
	if abs(velocity.x) <5:
		if dir_sx:
			%Animation.play("Idle_Left")
		else:
			%Animation.play("Idle_Right")
	else:
		if dir_sx:
			%Animation.play("Walk_Right")
		else:
			%Animation.play("Walk_Right")
	if velocity.y >0:
		%Animation.play("Fall")


#ciao a tutti
func _physics_process(delta):
	var d = Vector2()
	if Input.is_action_pressed("move_left"):
		d.x = -1
	if Input.is_action_pressed("move_right"):
		d.x = 1
	if Input.is_action_pressed("dash"):
		var old_velocity = velocity
		velocity = Vector2(1000,0)
		move_and_slide()
		velocity = old_velocity
	if d.length()==0:
		velocity.x *= 0.95
	else:
		var accel = d*200
		velocity += accel * delta
	if not is_on_floor():
		velocity.y += g*delta*100
	else:
		n_salti = 0
	if Input.is_action_just_pressed("jump") and n_salti<max_salti :
		velocity.y += -300
		n_salti += 1
	if velocity.x<-0.5:
		dir_sx = true
	if velocity.x>0.5:
		dir_sx = false
	play_Animation()
	move_and_slide()
	
func take_damage():
	health -=1 
	%Animation.play("Hurt")
	
	if health == 0:
		queue_free()
func player_damage():
	if %Area2D.overlaps_body() > 0:
		take_damage()
