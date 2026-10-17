extends VBoxContainer

var all_cards: Dictionary
var unlocked_cards: Dictionary
var owned_cards: Dictionary
var active_cards: Dictionary:
	set(value):
		for ac in active_cards:
			ac.is_active = false
		active_cards = value
		calc_modifiers()

@export var stats: Dictionary = {
		max_health = 100,
		current_health = 100,
		base_health = 100,
		score = 0
	}

@export var global_modifiers: Dictionary[String, float] = {
	health_modifier = 1,
	bonus_health = 0,
	damage_modifier = 1,
	attack_speed_modifier = 1,
	cooldown_modifier = 1,
	effect_length_modifier = 1,
	effect_modifier = 1,
	projectile_count_modifier = 1,
	projectile_speed_modifier = 1,
	range_modifier = 1
}

func _init() -> void:
	calc_modifiers()

func calc_modifiers():
	global_modifiers = {
		health_modifier = 1,
		bonus_health = 0,
		damage_modifier = 1,
		attack_speed_modifier = 1,
		cooldown_modifier = 1,
		effect_length_modifier = 1,
		effect_modifier = 1,
		projectile_count_modifier = 1,
		projectile_speed_modifier = 1,
		range_modifier = 1
	}
	for ac in active_cards:
		ac.is_active = true
		global_modifiers.set("health_modifier", (global_modifiers.get("health_modifier") + ac.modifiers.get("health_modifier")))
		global_modifiers.set("bonus_health", (global_modifiers.get("bonus_health") + ac.modifiers.get("bonus_health")))
		global_modifiers.set("damage_modifier", (global_modifiers.get("damage_modifier") + ac.modifiers.get("damage_modifier")))
		global_modifiers.set("attack_speed_modifier", (global_modifiers.get("attack_speed_modifier") + ac.modifiers.get("attack_speed_modifier")))
		global_modifiers.set("cooldown_modifier", (global_modifiers.get("cooldown_modifier") + ac.modifiers.get("cooldown_modifier")))
		global_modifiers.set("effect_length_modifier", (global_modifiers.get("effect_length_modifier") + ac.modifiers.get("effect_length_modifier")))
		global_modifiers.set("effect_modifier", (global_modifiers.get("effect_modifier") + ac.modifiers.get("effect_modifier")))
		global_modifiers.set("projectile_count_modifier", (global_modifiers.get("projectile_count_modifier") + ac.modifiers.get("projectile_count_modifier")))
		global_modifiers.set("projectile_speed_modifier", (global_modifiers.get("projectile_speed_modifier") + ac.modifiers.get("projectile_speed_modifier")))
		global_modifiers.set("range_modifier", (global_modifiers.get("range_modifier") + ac.modifiers.get("range_modifier")))
		global_modifiers.set("bonus_health", (global_modifiers.get("bonus_health") + ac.modifiers.get("bonus_health")))
	stats.set("max_health", ((stats.get("base_health") + global_modifiers.get("bonus_health")) * global_modifiers.get("health_modifier")))
