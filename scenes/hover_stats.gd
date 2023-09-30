extends Node2D
@onready var hp_progress_bar: ProgressBar = $ProgressBar
@onready var character_name_label: Label = $CharacterName
var current_state_self = {}
var character_name: String = ""


#var current_state = {
#	STATE_SELF: {
#		INVENTORY: {
#			ITEM_RAW_FISH: 0,
#			ITEM_COOKED_FISH: 0,
#			ITEM_MONEY: 0,
#		},
#		HP: Globals.hp_start,
#		LOCATION: LOCATION_DOCKS,
#	},
#}

func _ready():
	pass # Replace with function body.


func _process(delta):
	if "hp" in current_state_self:
		hp_progress_bar.value = current_state_self["hp"]
	character_name_label.text = character_name
