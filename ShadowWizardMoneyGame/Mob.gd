extends Area2D

export var shadowCheckInterval = .1
export var timeUntilConsumed = 1

onready var PlayerRaycast2D = $PlayerRayCast2D
onready var TerrainRaycast2D = $TerrainRayCast2D
onready var ConsumedTimer = $ConsumedTimer
onready var wasInPlayerShadow = false

var speed = 50
var velocity = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	print(_is_Mob_in_Player_Shadow())
	
	# Allos for values to be easily changed in the GUI
	$ShadowCheckTimer.wait_time = shadowCheckInterval
	$ConsumedTimer.wait_time = timeUntilConsumed
	var angle = randf() * 2 * PI
	velocity = Vector2(cos(angle), sin(angle)) * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func set_Properties(mob_spawn_location):
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	self.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	$AnimatedSprite.rotation = direction 
	velocity.rotated(direction)

	
	
# Determine's whether this mob is in player shadow, returns boolean.
func _is_Mob_in_Player_Shadow():
	var overlappingAreas = $LightCheckArea2D.get_overlapping_areas()
	
	var isInPlayerShadow = false
	
	for lightArea in overlappingAreas:
		var hereToLight = lightArea.global_position - self.global_position
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


func _on_ShadowCheckTimer_timeout():
	var isInPlayerShadow = _is_Mob_in_Player_Shadow()
	if(isInPlayerShadow && !wasInPlayerShadow):
		_on_enter_Player_Shadow()
	elif (!isInPlayerShadow && wasInPlayerShadow):
		_on_exit_Player_Shadow()

func _on_enter_Player_Shadow():
	wasInPlayerShadow = true
	$AnimatedSprite.modulate = Color(255,217,25)
	ConsumedTimer.start()

func _on_exit_Player_Shadow():
	wasInPlayerShadow = false
	$AnimatedSprite.modulate = Color(0,38,230)
	ConsumedTimer.stop()


func _on_ConsumedTimer_timeout():
	if (_is_Mob_in_Player_Shadow()):
		_on_consumed()
	else:
		_on_exit_Player_Shadow()
		
func _on_consumed():
	$ShadowCheckTimer.stop()
	$AnimatedSprite.modulate = Color(0,0,0)
	
func _physics_process(delta):
	self.position += velocity * delta
	
