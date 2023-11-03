extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	if is_paused:
		get_node("../../LevelMusic").stop()
		$PauseMusic.play(0)
	else:
		$PauseMusic.stop()
		get_node("../../LevelMusic").play()
	get_node("../../LevelManager").get_tree().paused = is_paused
	visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	get_node("Background").modulate.a = 0.7


func _on_ResumeBtn_pressed():
	self.is_paused = false


func _on_ReloadBtn_pressed():
	get_node("../../LevelManager").restartLevel()
