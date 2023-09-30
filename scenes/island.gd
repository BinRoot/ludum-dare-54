extends Node2D

@onready var character_holder: Node2D = $CharacterHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_character(character_name):
	var character = Globals.CHARACTER_RES.instantiate()
	character.name = character_name
	character.connect("character_tapped", _on_character_tapped)
	character_holder.add_child(character)
	(character.timer as Timer).start()


func _on_character_tapped(character):
	pass
