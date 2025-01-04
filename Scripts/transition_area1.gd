extends Area2D

func _on_body_entered(body):
	Transition.fade_out(1)
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/scene_1.tscn")
