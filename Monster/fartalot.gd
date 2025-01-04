extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var player: CharacterBody2D

var speed = 10.0
var direction : float
var player_distance
	
func _physics_process(delta):
	player_distance = player.global_position - global_position
	
	movement(delta)
	animation_control(direction)

	move_and_slide()
	
func movement(delta):
	if player.position.x > position.x:
		direction = 1
	elif player.position.x < position.x:
		direction = -1
		
	if player_distance.length() > 25:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if speed > 0:speed += delta * 15
	
func animation_control(direction):
	if velocity.x != 0:
		animated_sprite_2d.play("Run")
	elif velocity.x == 0:
		animated_sprite_2d.play("Idle")
	
	if direction == 1:
		animated_sprite_2d.flip_h = false
	elif direction == -1:
		animated_sprite_2d.flip_h = true

func _on_hurt_box_area_entered(area):
	speed = 0
	
func _on_hurt_box_area_exited(area):
	speed = 10
