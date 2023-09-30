extends Node2D

var trait_skills = ["cook_fish", "catch_fish"]

@export var enabled_skills: Array[String] = ["cook_fish", "catch_fish"]
@export var money: int = 5

@onready var engine = $Engine
@onready var debug_label = $DebugLabel


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var action_name = engine.commit_action()
	print(name, ' ', action_name)
	debug_label.text = action_name
