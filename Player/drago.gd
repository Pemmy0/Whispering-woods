extends CharacterBody2D

@onready var eyes_sprite = $EyesSprite
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var flashlight = $PointLight2D

var speed = 25
var currentDir = 1
var movement_animation: String

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	movement_animation = "Walk"
	flashlight.visible = false
	
func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	
	movement(direction)
	animation_control(direction)
	flashlight_control()
	
	move_and_slide()

func movement(direction):
	if direction:
		if direction != currentDir:
			_flip_light()
		currentDir = direction
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_pressed("Run"):
		speed = 50
		movement_animation = "Run"
	else:
		speed = 25
		movement_animation = "Walk"
		
func animation_control(direction):
	if direction != 0:
		animated_sprite_2d.play(movement_animation)
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true
		
func flashlight_control():
	if !EnvironmentControl.can_flashlight:
		return
	
	if Input.is_action_pressed("Flash"):
		flashlight.visible = true
	else:
		flashlight.visible = false
	
	var mousePos = get_local_mouse_position()
	var clamp
	if currentDir > 0:
		clamp = clampi(mousePos.x, 100, 999999)
	else:
		clamp = clampi(mousePos.x, -999999, -100)
	var angle = atan2(mousePos.y, clamp)
	flashlight.rotation = angle
	
func _flip_light():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	flashlight.scale.x = 0
	#flashlight.energy = 0
	tween.tween_property(flashlight, "scale", Vector2(0.231, 0.231), 0.2)
	#tween.tween_property(flashlight, "energy", 1, 0.1)
