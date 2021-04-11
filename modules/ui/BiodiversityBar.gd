extends Control

signal bonus(bonus)
signal loss()
signal win()

signal tool_selected(tool_name)

var current_tool = ""

export(Array, float) var bonus_thresholds

var value : float setget _set_value

func _ready():
	_on_Shovel_pressed()

func _set_value(val : float):
	value = val
	## update
	$Container/TextureProgress.value = value
	for i in range(bonus_thresholds.size()):
		## discover the buttons given the progress bar
		if value >= bonus_thresholds[i]:
			$Container/Bonus.get_child(i + 1).show()
			$Container/Bonus.get_child(i + 1).disabled = false
			emit_signal("bonus", $Container/Bonus.get_child(i + 1).name.to_lower())
	## over
	if value > 100.0:
		emit_signal("win")
	elif value == 0.0:
		emit_signal("loss")

func _on_Shovel_pressed():
	if current_tool != "shovel":
		current_tool = "shovel"
		$AnimationPlayer.play("shovel")
		emit_signal("tool_selected", "shovel")

func _on_PaintHot_pressed():
	if current_tool != "paint_hot":
		current_tool = "paint_hot"
		$AnimationPlayer.play("paint_hot")
		emit_signal("tool_selected", "paint_hot")
