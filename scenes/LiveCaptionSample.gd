extends Control

export(NodePath) onready var subtitle = get_node(subtitle) as LiveCaption
export(NodePath) onready var mood_list = get_node(mood_list) as ItemList
export(NodePath) onready var force_clear_btn = get_node(force_clear_btn) as CheckButton
export(NodePath) onready var custom_caption_text_edit = get_node(custom_caption_text_edit) as TextEdit

var characters = {
	'Alyx Vance': [
		"Dr. Freeman, I pressume?",
		"Good thing you've got your hazard suit on. This stuff's nasty. Got room for two in there?"
	],
	'G-Man': [
		"Time to choose...",
		"Wisely done, Mr. Freeman! I will see you up ahead.",
		"Well, it looks like we won't be working together."
	],
	'Dr. Breen': [
		"Welcome. Welcome to City 17.",
		"You have chosen, or been chosen, to relocate to one of our finest remaining urban centers.",
		"I have been proud to call City 17 my home. And so, whether you are here to stay, or passing through on your way to parts unknown, welcome to City 17."
	]
}

var descriptions = [
	"A portal appears",
	"Scanner Click",
	"Knock knock knock!",
	"EXPLOSION!",
	"Door sound"
]

func _ready():
	mood_list.select(0)
	subtitle.set_character_color("Alyx Vance", Color.cornflower)
	subtitle.set_character_color("G-Man", Color.gray)
	subtitle.set_character_color("Dr. Breen", Color.cyan)
	$PanelContainer/Panel/VBoxContainer/VBoxContainer3/TextEdit.text = tr("live_text_2_custom_text")

func _on_character_button_pressed(character_name):
	var captions = characters[character_name]
	var caption = captions[randi() % captions.size()]
	
	var selected_mood = mood_list.get_item_text(mood_list.get_selected_items()[0])
	var mood = LiveCaption.CAPTION_MOOD.get(selected_mood)
	
	subtitle.dialog(character_name, caption, mood, force_clear_btn.pressed)

func _on_descriptive_caption_button_pressed():
	var caption = descriptions[randi() % descriptions.size()]
	subtitle.descriptive(caption, force_clear_btn.pressed)

func _on_CustomCaptionBtn_pressed():
	subtitle.caption(custom_caption_text_edit.text, force_clear_btn.pressed)

func _on_BackBtn_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
