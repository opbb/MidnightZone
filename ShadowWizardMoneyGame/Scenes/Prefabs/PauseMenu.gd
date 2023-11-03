extends Control

var is_paused = false setget set_is_paused

onready var levelManager = get_node("../../LevelManager")
onready var levelMusic = get_node("../../LevelMusic")
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	if is_paused:
		levelMusic.stop()
		$PauseMusic.play(0)
	else:
		$PauseMusic.stop()
		levelMusic.play()
	levelManager.get_tree().paused = is_paused
	visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	self.is_paused = false
	visible = false
	$CenterContainer/VBoxContainer/PausedLabel.text = "Paused"
	$CenterContainer/VBoxContainer/ResumeBtn.visible = true
	get_node("Background").modulate.a = 0.7


func _on_ResumeBtn_pressed():
	self.is_paused = false


func _on_ReloadBtn_pressed():
	levelManager.get_tree().paused = false
	levelManager.restartLevel()

func end_game():
	$CenterContainer/VBoxContainer/PausedLabel.text = "Game Over"
	$CenterContainer/VBoxContainer/ResumeBtn.visible = false
	self.is_paused = true
