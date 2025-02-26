extends Sprite # Enemy script

export (Color) var blue = Color("#464646")
export (Color) var green = Color("#636363")
export (Color) var red = Color("#a6a6a6")
export (float) var speed = 1.8

onready var outline_sprite = $SpriteBorder 
onready var prompt = $RichTextLabel
onready var prompt_text = prompt.text

# Add reference to wall for collision detection
onready var game_wall = get_node("/root/Main/Wall")
onready var player_health = get_node("/root/Main/PlayerHealth")

func _ready() -> void:
	prompt_text = PromptList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))  # Now includes Kana


func _physics_process(delta: float) -> void:
	global_position.x -= speed
	
	# Check collision with wall using rect_size instead of get_width()
	if global_position.x <= game_wall.rect_global_position.x + game_wall.rect_size.x/2:
		player_health.take_damage()
		queue_free()
func set_active():
	outline_sprite.scale = Vector2(1.2, 1.2)  # Make the outline slightly bigger
	outline_sprite.modulate = Color(1.0, 0.0, 0.0)  # Red outline
	outline_sprite.show()  # Show the outline
func set_inactive():
	outline_sprite.hide()  # Hide the outline

func get_prompt() -> String:
	return prompt_text
	
func set_next_character(next_character_index: int):
	var blue_text = get_bbcode_color_tag(blue) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""
	
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(blue_text + green_text + red_text))
	
func set_center_tags(string_to_center: String):
	return "[center]" + string_to_center + "[/center]"
	
func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
