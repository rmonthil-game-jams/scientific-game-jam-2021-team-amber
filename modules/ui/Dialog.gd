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

var dialogQueue : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == BUTTON_LEFT && isTalking :
			pass

func StartDialog(dialogue : String, number : int):
	if not dialogQueue:
		dialogQueue.append({"dialogue":dialogue, "number":number})
		_on_TimerQueue_timeout()
	else:
		dialogQueue.append({"dialogue":dialogue, "number":number})

func NextDialogue():
	Text.text = dialogs[currentDialogState+ str(currentDialogNumber)]
	Text.set_visible_characters(0)
	currentDialogNumber += 1

func _on_Timer_timeout():
	Text.set_visible_characters(Text.get_visible_characters()+1)

func GenieSays(var text : String):
	Text.text = dialogs[text+ str(currentDialogNumber)]
	Text.set_visible_characters(0)

func _on_MainMenu_started():
	isTalking = false
	StartDialog("intro", 16)

func _on_TextureButton_pressed():
	if Text.get_visible_characters() > Text.get_total_character_count():
		if currentDialogNumber < totalStateNumber:
			emit_signal("bubble_finished", currentDialogState + str(currentDialogNumber))
			NextDialogue()
		else:
			emit_signal("bubble_finished", currentDialogState + str(currentDialogNumber))
			emit_signal("finished", currentDialogState)
			visible = false
			$TimerVoice.stop()
			dialogQueue.pop_front()
			if dialogQueue:
				$TimerQueue.start()
	else :
		Text.set_visible_characters(Text.get_total_character_count())

func _on_TimerVoice_timeout():
	var i = randi() % 6
	get_node("Voice" + str(i)).play()

func _on_TimerQueue_timeout():
	# extract
	var dialogue : String = dialogQueue.front()["dialogue"]
	var number : int = dialogQueue.front()["number"]
	# start
	$AudioStreamPlayer.play()
	visible = true
	currentDialogState = dialogue
	totalStateNumber = number
	currentDialogNumber = 1
	Text.text = dialogs[currentDialogState+ str(currentDialogNumber)]
	Text.set_visible_characters(0)
	currentDialogNumber += 1
	emit_signal("started", dialogue)
	$TimerVoice.start()
	_on_TimerVoice_timeout()
