extends Area2D

signal my_light_died(my_light)

export var shadowCheckInterval = .1
export var timeUntilConsumed = 1
export var timeForBounce = 1

onready var PlayerRaycast2D = $PlayerRayCast2D
onready var TerrainRaycast2D = $TerrainRayCast2D
onready var ConsumedTimer = $ConsumedTimer
onready var BounceTimer = $BounceTimer
onready var wasInPlayerShadow = false
onready var animationTree = $MobAnimationTree

const jiggleOffset = Vector2(3, 0)

var bounce_speed = 200
var bounce_direction = Vector2(0,0)
var speed = 25
var light_position = Vector2(0,0)
var direction = Vector2(0,0)
var move_at_angle_huh = true
var target_light: Area2D
var alive_lights = []
var is_dying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Allos for values to be easily changed in the GUI
	$ShadowCheckTimer.wait_time = shadowCheckInterval
	$ConsumedTimer.wait_time = timeUntilConsumed
	$BounceTimer.wait_time = timeForBounce


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func find_min_distance_to_light(lights): 
	var closest_num = self.position.distance_to(lights[0].position)
	var closest_light = lights[0]

	for i in range(1, lights.size()):
		var delta = self.position.distance_to(lights[i].position)
		if delta < closest_num:
			closest_light = lights[i]
			closest_num = delta
	return closest_light

	
func set_Properties(mob_spawn_location, lights, will_rotate):
	alive_lights = lights
	self.position = mob_spawn_location.position
	target_light = find_min_distance_to_light(lights)	
	self.move_at_angle_huh = will_rotate
	light_position = target_light.position
	direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)

	
	
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
	start_jiggle()
	ConsumedTimer.start()

func _on_exit_Player_Shadow():
	wasInPlayerShadow = false
	stop_jiggle()
	ConsumedTimer.stop()


func _on_ConsumedTimer_timeout():
	if (_is_Mob_in_Player_Shadow()):
		_on_consumed()
	else:
		_on_exit_Player_Shadow()
		
func _on_consumed():
	$ShadowCheckTimer.stop()
	$Sprite.modulate = Color(0.369,0.2,0.416,0.7)
	is_dying = true
	$DeathTimer.start()
	
func _physics_process(delta):
	var vectorToLight = light_position - self.position
	animationTree.set("parameters/Idle-and-Float/blend_position", vectorToLight.normalized())
	if (BounceTimer.is_stopped() && !is_dying):
		if is_instance_valid(target_light) and target_light.getLightDead() or !(target_light in alive_lights):
			if !(alive_lights.empty()):
				target_light = find_min_distance_to_light(alive_lights)	
				$Sprite.rotation = direction 
				light_position = target_light.position
		var new_pos = self.position.move_toward(light_position, delta * speed)
		if move_at_angle_huh:
			var d =  new_pos - self.position
			self.position += d.rotated(deg2rad(45))
		else:
			self.position = new_pos
	else:
		self.position += bounce_direction * delta * BounceTimer.time_left * bounce_speed

func enable_bounce_mob(collision_position):
	var direction = self.position - collision_position
	direction = direction.normalized()
	BounceTimer.start()
	bounce_direction = direction

func _on_Mob_body_entered(body):
	if (body.get_name() == "Player"):
		body.playerBounceDetected(self.position)
		self.enable_bounce_mob(body.position)
	elif (body.get_name() == "LightBody"):
		var overlappingLight = body.get_parent()
		overlappingLight.onLightHit()
		if overlappingLight.getLightDead():
			alive_lights.erase(overlappingLight)
			emit_signal("my_light_died", overlappingLight)

		var overlappingArea = overlappingLight.get_node("LightBounceArea")
		var enemiesToBounce = overlappingArea.get_overlapping_areas()
		var lightPosition = overlappingArea.global_position
		for enemy in enemiesToBounce:
			if "Mob" in enemy.get_name():
				enemy.enable_bounce_mob(lightPosition)

func _on_Mob_my_light_died(my_light):
	alive_lights.erase(my_light)

func start_jiggle():
	$Sprite.set_offset(jiggleOffset)
	$JiggleTimer.start()

func stop_jiggle():
	$Sprite.set_offset(Vector2(0,0))
	$JiggleTimer.stop()


func _on_JiggleTimer_timeout():
	$Sprite.set_offset(-$Sprite.get_offset())


func _on_DeathTimer_timeout():
	queue_free()
