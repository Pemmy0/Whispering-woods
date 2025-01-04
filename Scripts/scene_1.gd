extends Node2D

func _ready():
	EnvironmentControl.can_flashlight = true
	$Fartabunch.play("Idle")
