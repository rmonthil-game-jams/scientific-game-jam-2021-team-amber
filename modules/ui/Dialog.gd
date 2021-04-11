extends Node2D

signal started(dialogue)
signal finished(dialogue)
signal bubble_finished(dialogue)

onready var Text = get_node("Text")

export(Dictionary) var dialogs
var isTalking :  bool = true
var currentDialogNumber = -1
var currentDialogState : String
var totalStateNumber = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == BUTTON_LEFT && isTalking :
			pass

func StartDialog(dialogue : String, number : int):
	visible = true
	currentDialogState = dialogue
	totalStateNumber = number
	currentDialogNumber = 1
	Text.set_bbcode(dialogs[currentDialogState+ str(currentDialogNumber)])
	Text.set_visible_characters(0)
	currentDialogNumber += 1
	emit_signal("started", dialogue)

func NextDialogue():
	Text.set_bbcode(dialogs[currentDialogState+ str(currentDialogNumber)])
	Text.set_visible_characters(0)
	currentDialogNumber += 1

func _on_Timer_timeout():
	Text.set_visible_characters(Text.get_visible_characters()+1)

func GenieSays(var text : String):
	Text.set_bbcode(dialogs[text+ str(currentDialogNumber)])
	Text.set_visible_characters(0)

func _on_MainMenu_started():
	isTalking = false
	StartDialog("intro", 6)


func _on_TextureButton_pressed():
	if Text.get_visible_characters() > Text.get_total_character_count():
		if currentDialogNumber < totalStateNumber:
			emit_signal("bubble_finished", currentDialogState + str(currentDialogNumber))
			NextDialogue()
		else:
			emit_signal("bubble_finished", currentDialogState + str(currentDialogNumber))
			emit_signal("finished", currentDialogState)
			visible = false
	else :
		Text.set_visible_characters(Text.get_total_character_count())
