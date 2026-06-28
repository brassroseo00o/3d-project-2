extends CanvasLayer

@export_file("*.tscn") var play_level_scene: String = "res://Scenes/1_st_floor.tscn"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/1_st_floor.tscn")
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
