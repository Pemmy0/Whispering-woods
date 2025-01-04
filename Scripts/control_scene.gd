extends Control

var hit_once = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("Interact") && !hit_once:
		hit_once = true
		Transition.fade_out(2)
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/intro_scene.tscn")
		
