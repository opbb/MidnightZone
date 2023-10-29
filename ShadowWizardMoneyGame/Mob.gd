extends Area2D


var speed = 50
var velocity = Vector2(0, 0)
var light_mock = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	var angle = randf() * 2 * PI
	velocity = Vector2(cos(angle), sin(angle)) * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func set_Properties(mob_spawn_location, light):
	
	light_mock = light.position
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	self.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	self.rotation = direction 
	velocity.rotated(direction)
	
func _physics_process(delta):
	var movement_direction = light_mock - self.position
	var direction_length = sqrt(pow(movement_direction.x, 2) + pow(movement_direction.y, 2))
	var movement_direction_normalized = movement_direction / direction_length
	self.position += velocity * delta * movement_direction_normalized
	
