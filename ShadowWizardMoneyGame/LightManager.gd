extends Node

var scene = preload("res://Scenes/Prefabs/Light.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var lights = []
# Called when the node enters the scene tree for the first time.
func _ready():
	lights = get_children()
	for light in lights:
		print(light.position)
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
