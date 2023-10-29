extends Node

export(PackedScene) var mob_scene


var listOfMobs = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_mob_timer():
	$MobTimer.start()

func stop_mob_timer():
	$MobTimer.stop()
	
func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()
	listOfMobs.append(mob)

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	mob.set_Properties(mob_spawn_location)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)