extends Area2D

func _on_LightCenter_light_hit(curr_health, max_hits):
	$VisibleLight2D.color = $VisibleLight2D.color.darkened(float(curr_health)/float(max_hits))
