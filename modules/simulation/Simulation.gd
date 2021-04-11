extends Spatial

func paint(i : int, j : int, biome : String) -> void:
	if biome == "water":
		$SimulationCore.state[i][j].erase("biome")
		$SimulationCore.state[i][j].erase("species")
		$SimulationCore.state[i][j]["type"] = "water"
		$CreateWater.play()
	else:
		if $SimulationCore.state[i][j]["type"] == "water":
			$SimulationCore.state[i][j]["type"] = "land"
			$CreateRock.play()
		$SimulationCore.state[i][j]["biome"] = biome
	$SimulationVisual.cells[i][j].state = $SimulationCore.state[i][j].duplicate()

#func preshovel(i, j) -> void:
#	pass
#
#func shovel(i, j) -> void:
#	if $SimulationCore.state[i][j]["type"] == "water":
#		$SimulationCore.state[i][j]["type"] = "land"
#		$SimulationCore.state[i][j]["biome"] = "temperate"
#		$CreateRock.play()
#	else:
#		$SimulationCore.state[i][j].erase("biome")
#		if $SimulationCore.state[i][j]["type"] == "tree":
#			$SimulationCore.state[i][j].erase("species")
#		$SimulationCore.state[i][j]["type"] = "water"
#		$CreateWater.play()
#	$SimulationVisual.cells[i][j].state = $SimulationCore.state[i][j].duplicate()

func get_diversity() -> float:
	return $SimulationCore.get_diversity()

# internal

func _ready():
	$SimulationVisual.generate_from_state($SimulationCore.state)
