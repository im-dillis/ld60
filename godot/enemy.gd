extends CharacterBody2D

var destination: Vector2 = Vector2(0,0)
var speed: float = 20
var health: float = 10 :
	set(value):
		if health != value:
			health = value
			print(str(self.name) + " took damage")
			if health <= 0:
				death()

signal enemy_death(enemy_path: String)
signal moved_closer(node: Node, distance: float)

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(destination) * speed
	if position.distance_to(destination) > 10:
		move_and_slide()
		emit_signal("moved_closer", self, position.distance_to(destination))

func death():
	emit_signal("enemy_death", get_path())
	queue_free()
