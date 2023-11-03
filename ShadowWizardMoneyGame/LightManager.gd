extends Node

export var lights = []
# Called when the node enters the scene tree for the first time.
func _ready():
	lights = get_children()

	
func _physics_process(delta):
	for light in get_children():
		if is_instance_valid(light):
			if light.getLightDead():
				light.freeMe()
			
