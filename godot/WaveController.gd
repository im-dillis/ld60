extends Node

const ENEMY = preload("uid://dhxkvefobi744")
@onready var enemy_spawn_location: PathFollow2D = $Camera2D/EnemyPath/EnemySpawnLocation

var wave: int = 0;
var enemies: Array = []

func startGame():
	waveBreak()

func waveBreak():
	var time: float = 10
	await get_tree().create_timer(time).timeout
	waveStart()

func waveStart():
	wave = wave + 1
	var wave_count: int = wave * 2
	for wc in wave_count:
		enemy_spawn_location.progress_ratio = randf()
		var new_enemy = ENEMY.instantiate()
		new_enemy.position = enemy_spawn_location.position
		enemies.append(new_enemy)

func waveEnd():
	pass
