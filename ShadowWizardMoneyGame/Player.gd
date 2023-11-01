extends KinematicBody2D

signal hit

export var speed = 100 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
onready var animationTree = $ChildAnimationTree
onready var stateMachine = animationTree.get("parameters/playback")



func _ready():
	screen_size = get_viewport_rect().size
	hide()
	start(position)


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	move_and_slide(velocity)
	
	updateAnimationState(velocity)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	
	# Must be deferred as we can't change physics properties on a physics callback.
	
	


func updateAnimationState(velocity: Vector2):
	if (velocity != Vector2.ZERO):
		stateMachine.travel("Walk")
	else:
		stateMachine.travel("Idle")
