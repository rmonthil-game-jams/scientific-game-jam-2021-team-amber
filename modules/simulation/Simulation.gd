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

func get_diversity() -> float:
	return $SimulationCore.get_diversity()

func clear() -> void:
	for i in range($SimulationCore.WIDTH):
		for j in range($SimulationCore.HEIGHT):
			$SimulationCore.state[i][j].erase("biome")
			$SimulationCore.state[i][j].erase("species")
			$SimulationCore.state[i][j]["type"] = "water"
			$SimulationVisual.cells[i][j].state = $SimulationCore.state[i][j].duplicate()
	$CreateWater.play()

func set_empty_state() -> void:
	$SimulationCore.MUTATION_INTENSITY = 0.0
	$SimulationCore.GLOBAL_PROBABILITY_OF_DEATH = 0.8
	$SimulationCore.state = $SimulationCore.create_empty_state()
	$SimulationVisual.generate_from_state($SimulationCore.state)
	$CreateRock.play()

func set_init_state() -> void:
	$SimulationCore.MUTATION_INTENSITY = 0.6
	$SimulationCore.GLOBAL_PROBABILITY_OF_DEATH = 0.2
	$SimulationCore.state = $SimulationCore.create_init_state()
	$SimulationVisual.generate_from_state($SimulationCore.state)
	$CreateRock.play()
