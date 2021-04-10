extends TextureRect

var mouseOver : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_RetryButton_mouse_entered():
	mouseOver = true
