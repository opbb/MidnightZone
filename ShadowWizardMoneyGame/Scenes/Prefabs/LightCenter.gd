extends Area2D

signal light_hit(curr_health, max_hits);

export var max_hits: int = 5
export var curr_hits: int = 0

func _on_LightCenter_area_entered(area):
	self.curr_hits += 1
	emit_signal("light_hit", self.curr_hits, self.max_hits)
