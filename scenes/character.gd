extends Node2D

signal character_tapped
signal character_hovered_on_boat

var trait_skills = ["cook_fish", "catch_fish"]

@export var enabled_skills: Array[String] = ["cook_fish", "catch_fish"]
@export var money: int = 5

@onready var engine = $Engine
@onready var debug_label = $DebugLabel

@onready var left_arm = $LeftArm
@onready var right_arm = $RightArm
@onready var timer: Timer = $Timer
@onready var animated_character = $AnimatedCharacter
@onready var hover_stats = $HoverStats

@onready var action_animation: AnimationPlayer = $ActionAnimation

var target_point: Vector2


func _ready():
	var removed_skills = []
	for trait_skill in trait_skills:
		if trait_skill not in enabled_skills:
			removed_skills.push_back(trait_skill)
	print(name, ', removed: ', removed_skills)
	engine.remove_skills(removed_skills)
	engine.set_money(money)
#	debug_label.text = name
	target_point = position
	animated_character.set_character_name(name)
	action_animation.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not timer.is_stopped():
		var direction = (target_point - global_position).normalized()
		if target_point.distance_to(global_position) > 1:
			position += direction * delta * 100
			animated_character.play_animation_for_direction(direction)
		else:
			animated_character.idle()
	hover_stats.current_state_self = engine.current_state["self"]
	hover_stats.character_name = name


func _on_timer_timeout():
	var action_name = engine.commit_action()
	debug_label.text = action_name
	
	var offset_amount = 100
	var random_offset = Vector2(randi_range(-offset_amount, offset_amount), randi_range(-offset_amount, offset_amount))
	
	if action_name == "navigate_to_market":
		target_point = get_tree().get_nodes_in_group("market")[0].global_position + random_offset
		action_animation.play("idle")
	elif action_name == "navigate_to_docks":
		target_point = get_tree().get_nodes_in_group("docks")[0].global_position + random_offset
		action_animation.play("idle")
	elif action_name == "navigate_to_camp":
		target_point = get_tree().get_nodes_in_group("camp")[0].global_position + random_offset
		action_animation.play("idle")
	elif action_name == "catch_fish":
		action_animation.speed_scale = randf() + 0.5
		action_animation.play("fishing")
	elif action_name == "eat":
		action_animation.speed_scale = randf() + 0.5
		action_animation.play("eating")
	elif action_name == "cook_fish":
		action_animation.speed_scale = randf() + 0.5
		action_animation.play("cooking")
	else:
		action_animation.play("idle")
		
func panic():
	var speed_scale = randf() + 0.5
	left_arm.shake(speed_scale)
	right_arm.shake(speed_scale)
	animated_character.shake()



func _on_area_2d_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_pressed():
		emit_signal("character_tapped", self)
	elif Globals.characters != null:
		var rescued_characters_matching_me = Globals.characters.filter(func(x): return x[Globals.RESCUED] and x["name"] == name)
		if len(rescued_characters_matching_me) == 0:
			emit_signal("character_hovered_on_boat", self)
			panic()


func _on_area_2d_mouse_entered():
	var rescued_characters_matching_me = Globals.characters.filter(func(x): return x[Globals.RESCUED] and x["name"] == name)
	if len(rescued_characters_matching_me) > 0:
		hover_stats.visible = true


func _on_area_2d_mouse_exited():
	hover_stats.visible = false
