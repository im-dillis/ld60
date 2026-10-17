class_name Card
extends Control

var cc
@export var level = 1
@export var name_descriptive: String
@export_enum("Weapon", "Modifier") var card_type
@export_multiline var description: String
@export var is_active = false

@export_enum("health",
	"damage",
	"cooldown speed",
	"range modifier",
	"projectile count",
	"projectile speed",
	"health modifier",
	"health bonus",
	"damage modifier",
	"attack speed modifier",
	"cooldown modifier",
	"effect length modifier",
	) var effect_stat: String

@export var base_stats: Dictionary[String, float] = {
	damage = 0.0,
	effect_modifier = 0.0,
	effect_length = 0.0,
	attack_speed = 0.0,
	cooldown_speed = 0.0,
	range = 0.0,
	projectile_count = 0.0,
	projectile_speed = 0.0
}

var active_stats: Dictionary[String, float] = {
	damage = 0.0,
	effect_modifier = 0.0,
	effect_length = 0.0,
	attack_speed = 0.0,
	cooldown_speed = 0.0,
	range = 0.0,
	projectile_count = 0.0,
	projectile_speed = 0.0
}

@export var modifiers: Dictionary[String, float] = {
	health_modifier = 0,
	bonus_health = 0,
	damage_modifier = 0,
	attack_speed_modifier = 0,
	cooldown_modifier = 0,
	effect_length_modifier = 0,
	effect_modifier = 0,
	projectile_count_modifier = 0,
	projectile_speed_modifier = 0,
	range_modifier = 0
}

func _ready() -> void:
	cc = get_parent()
	_cooldown()
	_update_description()

func _update_description():
	if effect_stat != null:
		description = name_descriptive + " increases your " +  effect_stat + " by " + str(active_stats.get("effect_modifier")) + " times for " + str(active_stats.get("effect_length")) + " seconds every " #+ str((active_stats.get("effect_length") + active_stats.get("cooldown_speed)"))) + " seconds"

func _update_current_stats():
	for activestats in active_stats:
		match activestats:
			"damage":
				active_stats.set("damage", (base_stats.get("damage") * cc.global_modifiers.get("damage_modifier")))
			"effect_modifier":
				active_stats.set("effect_modifier", (base_stats.get("effect_modifier") * cc.global_modifiers.get("effect_modifier")))
			"effect_length":
				active_stats.set("effect_length", (base_stats.get("effect_length") * cc.global_modifiers.get("effect_length_modifier")))
			"attack_speed":
				active_stats.set("attack_speed", (base_stats.get("attack_speed") * cc.global_modifiers.get("attack_speed_modifier")))
			"cooldown_speed":
				active_stats.set("cooldown_speed", (base_stats.get("cooldown_speed") * cc.global_modifiers.get("cooldown_modifier")))
			"range":
				active_stats.set("range", (base_stats.get("range") * cc.global_modifiers.get("range_modifier")))
			"projectile_count":
				active_stats.set("projectile_count", (base_stats.get("projectile_count") * cc.global_modifiers.get("projectile_count_modifier")))
			"projectile_speed":
				active_stats.set("projectile_speed", (base_stats.get("projectile_speed") * cc.global_modifiers.get("projectile_speed_modifier")))
	
func _cooldown():
	_update_current_stats()
	var cooldown
	match card_type:
		0: # Weapon
			var atk_mod = 1
			if get_parent().stats.get("attack_speed_modifier") != null:
				atk_mod = get_parent().stats.get("attack_speed_modifier")
			cooldown = active_stats.get("attack_speed") * atk_mod
			print(str(self.name) + " Waiting " + str(cooldown) + " seconds to attack")
			await get_tree().create_timer(cooldown).timeout
			if WaveController.closest_enemy != null && WaveController.closest_enemy.position.distance_to(WaveController.city.position) <= active_stats.get("range"):
				_attack()
				return
		1: # modifier
			var cool_mod = 1
			if get_parent().stats.get("cooldown_modifier") != null:
				cool_mod = get_parent().stats.get("cooldown_modifier")
			cooldown = active_stats.get("cooldown_speed") * cool_mod
			print(str(self.name) + " Waiting " + str(cooldown) + " seconds to apply effect")
			await get_tree().create_timer(cooldown).timeout
			_effect()
			return
	_cooldown()

func _attack():
	_update_current_stats()
	var dmg_mod = 1
	if get_parent().stats.get("damage_modifier") != null:
		dmg_mod = get_parent().stats.get("damage_modifier")
	var dmg: float = active_stats.get("damage") * dmg_mod
	WaveController.closest_enemy.health -= dmg
	_cooldown()

func _effect():
	_update_current_stats()
	print(effect_stat)
	var modifier: String = ""
	var effect_modifier = active_stats.get("effect_modifier")
	var effect_length = active_stats.get("effect_length")
	match effect_stat:
		"damage":
			modifier = "damage_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"cooldown speed":
			modifier = "cooldown_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
		"range modifier":
			modifier = "range_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"projectile count":
			modifier = "projectile_count_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"projectile speed":
			modifier = "projectile_speed_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"health modifier":
			modifier = "health_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"health bonus":
			modifier = "bonus_health"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"damage modifier":
			modifier = "damage_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
		"attack speed modifier":
			modifier = "attack_speed_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
		"cooldown modifier":
			modifier = "cooldown_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
		"effect length modifier":
			modifier = "effect_length_modifier"
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) + effect_modifier)
			await get_tree().create_timer(effect_length).timeout
			cc.global_modifiers.set(modifier, cc.global_modifiers.get(modifier) - effect_modifier)
	_cooldown()
