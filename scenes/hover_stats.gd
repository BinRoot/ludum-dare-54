extends Node2D
@onready var hp_progress_bar: ProgressBar = $ProgressBar
@onready var character_name_label: Label = $CharacterName
@onready var money_label: Label = $MoneyLabel
@onready var cooked_fish_label: Label = $CookedFishLabel
@onready var raw_fish_label: Label = $RawFishLabel
@onready var raw_fish_art = $RawFish
@onready var cooked_fish_art = $CookedFish
@onready var coin_art = $Coin
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


func _physics_process(delta):
	if Globals.HP in current_state_self:
		hp_progress_bar.value = current_state_self["hp"]
	if Globals.ITEM_MONEY in current_state_self[Globals.INVENTORY]:
		var money_value = current_state_self[Globals.INVENTORY][Globals.ITEM_MONEY]
		if money_value > 0:
			money_label.text = '$' + str(current_state_self[Globals.INVENTORY][Globals.ITEM_MONEY])
			coin_art.visible = true
		else:
			coin_art.visible = false
			money_label.text = ''
	if Globals.ITEM_RAW_FISH in current_state_self[Globals.INVENTORY]:
		var raw_fish_value = current_state_self[Globals.INVENTORY][Globals.ITEM_RAW_FISH]
		if raw_fish_value > 0:
			raw_fish_label.text = str(raw_fish_value)
			raw_fish_art.visible = true
		else:
			raw_fish_label.text = ""
			raw_fish_art.visible = false
	if Globals.ITEM_COOKED_FISH in current_state_self[Globals.INVENTORY]:
		var cooked_fish_value = current_state_self[Globals.INVENTORY][Globals.ITEM_COOKED_FISH]
		if cooked_fish_value > 0:
			cooked_fish_label.text = str(cooked_fish_value)
			cooked_fish_art.visible = true
		else:
			cooked_fish_label.text = ""
			cooked_fish_art.visible = false
	character_name_label.text = character_name
