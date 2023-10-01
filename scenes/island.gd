extends Node2D

@onready var character_holder: Node2D = $CharacterHolder
@onready var market_label: Label = $MarketLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	market_label.text = ""
	var idx = 0
	for k in Globals.market_inventory:
		market_label.text += k + ": " + str(Globals.market_inventory[k])
		market_label.text += "\n"
	


func load_character(character_name):
	var character = Globals.CHARACTER_RES.instantiate()
	character.name = character_name
	character.connect("character_tapped", _on_character_tapped)
	character_holder.add_child(character)
	(character.timer as Timer).start()


func _on_character_tapped(character):
	pass


func _on_area_2d_mouse_entered():
	market_label.visible = true


func _on_area_2d_mouse_exited():
	market_label.visible = false
