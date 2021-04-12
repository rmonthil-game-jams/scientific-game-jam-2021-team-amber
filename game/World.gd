extends Spatial

signal achievement(achievement_name)

var current_tool : String = "shovel"
var sandmanOnce : bool = false

# interface

func restart():
	pass

# internal

func _process(delta : float):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		_on_Selecter_up()

func _on_Selecter_selected(i, j):
	match current_tool:
		"paint_water":
			$Simulation.paint(i, j, "water")
		"paint_temperate":
			$Simulation.paint(i, j, "temperate")
		"paint_hot":
			$Simulation.paint(i, j, "hot")
			if not sandmanOnce :
				emit_signal("achievement", "sandman")
				sandmanOnce = true
		"paint_cold":
			$Simulation.paint(i, j, "cold")

func _on_Selecter_preselected(i, j):
	pass

func _on_StartRock_finished():
	$LoopRock.play()

func _on_StartWater_finished():
	$LoopWater.play()

func _on_Selecter_down():
	match current_tool:
		"paint_water":
			$StartWater.play()
		"paint_temperate":
			$StartRock.play()
		"paint_hot":
			$StartRock.play()
		"paint_cold":
			$StartRock.play()

func _on_Selecter_up():
	$StartRock.stop()
	$LoopRock.stop()
	$StartWater.stop()
	$LoopWater.stop()
