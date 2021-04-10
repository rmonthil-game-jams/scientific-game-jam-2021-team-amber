extends Spatial

func preswap_cell(i, j) -> void:
	pass

func swap_cell(i, j) -> void:
	if $SimulationCore.state[i][j]["type"] == "water":
		$SimulationCore.state[i][j]["type"] = "land"
		$SimulationCore.state[i][j]["biome"] = "temperate"
	else:
		$SimulationCore.state[i][j].erase("biome")
		if $SimulationCore.state[i][j]["type"] == "tree":
			$SimulationCore.state[i][j].erase("species")
		$SimulationCore.state[i][j]["type"] = "water"
	$SimulationVisual.cells[i][j].state = $SimulationCore.state[i][j].duplicate()

func get_diversity() -> float:
	return $SimulationCore.get_diversity()

# internal

func _ready():
	$SimulationVisual.generate_from_state($SimulationCore.state)
	$SimulationVisualUI.generate_from_state($SimulationCore.state)
