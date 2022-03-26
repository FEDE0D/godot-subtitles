tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("SRTImporter", "Node", preload("res://addons/godot_subtitles/srt_importer_node.gd"), preload("res://addons/godot_subtitles/icon.png"))
	add_custom_type("LiveCaption", "RichTextLabel", preload("res://addons/godot_subtitles/live_caption_node.gd"), preload("res://addons/godot_subtitles/live_caption_icon.png"))

func _exit_tree():
	remove_custom_type("LiveCaption")
	remove_custom_type("SRTImporter")
