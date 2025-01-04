extends Node2D

@onready var audio_stream_player = $RainSFX

func _ready():
	ObjectLibrary.is_raining = true
	audio_stream_player.play()
