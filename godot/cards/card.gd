class_name Card
extends Control

@export var level = 1
@export var name_descriptive: String
@export_enum("Weapon", "Modifier") var card_type
@export_multiline var description: String
@export var is_active = false

@export var health = 0
@export var damage = 0
@export var cooldown_speed = 1
@export_enum("health",
	"damage",
	"cooldown speed",
	"range",
	"projectile count",
	"projectile speed",
	"health modifier",
	"damage modifier",
	"attack speed modifier",
	"cooldown modifier",
	"effect length modifier",
	"project count modifier",
	"range modifier"
	) var effect_stat: String

@export var effect_modifier: float = 0
@export var effect_length: float = 0
@export var attack_speed: float = 0
@export var range: float = 0
@export var projectile_count: int = 0
@export var projectile_speed: float = 0

@export var health_modifier = 0
@export var damage_modifier = 0
@export var attack_speed_modifier = 0
@export var cooldown_modifier = 0
@export var effect_length_modifier = 0
@export var projectile_count_modifier = 0
@export var projectile_speed_modifier = 0
@export var range_modifier = 0


func _ready() -> void:
	_cooldown()
	_update_description()

func _update_description():
	if effect_stat != null:
		description = name_descriptive + " increases your " +  effect_stat + " by " + str(effect_modifier) + " times for " + str(effect_length) + " seconds every " + str((effect_length + cooldown_speed)) + " seconds"

func _cooldown():
	var cooldown
	match card_type:
		0: # Weapon
			var atk_mod = 1
			if get_parent().stats.get("attack_speed_modifier") != null:
				atk_mod = get_parent().stats.get("attack_speed_modifier")
			cooldown = attack_speed * atk_mod
			print(str(self.name) + " Waiting " + str(cooldown) + " seconds to attack")
			await get_tree().create_timer(cooldown).timeout
			if WaveController.closest_enemy != null && WaveController.closest_enemy.position.distance_to(WaveController.city.position) <= range:
				_attack()
				return
		1: # modifier
			var cool_mod = 1
			if get_parent().stats.get("cooldown_modifier") != null:
				cool_mod = get_parent().stats.get("cooldown_modifier")
			cooldown = cooldown_speed * cool_mod
			print(str(self.name) + " Waiting " + str(cooldown) + " seconds to apply effect")
			await get_tree().create_timer(cooldown).timeout
			_effect()
			return
	_cooldown()

func _attack():
	var dmg_mod = 1
	if get_parent().stats.get("damage_modifier") != null:
		dmg_mod = get_parent().stats.get("damage_modifier")
	var dmg: float = damage * dmg_mod
	WaveController.closest_enemy.health -= dmg
	_cooldown()

func _effect():
	var cc = get_parent()
	print(effect_stat)
	match effect_stat:
		"attack speed modifier":
			print(cc.stats.get("attack_speed_modifier"))
			cc.stats.set("attack_speed_modifier", cc.stats.get("attack_speed_modifier") + effect_modifier)
			print(cc.stats.get("attack_speed_modifier"))
			await get_tree().create_timer(effect_length).timeout
			cc.stats.set("attack_speed_modifier", cc.stats.get("attack_speed_modifier") - effect_modifier)
			print(cc.stats.get("attack_speed_modifier"))
	_cooldown()
