extends Node

signal achievement(achievement_name) # achievement

export(NodePath) var WORLD_PATH : NodePath
var cellMap = []
onready var simulation_core : Node = get_node(WORLD_PATH).get_node("Simulation/SimulationCore")
var continents = {}
var indexToSet = 0
onready var width : int = simulation_core.WIDTH
onready var height : int = simulation_core.HEIGHT
var onceTectonik : bool = false
var onceIsland : bool = false

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
	# continent detection
	for i in range(width):
		for j in range(height):
			if cellMap[i][j] < 0:
				ContinentDetection(i,j, indexToSet, simulation_state)
				indexToSet +=1
	for i in range(width):
		cellMap.append([])
		for j in range(height):
			cellMap[i][j] = -1
	indexToSet = 0
	for key in continents.keys():
		if continents[key] <=1 : 
			continents.erase(key)
	# achievements detection
	## Tectonik Master
	var numberOfContinent = 0
	var numberOfIslands = 0
	var totalContinentArea = 0
	print(continents)
	for continent in continents:
		var size : int = continents[continent]
		totalContinentArea += size
	for continent in continents:
		var size : int = continents[continent]
		if size > totalContinentArea * 0.25:
			numberOfContinent += 1
		else :
			numberOfIslands += 1
	print(numberOfContinent)
	print(numberOfIslands)
	if numberOfContinent >1 && not onceTectonik :
		emit_signal("achievement", "tectonik")
		onceTectonik = true
	if numberOfIslands > 1 && not onceIsland :
		emit_signal("achievement", "kangaroo")
		onceIsland = true
	continents.clear()

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
		elif cellMap[i-1][j] >= 0 && cellMap[i-1][j] != ctnIndex && not sim_state[i-1][j].duplicate().type == "water":
			if continents.has(cellMap[i-1][j]) && continents.has(ctnIndex):
				continents[ctnIndex] += continents[cellMap[i-1][j]]
				ChangeContinent(i-1,j,ctnIndex,cellMap[i-1][j], sim_state)
				continents.erase(cellMap[i-1][j])
	if i < width-1:
		if not sim_state[i+1][j].duplicate().type == "water" && cellMap[i+1][j] < 0:
			ContinentDetection(i+1, j, ctnIndex, sim_state)
		elif not sim_state[i+1][j].duplicate().type == "water" && cellMap[i+1][j] >= 0 && cellMap[i+1][j] != ctnIndex:
			if continents.has(cellMap[i+1][j]) && continents.has(ctnIndex):
				continents[ctnIndex] += continents[cellMap[i+1][j]]
				ChangeContinent(i+1,j,ctnIndex,cellMap[i+1][j], sim_state)
				continents.erase(cellMap[i+1][j])
	if j > 0:
		if not sim_state[i][j-1].duplicate().type == "water" && cellMap[i][j-1] < 0:
			ContinentDetection(i, j-1, ctnIndex, sim_state)
		elif not sim_state[i][j-1].duplicate().type == "water" && cellMap[i][j-1] >= 0 && cellMap[i][j-1] != ctnIndex:
			if continents.has(cellMap[i][j-1]) && continents.has(ctnIndex):
				continents[ctnIndex] += continents[cellMap[i][j-1]]
				ChangeContinent(i,j-1,ctnIndex,cellMap[i][j-1], sim_state)
				continents.erase(cellMap[i][j-1])
	if j < height-1:
		if not sim_state[i][j+1].duplicate().type == "water" && cellMap[i][j+1] < 0:
			ContinentDetection(i, j+1, ctnIndex, sim_state)
		elif  not sim_state[i][j+1].duplicate().type == "water" && cellMap[i][j+1] >= 0 && cellMap[i][j+1] != ctnIndex:
			if continents.has(cellMap[i][j+1]) && continents.has(ctnIndex):
				continents[ctnIndex] += continents[cellMap[i][j+1]]
				ChangeContinent(i,j+1,ctnIndex,cellMap[i][j+1], sim_state)
				continents.erase(cellMap[i][j+1])

func ChangeContinent(var i : int, var j :int, var newIndex : int, var oldIndex : int, var sim_state):
	cellMap[i][j] = newIndex
	#Recursion to all adjacents
	if i >0:
		if sim_state[i-1][j].type == "water":
			cellMap[i-1][j] = -1
		elif cellMap[i-1][j] == oldIndex :
			ChangeContinent(i-1, j, newIndex, oldIndex, sim_state)
	if i < width-1:
		if sim_state[i+1][j].type == "water":
			cellMap[i+1][j] = -1
		elif cellMap[i+1][j] == oldIndex :
			ChangeContinent(i+1, j, newIndex, oldIndex, sim_state)
	if j > 0:
		if sim_state[i][j-1].type == "water":
			cellMap[i][j-1] = -1
		elif cellMap[i][j-1] == oldIndex :
			ChangeContinent(i, j-1, newIndex, oldIndex, sim_state)
	if j < height-1:
		if sim_state[i][j+1].type == "water":
			cellMap[i][j+1] = -1
		elif cellMap[i][j+1] == oldIndex :
			ChangeContinent(i, j+1, newIndex, oldIndex,sim_state)
