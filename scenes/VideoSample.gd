extends Control

func _ready():
	$OptionButton.grab_focus()

func _on_OptionButton_item_selected(index):
	var animation_name = "subtitles-eng" if index == 0 else "subtitles-es"
	var position = $AnimationPlayer.current_animation_position
	$AnimationPlayer.play(animation_name)
	$AnimationPlayer.seek(position, true)

func _on_BackBtn_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
