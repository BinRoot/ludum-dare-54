extends Node2D

const STATE_PICK_NEXT_SURVIVOR: String = "STATE_PICK_NEXT_SURVIVOR"

var current_state = STATE_PICK_NEXT_SURVIVOR

@onready var life_boat = $LifeBoat
@onready var boat = $Boat
@onready var island = $Island
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog_animation_player: AnimationPlayer = $DialogAnimationPlayer

@onready var dialog_character_name: Label = $DialogBox/DialogCharacterName
@onready var dialog_content: Label = $DialogBox/DialogContent
@onready var background_animation: AnimationPlayer = $BackgroundAnimation
@onready var boat_animation: AnimationPlayer = $BoatIntro
@onready var start_button: Button = $Button

func _ready():
	animation_player.stop()
	background_animation.play("waves")

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
	var is_rescued = Globals.get_character_by_name(character_name)["rescued"]
	if is_rescued:
		dialog_animation_player.stop()
	if not animation_player.is_playing() and not is_rescued:
		
		if character_name != dialog_character_name.text:
			dialog_animation_player.stop()
			var shouts = Globals.get_character_by_name(character_name)["shouts"]
			var shout = shouts[randi() % len(shouts)]
			dialog_content.text = shout
		dialog_animation_player.play("shout")
		dialog_character_name.text = character_name
	


func _on_boat_intro_animation_finished(anim_name):
	boat.start_sinking()


func _on_button_pressed():
	boat_animation.play("intro")
	start_button.visible = false
	
