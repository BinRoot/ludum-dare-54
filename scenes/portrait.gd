extends Node2D

@onready var label: Label = $Label

var character_name = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	label.name = character_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
