extends Area2D

@export var drago: CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("default")

func _on_area_entered(area):
	ObjectLibrary.has_key = true
	print("grabbed")
	$AnimatedSprite2D.hide()
	queue_free()
