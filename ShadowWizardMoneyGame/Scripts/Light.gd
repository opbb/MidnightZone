extends Area2D

export var max_hits: int = 5
export var curr_health: int = 0

func onLightHit():
	self.curr_health += 1
	$VisibleLight2D.color = $VisibleLight2D.color.darkened(float(curr_health)/float(max_hits))
