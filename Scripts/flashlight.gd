extends Area2D

@onready var flash_pick = $"../FlashPick"

func _ready():
	$MarginContainer/Label.hide()

func _on_body_entered(body):
	$MarginContainer/Label.show()
	
func _on_area_entered(area):
	flash_pick.play()
	EnvironmentControl.can_flashlight = true
	$MarginContainer/Label.hide()
	queue_free()

func _on_body_exited(body):
	$MarginContainer/Label.hide()
