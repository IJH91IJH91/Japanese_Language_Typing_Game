extends Node # PromptList script

var words = [
	"neko",	"kana",	"inu", 	"kana"   
]

var phrases = [
	"neko wa kawai",        # The cat is cute (猫は可愛い)
	"inu wa aruku",         # The dog walks (犬は歩く)
	"arigatou gozaimasu"   # Thank you very much (ありがとうございます)
]

var sentences = [
	"tomodachi to ikimashita",             # I went with a friend (友達と行きました)
	"sumimasen, mizu o kudasai"           # Excuse me, please give me water (すみません、水をください)
]

var special_characters = [
	".",
	"!",
	"?"
]

func get_prompt() -> String:
	var word_index = randi() % words.size()
	var special_index = randi() % special_characters.size()
	
	var word = words[word_index]
	var special_character = special_characters[special_index]
	# var actual_word = words.substr(0, 1).to_upper() + word.substr(1).to_lower
	return word + special_character

func get_phrase_prompt() -> String:
	var phrase_index = randi() % phrases.size()
	var special_index = randi() % special_characters.size()
	
	var phrase = phrases[phrase_index]
	var special_character = special_characters[special_index]

	return phrase + special_character

func get_sentence_prompt() -> String:
	var sentence_index = randi() % sentences.size()
	var special_index = randi() % special_characters.size()
	
	var sentence = sentences[sentence_index]
	var special_character = special_characters[special_index]

	return sentence + special_character
