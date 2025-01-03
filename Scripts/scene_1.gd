extends Node2D

func _ready():
	EnvironmentControl.can_flashlight = true
	$Monster.play("Idle")
