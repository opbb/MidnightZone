extends Node

var score


func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$ScoreTimer.start()
