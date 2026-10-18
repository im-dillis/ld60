class_name Card
extends Control

# UI Assets
@onready var main_h_box_container: HBoxContainer = $main_h_box_container
@onready var card_background: PanelContainer = $main_h_box_container/card_background
@onready var card_margins: MarginContainer = $main_h_box_container/card_background/card_margins
@onready var card_v_box_container: VBoxContainer = $main_h_box_container/card_background/card_margins/card_v_box_container
@onready var title_bar: HBoxContainer = $main_h_box_container/card_background/card_margins/card_v_box_container/title_bar
@onready var title_text: RichTextLabel = $main_h_box_container/card_background/card_margins/card_v_box_container/title_bar/title_text
@onready var title_seperator: VSeparator = $main_h_box_container/card_background/card_margins/card_v_box_container/title_bar/title_seperator
@onready var level_label: RichTextLabel = $main_h_box_container/card_background/card_margins/card_v_box_container/title_bar/level_label
@onready var level_background: Panel = $main_h_box_container/card_background/card_margins/card_v_box_container/title_bar/level_label/level_background
@onready var desc_container: HBoxContainer = $main_h_box_container/card_background/card_margins/card_v_box_container/desc_container
@onready var card_icon: TextureButton = $main_h_box_container/card_background/card_margins/card_v_box_container/desc_container/card_icon
@onready var card_desc: RichTextLabel = $main_h_box_container/card_background/card_margins/card_v_box_container/desc_container/card_desc
@onready var card_button: Button = $main_h_box_container/card_button


var expanded_size: Vector2 = Vector2(300, 100):
	set(value):
		expanded_size = value
		if is_expanded: _expand_card(true)
var collapsed_size: Vector2 = Vector2(175, 100):
	set(value):
		collapsed_size = value
		if !is_expanded: _expand_card(false)

var cc
@export var level = 1:
	set(value):
		level = value
		if level_label != null: level_label.text = str(level)
@export var name_descriptive: String:
	set(value):
		name_descriptive = value
		if title_text != null: title_text.text = name_descriptive
@export_enum("Weapon", "Modifier") var card_type: String
@export var icon: Texture2D:
	set(value):
		icon = value
		card_icon.texture_normal = icon
		card_icon.texture_disabled = icon
@export_multiline var blurb: String:
	set(value):
		blurb = value
		_update_desc()
@export_multiline var description: String:
	set(value):
		description = value
		_update_desc()
@export var is_active = false:
	set(value):
		is_active = value
		if is_active: _cooldown()
@export var is_expanded = true:
	set(value):
		is_expanded = value
		_expand_card(is_expanded)

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
	_update_card()

func _update_card():
	level = level
	name_descriptive = name_descriptive
	await _update_current_stats()
	_update_desc()

func _update_desc():
	if is_expanded && card_desc != null:
		match card_type:
			"Weapon":
				card_desc.text = "Does " + str(active_stats.get("damage")) + " with " + str(active_stats.get("projectile_count")) + " projectiles going " + str(active_stats.get("projectile_speed")) + " every " + str(active_stats.get("attack_speed")) + " seconds and up to " + str(active_stats.get("range")) + " distance"
			"Modifier":
				card_desc.text = "Increases your " +  effect_stat + " by " + str(active_stats.get("effect_modifier")) + " times for " + str(active_stats.get("effect_length")) + " seconds every " + str(active_stats.get("effect_length") + active_stats.get("cooldown_speed")) + " seconds"
	else:
		pass

func _expand_card(expand: bool):
	if expand:
		main_h_box_container.size = expanded_size
		title_seperator.visible = true
		title_text.visible = true
	else:
		main_h_box_container.size = collapsed_size
		title_seperator.visible = false
		title_text.visible = false
	_update_desc()

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
	if !is_active: return
	_update_current_stats()
	var cooldown
	match card_type:
		"Weapon":
			var atk_mod = 1
			if get_parent().stats.get("attack_speed_modifier") != null:
				atk_mod = get_parent().stats.get("attack_speed_modifier")
			cooldown = active_stats.get("attack_speed") * atk_mod
			print(str(self.name) + " Waiting " + str(cooldown) + " seconds to attack")
			await get_tree().create_timer(cooldown).timeout
			if WaveController.closest_enemy != null && WaveController.closest_enemy.position.distance_to(WaveController.city.position) <= active_stats.get("range"):
				_attack()
				return
		"Modifier":
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
	if !is_active: return
	_update_current_stats()
	var dmg_mod = 1
	if get_parent().stats.get("damage_modifier") != null:
		dmg_mod = get_parent().stats.get("damage_modifier")
	var dmg: float = active_stats.get("damage") * dmg_mod
	WaveController.closest_enemy.health -= dmg
	_cooldown()

func _effect():
	if !is_active: return
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


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		is_active = true
		card_button.text = "O
							ᴝ"
	else: 
		is_active = false
		card_button.text = "O
							╖
							╖"

func _on_card_icon_toggled(toggled_on: bool) -> void:
	is_expanded = toggled_on
