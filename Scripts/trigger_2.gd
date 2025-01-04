extends Area2D

@onready var fartalot = $"../Fartalot"

func _on_area_entered(area):
	ObjectLibrary.dont_move_you_donkey = false
	fartalot.speed = 0
	fartalot.max_speed = 0
	fartalot.velocity.x = move_toward(fartalot.velocity.x, 0, fartalot.speed)
