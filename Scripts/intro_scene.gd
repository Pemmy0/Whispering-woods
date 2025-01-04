extends Node2D

@onready var audio_stream_player = $AudioStreamPlayer
@onready var drago = $Drago

var only_press_once = false

func _ready():
	EnvironmentControl.can_flashlight = false
	ObjectLibrary.is_raining = false
	drago.move_allowed = false
	audio_stream_player.play()

func _physics_process(delta):
	if !drago.move_allowed:
		drago.animation_control(-1)
	
func _unhandled_input(event):
	if Input.is_anything_pressed() && !only_press_once:
		$AnimationPlayer.play("starting screen")
		drago.babayaga = -1
		only_press_once = true

func _on_stop_area_body_entered(body):
	drago.babayaga = 0
	drago.animation_control(0)
	drago.move_allowed = true
	%CollisionShape2D.set_deferred("disabled", false)
