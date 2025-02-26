extends Node # PromptList script

var words = [
	{"romaji": "neko", "kana": "ねこ"},        # cat (猫)
	{"romaji": "inu", "kana": "いぬ"},         # dog (犬)
	{"romaji": "ne", "kana": "ね"},          # sleep (寝)
	{"romaji": "arigatou", "kana": "ありがとう"},    # thank you (ありがとう)
	{"romaji": "konnichiwa", "kana": "こんにちは"},  # hello (こんにちは)
	{"romaji": "sakura", "kana": "さくら"},      # cherry blossom (桜)
	{"romaji": "tomodachi", "kana": "ともだち"}, # friend (友達)
	{"romaji": "sumimasen", "kana": "すみません"}, # excuse me (すみません)
	{"romaji": "mizu", "kana": "みず"},        # water (水)
]

var phrases = [
	"neko wa kawaī",        # The cat is cute (猫は可愛い)
	"inu wa aruku",         # The dog walks (犬は歩く)
	"arigatou gozaimasu",   # Thank you very much (ありがとうございます)
	"konnichiwa, genki?"    # Hello, how are you? (こんにちは、元気？)
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
	var word = words[randi() % words.size()]
	print("Selected word: ", word["romaji"], " - ", word["kana"])  # Debugging
	return "[center][b]" + word["romaji"] + "[/b]\n[i]" + word["kana"] + "[/i][/center]"

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
