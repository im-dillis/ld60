extends VBoxContainer

var all_cards: Dictionary
var unlocked_cards: Dictionary
var owned_cards: Dictionary
var active_cards: Dictionary:
	set(value):
		for ac in active_cards:
			ac.is_active = false
		active_cards = value
		calc_stats()

@export var stats: Dictionary = {
		health = 100,
		health_modifier = 1,
		attack_speed_modifier = 1,
		cooldown_modifer = 1,
		projectile_count_modifer = 1,
		projectile_speed_modifer = 1,
		range_modifier = 1,
		damage_modifer = 1,
		effect_length_modifer = 1
	}

func _init() -> void:
	calc_stats()

func calc_stats():
	stats = {
		health = 100,
		health_modifier = 1,
		attack_speed_modifier = 1,
		cooldown_modifer = 1,
		projectile_count_modifer = 1,
		projectile_speed_modifer = 1,
		range_modifier = 1,
		damage_modifer = 1,
		effect_length_modifer = 1
	}
	for ac in active_cards:
		stats.health += ac.health
		stats.health_modifier += ac.health_modifer
		stats.attack_speed_modifier += ac.attack_speed_modifer
		stats.cooldown_modifier += ac.cooldown_modifer
		stats.projectile_count_modifer += ac.project_count_modifer
		stats.range_modifier += ac.range_modifer
		stats.damage_modifer += ac.damage_modifer
		stats.effect_length_modifer += ac.effect_length_modifer
		ac.is_active = true
