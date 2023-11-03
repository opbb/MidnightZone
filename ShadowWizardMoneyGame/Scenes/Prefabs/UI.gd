extends CanvasLayer

signal start_game

var score = 60

func show_message(text):
	$GameOverLabel.text = text
	$GameOverLabel.show()
	$CountDownTimer.start()

func set_score(initial_score):
	score = initial_score
	$CountDownTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Shadow Wizard Money \nGame"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


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
