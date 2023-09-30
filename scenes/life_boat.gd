extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var passenger_node: Node2D = $LifeBoat/PassengerNode
@onready var captain: Node2D = $LifeBoat/Captain

signal passenger_rescued


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
	print('animation stopped: ', anim_name)
	if anim_name == "steer":
		if passenger_node.get_child_count() > 0:
			emit_signal("passenger_rescued", passenger_node.get_child(0).name)
			for child in passenger_node.get_children():
				child.queue_free()
		if !Globals.boat_sunk:
			animation_player.play("return")
		else:
			captain.queue_free()
