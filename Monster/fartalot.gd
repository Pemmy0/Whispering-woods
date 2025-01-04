extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var player: CharacterBody2D

var speed = 20.0
var max_speed = 20
var direction : float
var player_distance

func _ready():
	ObjectLibrary.dont_move_you_donkey = true
	
func _physics_process(delta):
	player_distance = player.global_position - global_position
	
	movement(delta)
	animation_control(direction)

	move_and_slide()
	
func movement(delta):
	if ObjectLibrary.dont_move_you_donkey:
		return
	if player.position.x > position.x:
		direction = 1
	elif player.position.x < position.x:
		direction = -1
		
	if player_distance.length() > 10:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if speed > 0:speed += delta * 15
	
func animation_control(direction):
	if velocity.x != 0:
		animated_sprite_2d.play("Run")
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true

func _on_hurt_box_area_entered(area):
	speed = 0
	
func _on_hurt_box_area_exited(area):
	speed = max_speed
	
func _on_hurt_box_body_entered(body):
	Transition.fade_out(0.2)
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/scene_1.tscn")
