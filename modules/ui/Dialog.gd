extends Sprite

onready var BubbleText = get_child(0)
onready var Text = BubbleText.get_child(0)

export(Array,String) var dialog = ["Hey ! My name is PhyloGenie", "This is the Pangaea, please help me this planet is dying..."]
var isTalking :  bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	BubbleText.visible = false
#	Text.set_bbcode(dialog[page])
#	Text.set_visible_characters(0)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == BUTTON_LEFT && not isTalking :
			GenieSays("Hey ! My name is PhyloGenie")
			
		if Text.get_visible_characters() > Text.get_total_character_count():
			BubbleText.visible = false


func _on_Timer_timeout():
	Text.set_visible_characters(Text.get_visible_characters()+1)

func GenieSays(var text):
	BubbleText.visible = true
	isTalking = true
	Text.set_bbcode(text)
	Text.set_visible_characters(0)

	
