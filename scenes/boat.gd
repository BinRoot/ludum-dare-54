extends Node2D

signal character_tapped
signal character_hovered
signal boat_sunk

@onready var boat_sink_animation: AnimationPlayer = $AnimationPlayer
@onready var water_animation: AnimationPlayer = $WaterAnimation
@onready var choice_1_node: Node2D = $BoatPolygon/Choice1Node
@onready var choice_2_node: Node2D = $BoatPolygon/Choice2Node

# Called when the node enters the scene tree for the first time.
func _ready():
	boat_sink_animation.play("sink")
	water_animation.play("splash")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if choice_1_node.get_children().size() == 0 and choice_2_node.get_children().size() == 0:
		var characters_still_on_boat = Globals.characters.filter(func(x): return !x[Globals.RESCUED])
		characters_still_on_boat.shuffle()
		var choice_1 = null
		var choice_2 = null
		if len(characters_still_on_boat) == 0:
			pass
		elif len(characters_still_on_boat) == 1:
			choice_1 = characters_still_on_boat[0]
		else:
			choice_1 = characters_still_on_boat[0]
			choice_2 = characters_still_on_boat[1]
		
		print('1: ', choice_1, ', 2: ', choice_2)
		if choice_1 != null:
			var character_1 = Globals.CHARACTER_RES.instantiate()
			character_1.name = choice_1["name"]
			character_1.connect("character_tapped", _on_character_tapped)
			character_1.connect("character_hovered_on_boat", _on_character_hovered)
			choice_1_node.add_child(character_1)
		if choice_2 != null:
			var character_2 = Globals.CHARACTER_RES.instantiate()
			character_2.name = choice_2["name"]
			character_2.connect("character_tapped", _on_character_tapped)
			character_2.connect("character_hovered_on_boat", _on_character_hovered)
			choice_2_node.add_child(character_2)
		if len(characters_still_on_boat) <= 18 and boat_sink_animation.current_animation_position < 60 * 5:
			boat_sink_animation.speed_scale = 0.5
		if len(characters_still_on_boat) <= 12 and boat_sink_animation.current_animation_position < 60 * 5:
			boat_sink_animation.speed_scale = 2


func _on_character_tapped(character):
	for c in Globals.characters:
		if c["name"] == character.name:
			c[Globals.RESCUED] = true
			break
	for child in choice_1_node.get_children():
		child.queue_free()
	for child in choice_2_node.get_children():
		child.queue_free()
	emit_signal("character_tapped", character.name)


func _on_character_hovered(character):
	emit_signal("character_hovered", character.name)


func _on_danger_area_area_entered(area):
	emit_signal("boat_sunk")
