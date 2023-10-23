extends Node

var score


func _ready():
	randomize()
	new_game()


func game_over():
	$ScoreTimer.stop()
	$UI.show_game_over()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$UI.update_score(score)
	$UI.show_message("Get Ready")

func _on_ScoreTimer_timeout():
	score += 1
	$UI.update_score(score)


func _on_StartTimer_timeout():
	$ScoreTimer.start()
