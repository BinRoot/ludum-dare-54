extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func raise():
	animation_player.play("raise")


func shake(speed_scale):
	animation_player.speed_scale = speed_scale
	animation_player.play("shake")


func stop_animation():
	animation_player.stop()
