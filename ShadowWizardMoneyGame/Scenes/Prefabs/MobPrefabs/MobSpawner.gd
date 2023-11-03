extends Node

export(PackedScene) var mob_scene_regular
export(PackedScene) var mob_scene_angler
export(PackedScene) var mob_scene_jelly


var listOfMobs = []
export var max_mob_count = 35
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
	if listOfMobs.size() < max_mob_count:
		var mob = null
		var rand_num = randi() % 3
		if (rand_num == 0):
			mob = mob_scene_regular.instance()
		elif (rand_num == 1):
			mob = mob_scene_angler.instance()
		else:
			mob = mob_scene_jelly.instance()
		listOfMobs.append(mob)
		# Get location of Lights
		var light_manager = get_node("../LightManager")
		
		# Choose a random location on Path2D.
		var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
		if (self.get_parent().get_name() == "IntroLevel"):
			var pathLength = get_node("MobPath").get_curve().get_baked_length()
			mob_spawn_location.offset = randi() % int(pathLength / 4) + int(pathLength / 8 * 5)
		else:
			mob_spawn_location.offset = randi()
		var will_rotate = randi() % 2 == 0
		#for light in light_manager.lights:
		#	connect("light_died", mob, "_on_light_died", [light])
		mob.set_Properties(mob_spawn_location, light_manager.lights, will_rotate)

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
		current_mob_count+=1
	else: 
		$MobTimer.stop()
