extends "res://items/Coin.gd"

func effect(body: PhysicsBody2D):
	body.max_speed *= 1.25
	body.bullet_speed *= 1.2
	body.get_node("Shoot/Timer").wait_time /= 1.25
	Globals.message = "You can move slightly faster!"
