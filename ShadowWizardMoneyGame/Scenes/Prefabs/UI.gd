extends CanvasLayer

signal start_game

var score = 60

func start_timer():
	$CountDownTimer.start()

func set_score(initial_score):
	score = initial_score
	$CountDownTimer.start()

func show_game_over():
	$PauseMenu.end_game()

func update_score(score):
	$ScoreLabel.text = str(score)


#func _on_MessageTimer_timeout():
	#$MessageLabel.hide()


#func _on_StartButton_pressed():
#	$StartButton.hide()
#	emit_signal("start_game")


func _on_CountDownTimer_timeout():
	score -= 1 
	update_score(score)
	if score == 0:
		
		var level_manager = get_parent().get_node("LevelManager")
		level_manager.toNextLevel()

