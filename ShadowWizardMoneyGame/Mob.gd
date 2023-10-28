extends Area2D

onready var PlayerRaycast2D = $PlayerRayCast2D
onready var TerrainRaycast2D = $TerrainRayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	print(_is_Mob_in_Player_Shadow())


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(_is_Mob_in_Player_Shadow())
	
	
# Determine's whether this mob is in player shadow, returns boolean.
func _is_Mob_in_Player_Shadow():
	var overlappingAreas = $LightCheckArea2D.get_overlapping_areas()
	
	var isInPlayerShadow = false
	
	for lightArea in overlappingAreas:
		var hereToLight = lightArea.position - self.position
		PlayerRaycast2D.cast_to = hereToLight
		PlayerRaycast2D.force_raycast_update()
		TerrainRaycast2D.cast_to = hereToLight
		TerrainRaycast2D.force_raycast_update()

		var isBehindPlayer = PlayerRaycast2D.is_colliding()
		var isBehindTerrain = TerrainRaycast2D.is_colliding()
		
		# If we are in the light, we are not in shadow
		if (!isBehindPlayer && !isBehindTerrain):
			return false
			
		if(isBehindPlayer && !isBehindTerrain):
			isInPlayerShadow = true
	
	return isInPlayerShadow
