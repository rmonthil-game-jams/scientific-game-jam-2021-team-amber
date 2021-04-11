extends Spatial

var current_tool : String = "shovel"

# interface

func restart():
	pass

# internal

func _process(delta : float):
	pass
#	print($Simulation.get_diversity())

func _on_Selecter_selected(i, j):
	match current_tool:
		"paint_water":
			$Simulation.paint(i, j, "water")
		"paint_temperate":
			$Simulation.paint(i, j, "temperate")
		"paint_hot":
			$Simulation.paint(i, j, "hot")
		"paint_cold":
			$Simulation.paint(i, j, "cold")

func _on_Selecter_preselected(i, j):
	pass
