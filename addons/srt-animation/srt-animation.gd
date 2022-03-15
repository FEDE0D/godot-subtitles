tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("SRTImporter", "Node", preload("res://addons/srt-animation/srt_importer_tool.gd"), preload("res://addons/srt-animation/icon.png"))

func _exit_tree():
	remove_custom_type("SRTImporter")

