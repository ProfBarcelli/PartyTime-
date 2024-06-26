extends CharacterBody2D

class_name Giocatore

const g = 9.81
var health = 100
var n_salti = 0 
var max_salti = 2
var dir_sx = false
var damaged = false
var status
var dash
var dashTimer = 0
var dashCooldown = 1
var dashLoadTime = 0.5 
var dashLoaded = true

@export var player:Strider_K = null


func find_animation():
	if dash:
		if dir_sx :
			status=11 #dash sx
		else:
			status=11 #dash dx
	elif damaged:
		if dir_sx :
			status=-1  #hurt
		else:
			status=0
	elif velocity.y !=0:
		if velocity.y < 0:
			if dir_sx :
				status=1 #jump_left
			else:
				status=2 #jump_right
		elif velocity.y > 0 && dir_sx:
			status=3 #fall_left
		else:
			status=4 #fall_right
	elif abs(velocity.x) < 5 && velocity.y == 0:
		if dir_sx :
			status=5 #idle_left
		else:
			status=6 #idle_right
	elif abs(velocity.x) > 5 && abs(velocity.x) < 500 && velocity.y == 0 :
		if dir_sx:
			status=7 #walk_left
		else:
			status=8 #walk_right
	elif abs(velocity.x) > 500 && velocity.y == 0 :
		if dir_sx:
			status=9 #run_left
		else:
			status=10 #run_right
func play_Animation():
	match status:
		-1:
			%Animation.play("Hurt_Left")
		0:
			%Animation.play("Hurt_Right")
		1:
			%Animation.play("Jump_Left")
		2:
			%Animation.play("Jump_Right")
		3:
			%Animation.play("Fall_Left")
		4:
			%Animation.play("Fall_Right")
		5:
			%Animation.play("Idle_Left")
		6:
			%Animation.play("Idle_Right")
		7:
			%Animation.play("Walk_Left")
		8:
			%Animation.play("Walk_Right")
		9:
			%Animation.play("Run_Left")
		10:
			%Animation.play("Run_Right")
		11:
			%Animation.play("Dash")
	damaged=false
	dash=false


func _physics_process(delta):
	var d = Vector2()
	if Input.is_action_pressed("dash"):
		if not dashLoaded:
			dashTimer += delta
			if dashTimer >= dashLoadTime:
				dashLoaded = true
		if dashLoaded:
			if Input.is_action_pressed("dash") and is_on_cooldown():
				perform_dash()
		if dashLoaded and is_on_cooldown():
			dashTimer += delta
			if dashTimer >= dashCooldown:
				dashTimer = 0
				dashLoaded = false
	if Input.is_action_pressed("move_left"):
		d.x = -1
	if Input.is_action_pressed("move_right"):
		d.x = 1

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
	find_animation()
	play_Animation()
	move_and_slide()
	
func is_on_cooldown():
	return dashTimer < dashCooldown

func perform_dash():
	if dir_sx:
		velocity.x = -10000
	else:
		velocity.x = 10000
	dash = true
	dashLoaded = false
	dashTimer = 0

func take_damage():
	print("took damage")
	health -=1
	damaged = true
	if health == 0:
		queue_free()

func player_damage():
	if %Area2D.overlaps_body() > 0:
		take_damage()

