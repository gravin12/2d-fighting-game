extends KinematicBody2D
var velocity = Vector2(0,0)
export var basejump = 1
var jump = 1
const SPEED = 450
const JUMPFORCE = -1100
const GRAVITY = 40
var state_machine
var direction
export var health = 100

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
func _physics_process(delta): # movement
	if health > 0:
		if Input.is_action_pressed("right"): #move right
			velocity.x = SPEED
			direction = 1
			if is_on_floor():
				state_machine.travel("runR")
		if Input.is_action_just_released("right"):
			state_machine.travel("idle")
		if Input.is_action_pressed("left"): #move left
			velocity.x = -SPEED
			direction = 0
			if is_on_floor():
				state_machine.travel("runL")
		if Input.is_action_just_released("left"):
			state_machine.travel("idle")
			#move left
			
		if Input.is_action_just_pressed("jump") and jump > 0: #jump
			velocity.y = JUMPFORCE
			jump += -1
		if is_on_floor() or is_on_wall():
			jump = basejump # jump replenish
		
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.y = velocity.y + GRAVITY	
		velocity.x = lerp(velocity.x,0,0.2)
		
		if Input.is_action_just_pressed("atack"):
			if direction == 1 or Input.is_action_pressed("right"):
				state_machine.travel("atackR")
			if direction == 0 or Input.is_action_pressed("left"):
				state_machine.travel("atackL")

func gravity_calculations():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY	
	velocity.x = lerp(velocity.x,0,0.2)


signal hit_player

func _on_swordhit_body_entered(body):
	if body.name.begins_with("Player"):
		emit_signal("hit_player")



func _on_Player2_hit_player():
	health -= 10
	print("hit")
	if health <= 0:
		state_machine.travel("die")
