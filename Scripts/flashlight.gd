extends Area2D

func _ready():
	$MarginContainer/Label.hide()

func _on_body_entered(body):
	$MarginContainer/Label.show()
	
func _on_area_entered(area):
	EnvironmentControl.can_flashlight = true
	$MarginContainer/Label.hide()
	queue_free()

func _on_body_exited(body):
	$MarginContainer/Label.hide()
