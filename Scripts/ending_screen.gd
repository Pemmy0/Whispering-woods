extends Control

func _ready():
	$AnimationPlayer.play("Start Anim")
	$AudioStreamPlayer.play()
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Start Anim":
		Transition.fade_out(2)
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/intro_scene.tscn")
