extends KinematicBody2D

signal shoot(position, vel, bullet)
signal dead(player)

var bullet := preload("res://player/PlayerBullet.tscn")
var velocity := Vector2.ZERO
var max_speed := 100.0
var bullet_speed := 200.0
var can_shoot := true
var vulnerable := false
var mouse_mode := false

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_mode = true

func _physics_process(_delta: float):
	var target_vel := Vector2.ZERO

	var padinput_vel := Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	if padinput_vel != Vector2.ZERO:
		mouse_mode = false
	if mouse_mode:
		if get_local_mouse_position().length() > 15:
			target_vel = get_local_mouse_position()
	else:
		target_vel = padinput_vel
	
	target_vel = target_vel.normalized()
	if target_vel.x != 0:
		$Sprite.scale.x = -sign(target_vel.x)
	if target_vel.y != 0:
		$Sprite.frame = 1 if target_vel.y < 0 else 0

	var mouse_vec := target_vel.normalized()
	if target_vel == Vector2.ZERO:
		mouse_vec = Vector2.RIGHT.rotated($ShootLine.rotation)
	$ShootLine.rotation = lerp_angle($ShootLine.rotation, mouse_vec.angle(), 0.2)

	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_action_pressed("shoot"):
		shoot(bullet_speed * mouse_vec)

	velocity = lerp(velocity, target_vel*max_speed, 0.05)
	velocity = move_and_slide(velocity)

func shoot(vel: Vector2):
	if can_shoot:
		can_shoot = false
		$Shoot/Timer.start()
		$Shoot.play()
		emit_signal("shoot", global_position, vel, bullet)
		velocity -= vel

func _on_HitBox_area_entered(_area: CollisionObject2D):
	if vulnerable:
		vulnerable = false
		$Hurt.play()
		hide()
		set_physics_process(false)
		emit_signal("dead", self)

func _on_Timer_timeout():
	can_shoot = true

func _on_HurtTimer_timeout():
	vulnerable = true
	$Immune.stop()
	show()
