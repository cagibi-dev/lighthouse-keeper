extends YSort

var pirate := preload("res://enemies/SmallPirate.tscn")
var big_pirate := preload("res://enemies/BigPirate.tscn")
var chaser := preload("res://enemies/Chaser.tscn")

var plus_score := preload("res://items/PlusScore.tscn")
var items := [
	preload("res://items/Coin.tscn"),
	preload("res://items/LifeBarrel.tscn"),
	preload("res://items/SuperCannon.tscn"),
	preload("res://items/SuperPaddles.tscn"),
]

func _ready():
	Globals.score = 0
	yield(get_tree().create_timer(6.0), "timeout")
	Globals.message = "Aim through the lighthouse to boost your bullets\nFOR EMERGENCY USE ONLY"

func _physics_process(_delta: float):
	if has_node("LightHouse") and has_node("Player"):
		$Camera2D.position = (2*$LightHouse.position + $Player.position)/3
	
	if Globals.message != $HUD/UI/Instructions.text:
		$HUD/UI/Instructions.text = Globals.message

	if not OS.is_window_focused():
		pause_game()

func _notification(what: int):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pause_game()

func pause_game():
	$Pause/Menu.show()
	get_tree().paused = true
	$Pause/Menu/Rows/Resume.grab_focus()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		pause_game()

func _on_Player_shoot(pos: Vector2, vel: Vector2, bullet: PackedScene):
	var my_bullet: Node2D = bullet.instance()
	add_child(my_bullet)
	my_bullet.global_position = pos + 10*vel.normalized()
	my_bullet.velocity = vel

func _on_Player_dead(player: Node2D):
	$Camera2D/Shake.play("screen_shake")
	yield(get_tree().create_timer(1.5), "timeout")
	if has_node("LightHouse"):
		player.global_position = $LightHouse.global_position
		player.show()
		player.set_physics_process(true)
		player.vulnerable = false
		player.get_node("Immune").play("immune")
		player.get_node("Hurt/Timer").start()
		$LightHouse.life -= 7
		$LightHouse/Respawn.play()

func _on_PirateSpawner_timeout():
	if $PirateSpawner.wait_time > 0.75:
		$PirateSpawner.wait_time *= 0.986
	if has_node("LightHouse"):
		var my_pirate: Node2D
		if randi()%20 == 0:
			my_pirate = big_pirate.instance()
			var ok := my_pirate.connect("shoot", self, "_on_Pirate_shoot")
			assert(OK == ok)
		elif randi()%15 == 0:
			my_pirate = chaser.instance()
			my_pirate.player = $Player
			var ok := $LightHouse.connect("gameover", my_pirate, "_on_GameOver")
			assert(OK == ok)
		else:
			my_pirate = pirate.instance()

		var ok := my_pirate.connect("add_score", self, "_on_Pirate_add_score")
		assert(OK == ok)
		ok = my_pirate.connect("drop_item", self, "_on_Pirate_drop_item")
		assert(OK == ok)
		add_child(my_pirate)

		if randi()%2 == 0:
			my_pirate.position.x = [-380, 380][randi()%2]
			my_pirate.position.y = rand_range(-160, 160)
		else:
			my_pirate.position.y = [-220, 220][randi()%2]
			my_pirate.position.x = rand_range(-240, 240)
		my_pirate.velocity = Vector2(-my_pirate.max_speed, 0).rotated(my_pirate.global_position.angle_to_point($LightHouse.global_position))

func _on_Pirate_shoot(pos: Vector2, bullet: PackedScene):
	if has_node("Player"):
		var my_bullet: Node2D = bullet.instance()
		add_child(my_bullet)
		my_bullet.global_position = pos
		my_bullet.velocity = Vector2(-100, 0).rotated(pos.angle_to_point($Player.global_position))

func _on_Pirate_add_score(score: int, pos: Vector2):
	Globals.score += score
	var new_plus_score: Node2D = plus_score.instance()
	add_child(new_plus_score)
	new_plus_score.global_position = pos
	new_plus_score.init(score)

func _on_Pirate_drop_item(pos: Vector2):
	# Drop an item at random on pirate's death.
	var item: PackedScene = items[randi()%items.size()]
	call_deferred("_deferred_drop_item", item.instance(), pos)

func _deferred_drop_item(item: Node2D, pos: Vector2):
	add_child(item)
	item.global_position = pos

func _on_LightHouse_gameover():
	$HUD/GameOver.show()
	$Music.stop()
	$Player.queue_free()
	$HUD/GlobalAnim.play("gameover")

func _on_Resume_pressed():
	$Pause/Menu.hide()
	get_tree().paused = false

func _on_Settings_pressed():
	Settings.get_node("Background").show()

func _on_Title_pressed():
	get_tree().paused = false
	var ok := get_tree().change_scene("res://menu/TitleScreen.tscn")
	assert(OK == ok)

func goto_outro():
	get_tree().paused = false
	var ok := get_tree().change_scene("res://menu/cutscenes/Outro.tscn")
	assert(OK == ok)
