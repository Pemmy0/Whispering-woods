extends Node2D

@export var drago: CharacterBody2D
var direction

@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	EnvironmentControl.can_flashlight = true
	ObjectLibrary.is_raining = true
	$Fartabunch.play("Idle")
	audio_stream_player.play()
	
func _process(delta):
	if drago.position.x > $Fartabunch.position.x:
		direction = 1
	elif drago.position.x < $Fartabunch.position.x:
		direction = -1
		
	if direction == 1:
		$Fartabunch.flip_h = true
	elif direction == -1:
		$Fartabunch.flip_h = false
