extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var speed = 25
var movement_animation: String

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	movement_animation = "Walk"
	
	movement(direction)
	animation_control(direction)
	
	move_and_slide()

func movement(direction):
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_pressed("Run"):
		speed = 50
		movement_animation = "Run"
	else:
		movement_animation = "Walk"
		speed = 25
		
func animation_control(direction):
	if direction != 0: 
		animated_sprite_2d.play(movement_animation)
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true
