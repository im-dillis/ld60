extends Node

const ENEMY = preload("uid://dhxkvefobi744")
var enemy_spawn_location: PathFollow2D

var wave: int = 0;
var enemies: Array = []

func startGame():
	print("Starting game")
	enemy_spawn_location = get_node("/root/Game/Camera2D/EnemyPath/EnemySpawnLocation")
	waveBreak()

func waveBreak():
	var time: float = 10
	print("Waiting for wave, " + str(time) + " seconds")
	await get_tree().create_timer(time).timeout
	waveStart()

func waveStart():
	wave = wave + 1
	print("wave " + str(wave) + " starting")
	var wave_count: int = wave * 2
	for wc in wave_count:
		enemy_spawn_location.progress_ratio = randf()
		var new_enemy = ENEMY.instantiate()
		new_enemy.position = enemy_spawn_location.position
		add_child(new_enemy)
		print("Spawning new enemy at " + str(new_enemy.position))
		enemies.append(new_enemy)

func waveEnd():
	pass
