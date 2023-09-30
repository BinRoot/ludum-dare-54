extends Node2D

@onready var boat_sink_animation: AnimationPlayer = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	boat_sink_animation.play("sink")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
