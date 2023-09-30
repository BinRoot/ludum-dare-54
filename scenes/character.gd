extends Node2D

var trait_skills = ["cook_fish", "catch_fish"]

@export var enabled_skills: Array[String] = ["cook_fish", "catch_fish"]
@export var money: int = 5

@onready var engine = $Engine
@onready var debug_label = $DebugLabel

var target_point: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var removed_skills = []
	for trait_skill in trait_skills:
		if trait_skill not in enabled_skills:
			removed_skills.push_back(trait_skill)
	print(name, ', removed: ', removed_skills)
	engine.remove_skills(removed_skills)
	engine.set_money(money)
	debug_label.text = name
	target_point = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = (target_point - position).normalized()
	if target_point.distance_to(position) > 1:
		position += direction * delta * 100


func _on_timer_timeout():
	var action_name = engine.commit_action()
	print(name, ' ', action_name)
	debug_label.text = action_name
	
	var offset_amount = 100
	var random_offset = Vector2(randi_range(-offset_amount, offset_amount), randi_range(-offset_amount, offset_amount))
	if action_name == "navigate_to_market":
		target_point = get_tree().get_nodes_in_group("market")[0].position + random_offset
	elif action_name == "navigate_to_docks":
		target_point = get_tree().get_nodes_in_group("docks")[0].position + random_offset
	elif action_name == "navigate_to_camp":
		target_point = get_tree().get_nodes_in_group("camp")[0].position + random_offset
		
