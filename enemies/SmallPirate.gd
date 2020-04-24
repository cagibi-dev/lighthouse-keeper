extends KinematicBody2D

signal add_score(sco, pos)

export (float) var max_speed = 15
export (int) var score = 100
export (int) var rareness = 1
var velocity = Vector2.ZERO

func _ready():
	# in the 1st frame, position isn't set which is problematic
	#set_deferred("collision_layer", 8)
	pass

func _physics_process(delta):
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x > 0
	if velocity.y != 0:
		$Sprite.frame = 1 if velocity.y < 0 else 0
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * (velocity.length() - 30 * delta)
	velocity = move_and_slide(velocity)
	
	if abs(position.x) > 381:
		queue_free()


func _on_HitBox_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
	hurt()


func hurt():
	$Dead.play()
	$Sprite.hide()
	$Light2D.hide()
	$Explosion.emitting = true
	emit_signal("add_score", score, global_position)
	call_deferred("drop_item")
	collision_layer = 0
	$HitBox.collision_layer = 0
	$HitBox.collision_mask = 0
	set_physics_process(false)
	$Trail.emitting = false
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()

func drop_item():
	for _i in range(rareness):
		var item = null
		if randi()%200 == 0:
			item = load("res://items/Coin.tscn")
		elif randi()%250 == 0:
			item = load("res://items/LifeBarrel.tscn")
		elif randi()%350 == 0:
			item = load("res://items/SuperCannon.tscn")
		elif randi()%400 == 0:
			item = load("res://items/SuperPaddles.tscn")
		
		if item != null:
			var new_item = item.instance()
			get_parent().add_child(new_item)
			new_item.global_position = global_position + Vector2(rand_range(-8, 8), rand_range(-8, 8))
