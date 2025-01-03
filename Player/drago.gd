extends CharacterBody2D

@onready var eyes_sprite = $EyesSprite
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var flashlight = $PointLight2D

var speed = 25
var stamina = 50
var currentDir = 1
var movement_animation: String
var cant_run = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	movement_animation = "Walk"
	flashlight.visible = false
	
func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	
	movement(direction)
	animation_control(direction)
	flashlight_control()
	
	if stamina < 0:
		stamina = 0
		cant_run = true
	elif stamina < 50:
		stamina += delta * 10
	elif stamina > 50:
		stamina = 50
		cant_run = false
		
	if speed == 50:
		stamina -= delta * 20
	
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
		if !cant_run:
			movement_animation = "Run"
			speed = 50
		else:
			movement_animation = "Walk"
			speed = 25
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
		
func flashlight_control():
	if !EnvironmentControl.can_flashlight:
		return
	$PointLight2D/HitBox/CollisionPolygon2D.disabled = !(Input.is_action_pressed("Flash"))
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
