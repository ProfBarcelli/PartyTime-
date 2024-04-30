extends CharacterBody2D

class_name Giocatore

const g = 9.81
var health = 100
var n_salti = 0 
var max_salti = 2
var dir_sx = false
var damaged = false

@export var player:Strider_K = null
func play_Animation():
	if damaged:
		%Animation.play("Hurt")
		damaged= false
		return
	
	if Input.is_action_just_pressed("jump"):
		if dir_sx :
			%Animation.play("Jump_Left")
			return
		else :
			%Animation.play("Jump_Right")
			return
	if velocity.y >0:
		%Animation.play("Fall")
		return
	if abs(velocity.x) < 5 && velocity.y == 0 :
		if dir_sx :
			%Animation.play("Idle_Left")
			return
		else:
			%Animation.play("Idle_Right")
			return
	if abs(velocity.x) > 5 && abs(velocity.x) < 500 && velocity.y == 0 :
		if dir_sx:
			%Animation.play("Walk_Left")
			return
		else:
			%Animation.play("Walk_Right")
			return
	elif abs(velocity.x) > 500 && velocity.y == 0 :
		if dir_sx:
			%Animation.play("Run_Left")
			return
		else:
			%Animation.play("Run_Right")
			return


func _physics_process(delta):
	var d = Vector2()
	if Input.is_action_pressed("move_left"):
		d.x = -1
	if Input.is_action_pressed("move_right"):
		d.x = 1
	if Input.is_action_pressed("dash"):
		if dir_sx:
			var old_velocity = velocity
			velocity = Vector2(-1000,0)
			move_and_slide()
			velocity = old_velocity
		else:
			var old_velocity = velocity
			velocity = Vector2(1000,0)
			move_and_slide()
			velocity = old_velocity
	if d.length()==0:
		velocity.x *= 0.80
	else:
		var accel = d*200
		velocity += accel * delta
	if not is_on_floor():
		velocity.y += g*delta*100
	else:
		n_salti = 0
	if Input.is_action_just_pressed("jump") and n_salti<max_salti :
		velocity.y += -400
		n_salti += 1
	if velocity.x<-0.5:
		dir_sx = true
	if velocity.x>0.5:
		dir_sx = false
	play_Animation()
	move_and_slide()
	
	
func take_damage():
	print("took damage")
	health -=1
	damaged = true
	if health == 0:
		queue_free()

func player_damage():
	if %Area2D.overlaps_body() > 0:
		take_damage()
