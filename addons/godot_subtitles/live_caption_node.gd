extends RichTextLabel
class_name LiveCaption

export(float) var duration = 4.0
export(float, 0, 0.5) var inter_duration = 0.1
export(String, "center", "left", "right", "fill") var alignment = "center"
export(Color) var default_color = Color.white
export(int) var shake_rate = 40
export(int) var shake_level = 7

enum CAPTION_MOOD {
	DEFAULT,
	UPPERCASE,
	QUOTE,
	ITALIC,
	BOLD,
	SHAKE
}

var _timers = []
var _characters = {}
var _last_character: String

func _enter_tree():
	bbcode_enabled = true

func _ready():
	bbcode_enabled = true
	scroll_active = true
	scroll_following = true

func caption(text: String, force_clear: bool = false, timeout: float = duration):
	if force_clear:
		bbcode_text = ""
		for timer in _timers:
			timer.disconnect("timeout", self, "on_timeout")
		_timers.clear()
	
	yield(get_tree().create_timer(inter_duration), "timeout")
	
	var caption = align_text("%s" % text)
	append_bbcode(caption)
	newline()
	
	var timer = get_tree().create_timer(timeout)
	timer.connect("timeout", self, "on_timeout", [timer])
	_timers.append(timer)


func dialog(character: String, text: String, mood: int = CAPTION_MOOD.DEFAULT, force_clear: bool = false, timeout: float = duration):
	var config = _get_character(character)
	var template = mood_text(text, mood)
	if _last_character != character:
		template = "[%s] %s" % [character, mood_text(text, mood)]
	template = color_text(template, config.color)
	_last_character = character
	caption(template, force_clear, timeout)

func descriptive(text: String, force_clear: bool = false, timeout: float = duration):
	_last_character = ""
	var template = color_text("[%s]" % text, default_color)
	caption(template, force_clear, timeout)

func set_character_color(character: String, color: Color):
	var config = _get_character(character)
	config['color'] = color
	_characters[character] = config

func _get_character(character: String):
	if _characters.has(character):
		return _characters[character]
	else:
		return {
			'color': default_color
		}

func color_text(caption: String, color: Color):
	return "[color=#%s]%s[/color]" % [color.to_html(), caption]

func align_text(caption: String):
	match alignment:
		"left": 
			return caption
		"center":
			return "[center]%s[/center]" % caption
		"right":
			return "[right]%s[/right]" % caption
		"fill":
			return "[fill]%s[/fill]" % caption

func mood_text(caption: String, mood: int):
	match mood:
		CAPTION_MOOD.DEFAULT:
			return caption
		CAPTION_MOOD.UPPERCASE:
			return caption.to_upper()
		CAPTION_MOOD.QUOTE:
			return '[i]"%s"[/i]' % caption
		CAPTION_MOOD.ITALIC:
			return '[i]%s[/i]' % caption
		CAPTION_MOOD.BOLD:
			return '[b]%s[/b]' % caption
		CAPTION_MOOD.SHAKE:
			return '[shake rate=%s level=%s]%s[/shake]' % [shake_rate, shake_level, caption]

func on_timeout(timer: SceneTreeTimer):
	_timers.erase(timer)
	
	if get_line_count() > 2:
		remove_line(0)
	else:
		_last_character = ""
		remove_line(0)
	update()
