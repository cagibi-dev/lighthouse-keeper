extends "res://items/SuperPaddles.gd"

func effect(body: PhysicsBody2D):
	body.bullet_speed *= 1.1
	body.get_node("Shoot/Timer").wait_time *= 0.7
	Globals.message = "You can shoot faster!"
