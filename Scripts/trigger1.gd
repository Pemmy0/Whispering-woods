extends Area2D

@onready var audio_stream_player_2 = $"../AudioStreamPlayer2"
@onready var audio_stream_player_3 = $"../AudioStreamPlayer3"

func _on_body_entered(body):
	ObjectLibrary.dont_move_you_donkey = false
	audio_stream_player_2.play()
	audio_stream_player_3.play()
