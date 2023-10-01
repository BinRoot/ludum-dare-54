extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var passenger_node: Node2D = $LifeBoat/PassengerNode
@onready var captain: Node2D = $LifeBoat/Captain
@onready var hover_label: Label = $LifeBoat/Captain/Area2D/HoverLabel

signal passenger_rescued


var hover_texts = [
	"This is your crew now",
	"Let's see how long we survive",
	"What a beautiful team...",
	"Now we wait and see how this will end",
	"Time to sit back and watch the drama",
	"I'll just watch from the distance",
	"Why can't we all just be friends?",
	"This is better than TV",
	"This is like a reality show",
]

var intro_hover_texts = [
	"There's only room for two on this boat!",
	"Only one can be rescured at a time!",
	"Space is limited!",
	"Not sure if everybody can fit!",
	"It's a bit tight in here",
]


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("float")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dock():
	animation_player.play("steer")


func set_passenger(character_name):
	for child in passenger_node.get_children():
		child.queue_free()
	var character = Globals.CHARACTER_RES.instantiate()
	character.name = character_name
	character.connect("character_tapped", _on_character_tapped)
	passenger_node.add_child(character)
	animation_player.play("steer")
	

func _on_character_tapped(character):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "steer":
		if passenger_node.get_child_count() > 0:
			emit_signal("passenger_rescued", passenger_node.get_child(0).name)
			for child in passenger_node.get_children():
				child.queue_free()
		if !Globals.boat_sunk:
			animation_player.play("return")
		else:
			#captain.queue_free()
			pass


func _on_area_2d_mouse_entered():
	var hover_text = ""
	if Globals.boat_sunk:
		hover_text = hover_texts[randi() % len(hover_texts)]
	else:
		hover_text = intro_hover_texts[randi() % len(intro_hover_texts)]
	hover_label.text = hover_text
	hover_label.visible = true


func _on_area_2d_mouse_exited():
	hover_label.visible = false
