extends Node

var scene = preload("res://Scenes/Prefabs/Light.tscn")

export var lights = []
# Called when the node enters the scene tree for the first time.
func _ready():
	lights = get_children()
	for light in lights:
		print(light.position)
	
func _physics_process(delta):
	for light in get_children():
		if is_instance_valid(light):
			if light.getLightDead():
				print("Freeing ", light)
				light.freeMe()
			
