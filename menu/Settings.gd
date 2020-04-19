extends CanvasLayer

onready var music_button: TextureButton = $Background/Rows/Music
onready var sfx_button: TextureButton = $Background/Rows/Sfx

func _ready():
	$Background.hide()

func _on_Back_pressed():
	$Background.hide()

func _on_Music_pressed():
	AudioServer.set_bus_mute(2, not music_button.pressed)
	music_button.get_node("Label").text = "Music: " + ("on" if music_button.pressed else "off")

func _on_Sfx_pressed():
	$Background/Rows/TestSound.play()
	AudioServer.set_bus_mute(1, not sfx_button.pressed)
	sfx_button.get_node("Label").text = "Soundfx: " + ("on" if sfx_button.pressed else "off")
