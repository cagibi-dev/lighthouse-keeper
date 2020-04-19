extends Area2D


var bodies := []

func _on_Current_body_entered(body: Node):
	bodies.append(body)

func _on_Current_body_exited(body):
	if body in bodies:
		bodies.erase(body)

func _physics_process(delta):
	for body in bodies:
		if body.velocity != null and (body.velocity.x * scale.x) < 200:
			body.velocity.x += 200 * delta * scale.x
