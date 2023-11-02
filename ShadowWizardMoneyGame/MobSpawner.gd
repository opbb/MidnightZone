extends Node

export(PackedScene) var mob_scene


var listOfMobs = []
export var max_mob_count = 10
var current_mob_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_mob_timer():
	$MobTimer.start()

func stop_mob_timer():
	$MobTimer.stop()
	
func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	if current_mob_count < max_mob_count:
	
		var mob = mob_scene.instance()
		listOfMobs.append(mob)

		# Get location of light
		var light_manager = get_node("../LightManager")
		get_signal_list()
		
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		mob_spawn_location.offset = randi()
		var will_rotate = randi() % 2 == 0
		mob.set_Properties(mob_spawn_location, light_manager.lights, will_rotate)

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
		current_mob_count+=1
	else: 
		$MobTimer.stop()
