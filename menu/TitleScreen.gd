extends VBoxContainer

func _ready():
	$Buttons/Play.grab_focus()
	if Globals.high_score > 0:
		$HighScore.text = "Highest score: " + str(Globals.high_score)
	else:
		$HighScore.text = "Will you protect the light?"

func _on_Play_pressed():
	get_tree().change_scene("res://menu/cutscenes/Intro.tscn")

func _on_Settings_pressed():
	Settings.get_node("Background").show()

func _on_Quit_pressed():
	get_tree().quit()
