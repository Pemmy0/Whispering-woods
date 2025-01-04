extends Area2D

@onready var door_sfx = $"../DoorSFX"

func _on_area_entered(area):
	if ObjectLibrary.has_key:
		door_sfx.play()
		ObjectLibrary.has_key = false
		Transition.fade_out(1)
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/scene_1.tscn")
	else:
		$"../AnimationPlayer".play("get em key")
