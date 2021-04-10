extends Node

signal world_event(event_name) # achievement

export(NodePath) var WORLD_PATH : NodePath

#cell
#{
#	"type":"tree" or "water" or "land"
#	if tree: 
#		"species":Vector3
#	if tree or land:
#		"biome":"temperate", "cold", "hot"
#}

func _process(delta):
	var simulation_core : Node = get_node(WORLD_PATH).get_node("Simulation/SimulationCore")
	var width : int = simulation_core.WIDTH
	var height : int = simulation_core.HEIGHT
	var simulation_state : Array = simulation_core.state.duplicate()
	# TODO
	for i in range(width):
		for j in range(height):
			var cell : Dictionary = simulation_state[i][j].duplicate()
			
