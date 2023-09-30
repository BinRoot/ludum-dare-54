extends Node2D

const STATE_PICK_NEXT_SURVIVOR: String = "STATE_PICK_NEXT_SURVIVOR"

var current_state = STATE_PICK_NEXT_SURVIVOR

@onready var life_boat = $LifeBoat
@onready var island = $Island
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog_animation_player: AnimationPlayer = $DialogAnimationPlayer

@onready var dialog_character_name: Label = $DialogBox/DialogCharacterName
@onready var dialog_content: Label = $DialogBox/DialogContent

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boat_character_tapped(character_name):
	life_boat.set_passenger(character_name)
	animation_player.play("pan_camera_left")

func _input(event):
	if event.is_action_pressed("ui_end"):
		_on_boat_boat_sunk()


func _on_life_boat_passenger_rescued(character_name: String):
	island.load_character(character_name)
	if !Globals.boat_sunk:
		animation_player.stop()


func _on_boat_boat_sunk():
	Globals.boat_sunk = true
	animation_player.play("pan_camera_to_island")
	life_boat.dock()


func _on_boat_character_hovered(character_name):
	if character_name != dialog_character_name.text:
		dialog_animation_player.stop()
		var shouts = Globals.get_character_by_name(character_name)["shouts"]
		var shout = shouts[randi() % len(shouts)]
		dialog_content.text = shout
	dialog_animation_player.play("shout")
	dialog_character_name.text = character_name
	
