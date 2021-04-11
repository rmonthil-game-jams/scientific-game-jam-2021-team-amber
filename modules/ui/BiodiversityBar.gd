extends Control

signal bonus(bonus)
signal loss()
signal win()

signal tool_selected(tool_name)

var current_tool = ""

export(Array, float) var bonus_thresholds

var value : float setget _set_value

func _set_value(val : float):
	value = val
	## update
	$Container/TextureProgress.value = value
	for i in range(bonus_thresholds.size()):
		## discover the buttons given the progress bar
		if value >= bonus_thresholds[i]:
			$Container/Bonus.get_child(i).show()
			$Container/Bonus.get_child(i).disabled = false
			emit_signal("bonus", $Container/Bonus.get_child(i).name.to_lower())
	## over
	if value > 100.0:
		emit_signal("win")
	elif value == 0.0:
		emit_signal("loss")
		
func _reset_bonus_rotation():
	for bonus in $Container/Bonus.get_children():
		bonus.rect_rotation = 0.0

func _on_PaintWater_pressed():
	if current_tool != "paint_water":
		current_tool = "paint_water"
		$AnimationPlayer.play("paint_water")
		emit_signal("tool_selected", "paint_water")
		_reset_bonus_rotation()

func _on_PaintTemperate_pressed():
	if current_tool != "paint_temperate":
		current_tool = "paint_temperate"
		$AnimationPlayer.play("paint_temperate")
		emit_signal("tool_selected", "paint_temperate")
		_reset_bonus_rotation()

func _on_PaintHot_pressed():
	if current_tool != "paint_hot":
		current_tool = "paint_hot"
		$AnimationPlayer.play("paint_hot")
		emit_signal("tool_selected", "paint_hot")
		_reset_bonus_rotation()
