extends "res://items/Coin.gd"

func effect(_body: PhysicsBody2D):
	if get_tree().current_scene.has_node("LightHouse"):
		var lh = get_tree().current_scene.get_node("LightHouse")
		lh.life += 20
		if lh.life > 100:
			lh.life = 100
		Globals.message = "You repaired the lighthouse with the barrel."
