extends Control

signal achievement(achievement_name)
signal bonus(bonus)
signal loss()
signal win()

signal tool_selected(tool_name)

var current_tool = ""
var newSpeciesOnce = false
var slowMotionOnce = false
var unlockToolOnce = false
export(Array, float) var bonus_thresholds
onready var sim_step : Node = get_node("../World/Simulation/SimulationCore")

var value : float = 1.0 setget _set_value

func _set_value(val : float):
	value = val
	## update
	$TextureProgress.value = value
	for i in range(bonus_thresholds.size()):
		## discover the buttons given the progress bar
		if value >= bonus_thresholds[i]:
			if not unlockToolOnce :
				emit_signal("achievement", "bucket")
				unlockToolOnce = true
			$Bonus.get_child(i).show()
			$Bonus.get_child(i).disabled = false
			emit_signal("bonus", $Bonus.get_child(i).name.to_lower())
	## over
	if value >= 17 && not newSpeciesOnce:
		emit_signal("achievement","newspecies")
		newSpeciesOnce = true
	if value <= 30 && sim_step.numberOfSteps > 100 && not slowMotionOnce:
		emit_signal("achievement", "slowmotion")
		slowMotionOnce = true
	if value > 100.0:
		if visible:
			emit_signal("win")
	elif value == 0.0:
		if visible:
			emit_signal("loss")
		
func _reset_bonus_rotation():
	for bonus in $Bonus.get_children():
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
