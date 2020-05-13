extends KinematicBody2D

signal add_score(sco, pos)
signal drop_item(pos)

export (float) var max_speed := 15.0
export (int) var score := 100
export (int) var rareness := 1
var velocity := Vector2.ZERO

func _physics_process(delta):
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * (velocity.length() - 30 * delta)
	velocity = move_and_slide(velocity)
	
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x > 0
	if velocity.y != 0:
		$Sprite.frame = 1 if velocity.y < 0 else 0
	
	if abs(position.x) > 381:
		queue_free()

func _on_HitBox_area_entered(area: Area2D):
	if area.has_method("destroy"):
		area.destroy()
	hurt()

func hurt():
	$Dead.play()
	$Sprite.hide()
	$Light2D.hide()
	$Explosion.emitting = true
	emit_signal("add_score", score, global_position)
	if randi()%50 < rareness:
		emit_signal("drop_item", global_position)
	$HitBox.collision_layer = 0
	$HitBox.collision_mask = 0
	set_physics_process(false)
	$Trail.emitting = false
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
