extends CharacterBody2D

@onready var eyes_sprite = $EyesSprite
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var flashlight = $PointLight2D
@onready var stamina_bar = $CanvasLayer/StaminaBatteryBar/StaminaBar
@onready var battery_bar = $CanvasLayer/StaminaBatteryBar/BatteryBar
@onready var flash_cols = $HitBox/CollisionPolygon2D

var speed = 25
var stamina_max = 50
var stamina = stamina_max
var battery_max = 100
var battery = battery_max
var currentDir = 1
var movement_animation: String
var cant_run = false
var cant_flash = false
var tickle = 1
var babayaga = 0
var move_allowed = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	movement_animation = "Walk"
	flashlight.visible = false
	$CanvasLayer.hide()
	
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction: int = 0
	
	if move_allowed:
		direction = Input.get_axis("Left", "Right")
	
	movement(direction)
	auto_move(babayaga)
	move_and_slide()
	
	animation_control(direction)
	
	$InteractBox/CollisionShape2D.disabled = !(Input.is_action_just_pressed("Interact"))
	
	if !EnvironmentControl.can_flashlight:
		return
	flashlight_control()
	bar_deplete(delta)
	
	#flicker
	if battery <= 15 && battery > 0:
		var random = randi_range(0,3)
		if random == 1:
			flashlight.enabled = !flashlight.enabled
	if battery > 15:
		flashlight.enabled = true

func movement(direction):
	if !move_allowed:
		return
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
		
func progress_bar_control():
	stamina_bar.value = stamina
	stamina_bar.max_value = stamina_max
	
	battery_bar.value = battery
	battery_bar.max_value = battery_max
	
	if cant_run:
		stamina_bar.modulate = Color(255,0,0)
		$CanvasLayer/StaminaBatteryBar/Stamina.modulate = Color(255,0,0)
	else:
		stamina_bar.modulate = Color(255,255,255)
		$CanvasLayer/StaminaBatteryBar/Stamina.modulate = Color(255,255,255)
		
	if cant_flash:
		battery_bar.modulate = Color(255,0,0)
		$CanvasLayer/StaminaBatteryBar/Battery.modulate = Color(255,0,0)
	else:
		battery_bar.modulate = Color(255,255,255)
		$CanvasLayer/StaminaBatteryBar/Battery.modulate = Color(255,255,255)
		
func bar_deplete(delta):
	if stamina < 0:
		stamina = 0
		cant_run = true
	elif stamina < stamina_max:
		stamina += delta * 10
	elif stamina > stamina_max:
		stamina = stamina_max
		cant_run = false
		
	if speed == 50:
		stamina -= delta * 30
		
	if battery < 0:
		battery = 0
		cant_flash = true
	elif battery < battery_max:
		battery += delta * 4
	elif battery > battery_max:
		battery = battery_max
		cant_flash = false
		
	if !flash_cols.disabled:
		battery -= delta * 20 * tickle
		
func animation_control(direction):
	if direction != 0:
		animated_sprite_2d.play(movement_animation)
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
	
	if direction == 1 || babayaga == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1 || babayaga == -1:
		animated_sprite_2d.flip_h = true
		
func flashlight_control():
	flash_cols.disabled = !(flashlight.visible)
	
	if Input.is_action_pressed("Flash") && !cant_flash:
		flashlight.visible = true
	elif Input.is_action_just_pressed("Flash") && cant_flash:
		battery += randi_range(1,5)
		flashlight.visible = false
	else:
		flashlight.visible = false
		
	if Input.is_action_just_pressed("Big Flash"):
		tickle = 2
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(flashlight, "scale", Vector2(0.231, 0.5), 0.2)
		tween.tween_property(flashlight, "energy", 2, 0.2)
	elif Input.is_action_just_released("Big Flash"):
		tickle = 1
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(true)
		tween.tween_property(flashlight, "scale", Vector2(0.231, 0.231), 0.2)
		tween.tween_property(flashlight, "energy", 1, 0.2)
	
	var mousePos = get_local_mouse_position()
	var clamp
	if currentDir > 0:
		clamp = clampi(mousePos.x, 100, 999999)
	else:
		clamp = clampi(mousePos.x, -999999, -100)
	var angle = atan2(mousePos.y, clamp)
	flashlight.rotation = angle
	flash_cols.rotation = angle
	
	if battery <= 50 && battery > 0:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(flashlight, "energy", 0.5, 0.5)
	else:
		return
	
func _flip_light():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	flashlight.scale.x = 0
	tween.tween_property(flashlight, "scale", Vector2(0.231, 0.231), 0.2)

func auto_move(babayaga):
	if !move_allowed:
		velocity.x = babayaga * speed
