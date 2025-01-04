extends Area2D

func _on_area_entered(area):
	if ObjectLibrary.has_key:
		ObjectLibrary.has_key = false
		Transition.fade_out(1)
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/ending_screen.tscn")
	else:
		$"../AnimationPlayer".play("get em key")
