extends CharacterBody2D

@onready var eyes_sprite = $EyesSprite
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var flashlight = $flashlight

var speed = 25
var currentDir = 1
var movement_animation: String

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	flashlight.visible = false

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	movement_animation = "Walk"
	
	movement(direction)
	animation_control(direction)
	flashlight_control()
	
	move_and_slide()

func movement(direction):
	if direction:
		currentDir = direction
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
		eyes_sprite.play(movement_animation)
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
		eyes_sprite.play("Idle")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
		eyes_sprite.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true
		eyes_sprite.flip_h = true
		
func flashlight_control():
	if Input.is_action_just_pressed("Flash"):
		flashlight.visible = !flashlight.visible
	
	var mousePos = get_local_mouse_position()
	var clamp
	if currentDir > 0:
		clamp = clampi(mousePos.x, 100, 999999)
	else:
		clamp = clampi(mousePos.x, -999999, -100)
	var angle = atan2(mousePos.y, clamp)
	flashlight.rotation = angle
