extends Area2D

signal light_died(light)
	
export var max_hits: int = 5
export var curr_health: int = 0
export var dead = false

func onLightHit():
	self.curr_health += 1
	$VisibleLight2D.color = $VisibleLight2D.color.darkened(float(curr_health)/float(max_hits))
	if curr_health >= max_hits:
		dead = true

func getLightDead():
	return dead

func freeMe():
	queue_free()
