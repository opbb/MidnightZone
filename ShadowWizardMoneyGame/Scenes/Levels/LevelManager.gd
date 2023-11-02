extends Node

export var next = ""
const mainMenu = "MainMenu"

func toMainMenu():
	toLevel(mainMenu)

func restartLevel():
	get_tree().reload_current_scene()

func toNextLevel():
	toLevel(next)

func toLevel(levelName):
	get_tree().change_scene("res://Scenes/Levels/" + str(levelName) + ".tscn")
