extends Node
tool

export(String, FILE, "*.srt") var srt_file
export(NodePath) var label_node
export(NodePath) var animation_player_node
export(String) var animation_name
export(float) var animation_step = 0.001
export(String, "Center", "Left", "Right", "Fill") var alignment = "Center"
export(bool) var import_animation setget set_import_animation

const FONT_REGEX_PATTERN: String = '<font color="([^<>.]*)">([^<>.]*)<\/font>'
const TAG_REG_PATTERN: String = '<(\/?)([biu]*)>'

var font_regex: RegEx = RegEx.new()
var tag_regex: RegEx = RegEx.new()

func _ready():
	font_regex.compile(FONT_REGEX_PATTERN)
	tag_regex.compile(TAG_REG_PATTERN)

func set_import_animation(value):
	_import_animation()

func _get_configuration_warning():
	if not srt_file:
		return "SRT file must not be empty"
	
	if not label_node:
		return "Label node must not be empty"
	else:
		var node = get_node(label_node)
		if not node.is_class("Label") and not node.is_class("RichTextLabel"):
			return "Label node must be one of type Label or RichTextLabel"
	
	if not animation_player_node:
		return "AnimationPlayer node must not be empty"
	elif not get_node(animation_player_node).is_class("AnimationPlayer"):
		return "Animation Player node must be of type AnimationPlayer"
	
	if not animation_name:
		return "Animation name must not be empty"
	
	return ""


func _import_animation():
	if !Engine.editor_hint:
		return
	
	var animation_player: AnimationPlayer = get_node(animation_player_node)
	var file_content: Array = read_file(srt_file)
	if file_content.empty():
		print("Error: subtitle is empty")
		return
		
	var animation = map_to_animation(file_content)
	animation_player.add_animation(animation_name, animation)
	
func map_to_animation(file_content: Array) -> Animation:
	var animation = Animation.new()
	var track_idx = animation.add_track(Animation.TYPE_VALUE, 0)
	var animation_length = file_content[file_content.size() - 1].times.to
	var track_path = get_label_animation_path()
	
	animation.track_set_path(track_idx, track_path)
	animation.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
	animation.step = animation_step
	animation.length = animation_length
	
	animation.track_insert_key(track_idx, 0.0, "", 0)
	for line in file_content:
		animation.track_insert_key(track_idx, line.times.from, line.caption, 0)
		animation.track_insert_key(track_idx, line.times.to, "", 0)
	
	return animation

func read_file(file_name: String) -> Array:
	var array = []
	var file = File.new()
	var status = file.open(file_name, File.READ)
	if status != OK:
		print("Error reading file %s" % file_name)
		return []
	
	while !file.eof_reached():
		var counter = read_counter(file)
		if counter == 0 or file.eof_reached():
			break
		
		var times = read_times(file)
		var caption = read_caption(file)
		
		array.append({
			"id": counter,
			"times": times,
			"caption": caption
		})
	
	file.close()
	return array

func read_counter(file: File) -> int:
	var line = file.get_line()
	while line.empty() and !file.eof_reached():
		line = file.get_line()
	return int(line)

func read_times(file: File) -> Dictionary:
	var split = file.get_line().split(" --> ")
	return {
		"from": time_to_float(split[0]),
		"to": time_to_float(split[1])
	}

func read_caption(file: File) -> String:
	var caption = ""
	var line = file.get_line()
	while !line.empty():
		caption += line + "\n"
		line = file.get_line()
	return bb_format(caption)

func time_to_float(time: String) -> float:
	var split = time.replace(",", ".").split_floats(":")
	return split[0] * 60 * 60 + split[1] * 60 + split[2]

func bb_format(caption: String) -> String:
	var new_caption: String = caption
	
	for m in tag_regex.search_all(new_caption):
		new_caption = new_caption.replace(m.get_string(0), '[%s%s]' % [m.get_string(1), m.get_string(2)])
	
	for m in font_regex.search_all(new_caption):
		new_caption = new_caption.replace(m.get_string(0), '[color=%s]%s[/color]' % [m.get_string(1), m.get_string(2)])
	
	return get_alignment() % new_caption

func get_label_animation_path() -> String:
	var path: String = str(get_node(animation_player_node).get_path_to(get_node(label_node))) + ':bbcode_text'
	if path.begins_with("../"):
		path = path.trim_prefix("../")
	return path

func get_alignment() -> String:
	match alignment:
		"Center": 
			return '[center]%s[/center]'
		"Left":
			return '[left]%s[/left]'
		"Right":
			return '[right]%s[/right]'
		"Fill":
			return '[fill]%s[/fill]'
	return '%s'
