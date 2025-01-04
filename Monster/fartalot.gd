extends CharacterBody2D

@export var player: CharacterBody2D
@export var sfx_wet: AudioStream

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var monster_noise = $MonsterNoise

var speed = 20.0
var max_speed = 20
var direction : float
var player_distance

var footstep_frames: Array = [0, 4]

func _ready():
	ObjectLibrary.dont_move_you_donkey = true
	monster_noise.play()
	
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
	$AudioStreamPlayer2.play()
	Transition.fade_out(1)
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/scene_1.tscn")

func load_sfx(sfx_to_load):
	if audio_stream_player.stream != sfx_to_load:
		audio_stream_player.stop()
		audio_stream_player.stream = sfx_to_load

func _on_animated_sprite_2d_frame_changed():
	if animated_sprite_2d.animation == "Idle":
		return
		
	load_sfx(sfx_wet)
	audio_stream_player.volume_db = -3
	if animated_sprite_2d.frame in footstep_frames: 
		audio_stream_player.pitch_scale += randf_range(-0.2, 0.2)
		audio_stream_player.volume_db = 2
		audio_stream_player.play()
