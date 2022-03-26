extends Control

func _on_VideoSampleBtn_pressed():
	get_tree().change_scene_to(preload("res://scenes/VideoSample.tscn"))

func _on_LiveCaptionBtn_pressed():
	get_tree().change_scene_to(preload("res://scenes/LiveCaptionSample.tscn"))
