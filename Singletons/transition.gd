extends CanvasLayer

@onready var animation_player = $AnimationPlayer

signal on_transition_finished

func fade_out(time: float):
	animation_player.speed_scale = 1 / time
	animation_player.play("fade_out")

func fade_in(time: float):
	animation_player.speed_scale = 1 / time
	animation_player.play("fade_in")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		on_transition_finished.emit()
		fade_in(1)

func busy():
	return animation_player.is_playing()
