extends Area2D

@onready var monster_sounds = $"../MonsterSounds"

func _on_body_entered(body):
	monster_sounds.play()
