extends Spatial

signal win()
signal loss()
signal world_event(event_name)

# interface

func restart():
	pass

# internal

func _process(delta : float):
	pass
#	print($Simulation.get_diversity())

func _on_Selecter_selected(i, j):
	$Simulation.shovel(i, j)

func _on_Selecter_preselected(i, j):
	$Simulation.preshovel(i, j)
