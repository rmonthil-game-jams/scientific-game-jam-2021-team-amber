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
		"shovel":
			$Simulation.shovel(i, j)
		"paint_hot":
			$Simulation.paint(i, j, "hot")
		"paint_cold":
			$Simulation.paint(i, j, "cold")

func _on_Selecter_preselected(i, j):
	$Simulation.preshovel(i, j)
