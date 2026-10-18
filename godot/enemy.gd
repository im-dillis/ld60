extends CharacterBody2D

var city
var destination: Vector2 = Vector2(0,0)
var speed: float = 10
var movement_cooldown: float = 0.5
var health: float = 10 :
	set(value):
		if health != value:
			health = value
			print(str(self.name) + " took damage")
			if health <= 0:
				death()

var damage: float = 10

signal enemy_death(enemy_path: String)
signal moved_closer(node: Node, distance: float)
var last_distance: float = 1337

func _ready() -> void:
	await get_tree().create_timer(randf_range(0, movement_cooldown)).timeout
	_move_to(city)

func _move_to(target: Node):
	velocity = position.direction_to(destination) * (speed * 60)
	if (position.distance_to(destination)) > 50:
		last_distance = position.distance_to(destination)
		if move_and_slide():
			if get_last_slide_collision().get_collider() == city:
				var cc = get_node("/root/UiController/CardController")
				cc.current_health -= damage
		emit_signal("moved_closer", self, position.distance_to(destination))
	await get_tree().create_timer(movement_cooldown).timeout
	if city != null: _move_to(city)

func death():
	emit_signal("enemy_death", get_path())
	queue_free()
