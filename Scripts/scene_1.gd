extends Node2D

@export var drago: CharacterBody2D
var direction

func _ready():
	EnvironmentControl.can_flashlight = true
	$Fartabunch.play("Idle")
	
func _process(delta):
	if drago.position.x > $Fartabunch.position.x:
		direction = 1
	elif drago.position.x < $Fartabunch.position.x:
		direction = -1
		
	if direction == 1:
		$Fartabunch.flip_h = true
	elif direction == -1:
		$Fartabunch.flip_h = false
