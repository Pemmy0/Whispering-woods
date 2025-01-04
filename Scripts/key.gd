extends Area2D

@export var drago: CharacterBody2D
@onready var audio_stream_player = $"../KeySFX"

func _ready():
	$AnimatedSprite2D.play("default")

func _on_area_entered(area):
	ObjectLibrary.has_key = true
	print("grabbed")
	$AnimatedSprite2D.hide()
	audio_stream_player.play()
	queue_free()
