extends Node

signal world_event(event_name) # achievement

export(NodePath) var WORLD_PATH : NodePath
var cellMap = []
onready var simulation_core : Node = get_node(WORLD_PATH).get_node("Simulation/SimulationCore")
var continents = {}
var indexToSet = 0
onready var width : int = simulation_core.WIDTH
onready var height : int = simulation_core.HEIGHT
#cell
#{
#	"type":"tree" or "water" or "land"
#	if tree: 
#		"species":Vector3
#	if tree or land:
#		"biome":"temperate", "cold", "hot"
#}

func _ready():
	for i in range(width):
		cellMap.append([])
		for j in range(height):
			cellMap[i].append(-1)

func _process(delta):
	var simulation_state : Array = simulation_core.state.duplicate()
	# TODO
	for i in range(width):
		for j in range(height):
			var cell : Dictionary = simulation_state[i][j].duplicate()
			if cellMap[i][j] < 0:
				ContinentDetection(i,j, indexToSet, simulation_state)
				indexToSet += 1
	
	print(continents.size())

func ContinentDetection(var i : int, var j :int, var ctnIndex : int, var sim_state):
	#Register as belonging to a continent
	if not continents.has(ctnIndex) :
		continents[ctnIndex] = 1
	else :
		continents[ctnIndex] += 1
	cellMap[i][j] = ctnIndex
	#Recursion to all adjacents
	if i >0:
		if not sim_state[i-1][j].duplicate().type == "water" && cellMap[i-1][j] < 0:
			ContinentDetection(i-1, j, ctnIndex, sim_state)
		elif cellMap[i-1][j] >= 0:
			continents[ctnIndex] += continents[continents[i-1][j]]
			continents.erase(cellMap[i-1][j])
	if i < width:
		if not sim_state[i+1][j].duplicate().type == "water" && cellMap[i+1][j] < 0:
			ContinentDetection(i+1, j, ctnIndex, sim_state)
		elif cellMap[i+1][j] >= 0:
			continents[ctnIndex] += continents[continents[i+1][j]]
			continents.erase(cellMap[i+1][j])
	if j > 0:
		if not sim_state[i][j-1].duplicate().type == "water" && cellMap[i][j-1] < 0:
			ContinentDetection(i, j-1, ctnIndex, sim_state)
		elif cellMap[i][j-1] >= 0:
			continents[ctnIndex] += continents[continents[i][j-1]]
			continents.erase(cellMap[i][j-1])
	if j < height:
		if not sim_state[i][j+1].duplicate().type == "water" && cellMap[i][j+1] < 0:
			ContinentDetection(i-1, j+1, ctnIndex, sim_state)
		elif cellMap[i][j+1] >= 0:
			continents[ctnIndex] += continents[continents[i][j+1]]
			continents.erase(cellMap[i][j+1])
	
