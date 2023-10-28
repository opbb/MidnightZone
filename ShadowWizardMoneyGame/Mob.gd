extends Area2D


var speed = 50
var velocity = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	var angle = randf() * 2 * PI
	
	velocity = Vector2(cos(angle), sin(angle)) * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func set_Properties(mob_spawn_location):
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	self.position = mob_spawn_location.position
	print(position)

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	self.rotation = direction 
	velocity.rotated(direction)
	
func _physics_process(delta):
	if velocity.x < 0:
		self.position -= velocity * delta
	else:
		self.position += velocity * delta
	
