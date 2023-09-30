extends Node2D

@onready var boat_sink_animation: AnimationPlayer = $AnimationPlayer
@onready var choice_1_node: Node2D = $BoatPolygon/Choice1Node
@onready var choice_2_node: Node2D = $BoatPolygon/Choice2Node

var character_1_res = preload("res://scenes/character.tscn")
var character_2_res = preload("res://scenes/character.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():

	boat_sink_animation.play("sink")


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
			var character_1 = character_1_res.instantiate()
			character_1.name = choice_1["name"]
			character_1.connect("character_tapped", _on_character_tapped)
			choice_1_node.add_child(character_1)			
		if choice_2 != null:
			var character_2 = character_2_res.instantiate()
			character_2.name = choice_2["name"]
			character_2.connect("character_tapped", _on_character_tapped)			
			choice_2_node.add_child(character_2)

func _on_character_tapped(character):
	print(character.name)
	for c in Globals.characters:
		if c["name"] == character.name:
			c[Globals.RESCUED] = true
			break
	for child in choice_1_node.get_children():
		child.queue_free()
	for child in choice_2_node.get_children():
		child.queue_free()
