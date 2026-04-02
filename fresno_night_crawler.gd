extends CharacterBody2D

signal life_changed

signal died
var life = 3: set = set_life

@export var gravity = 750
@export var run_speed = 100
@export var jump_speed = -250

enum{IDLE, RUN, JUMP, HURT, DEAD}

var state = IDLE

func set_life(value):
	life = value
	life_changed.emit(life)
	if life <= 0:
		change_state(DEAD)

func ready():
	change_state(IDLE)
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			pass
		RUN:
			pass
		HURT:
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
#			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
		JUMP:
			pass
		DEAD:
			died.emit()
			#get_tree().change_scene_to_file("res://Intro.tscn")
			hide()
		
func get_input():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	if state == HURT:
		return
		
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_collider().is_in_group("Enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage()
				velocity.y = -200
			else:
				hurt()
		#if collision.get_collider().is_in_group("Enemies"):
			#hurt()
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	if position.y > 100:
		change_state(DEAD)

func reset(_position):
	life = 3
	position = _position
	show()
	change_state(IDLE)

func hurt():
	if state != HURT:
		change_state(HURT)
