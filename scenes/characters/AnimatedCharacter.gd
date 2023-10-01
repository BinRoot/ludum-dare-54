extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var head_shake = $HeadShake
@onready var body: Polygon2D = $Body
@onready var head: Polygon2D = $Head
var body_size = 0.5

var original_left_point: Vector2
var original_right_point: Vector2


func _ready():
	pass
	

func set_character_name(character_name):
	var character = Globals.get_character_by_name(character_name)
	if character != null and "face" in character:
		var face = character["face"].instantiate()
		head.add_child(face)
		face.z_index = 4


func _process(delta):
	pass


func shake():
	head_shake.play("shake")


func play_animation_for_direction(direction: Vector2):
	if abs(direction.y) >= abs(direction.x):
		scale.x = 1
		animation_player.play("walk_down")
	else:
		if direction.x > 0:
			scale.x = 1
			animation_player.play("walk_right")
		else:
			animation_player.play("walk_right")
			scale.x = -1
	

func idle():
	scale.x = 1
	animation_player.play("idle")
