extends CharacterBody2D

var destination: Vector2 = Vector2(0,0)
var speed: float = 20
var health: float = 10

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(destination) * speed
	if position.distance_to(destination) > 10:
		move_and_slide()
