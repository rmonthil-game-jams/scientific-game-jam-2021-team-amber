extends Spatial

func preswap_cell(i, j):
	pass

func swap_cell(i, j):
	if $SimulationCore.state[i][j]["type"] == "water":
		$SimulationCore.state[i][j]["type"] = "land"
		$SimulationCore.state[i][j]["biome"] = "temperate"
	else:
		$SimulationCore.state[i][j]["type"] = "water"
		$SimulationCore.state[i][j].erase("biome")
		if $SimulationCore.state[i][j]["type"] == "tree":
			$SimulationCore.state[i][j].erase("species")
	$SimulationVisual.cells[i][j].state = $SimulationCore.state[i][j]

# internal

func _ready():
	$SimulationVisual.generate_from_state($SimulationCore.state)
