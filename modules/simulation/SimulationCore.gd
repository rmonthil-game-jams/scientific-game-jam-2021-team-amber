extends Node

signal step(state)

const WIDTH : int = 14
const HEIGHT : int = 14

const GLOBAL_PROBABILITY_OF_DEATH : float = 0.05
const GLOBAL_PROBABILITY_OF_REPLICATION : float = 0.5
const GLOBAL_PROBABILITY_OF_MUTATION : float = 0.1

const BIOME_SELECTIVITY_TEMPARATE : float = 4.0
const BIOME_SELECTIVITY_HOT : float = 2.0
const BIOME_SELECTIVITY_COLD : float = 2.0

const MUTATION_INTENSITY : float = 0.2

onready var state : Array = create_empty_state(WIDTH, HEIGHT)

#{
#	"type":"tree" or "water" or "land"
#	if tree: 
#		"species":Vector3
#	if tree or land: 
#		"biome":"temperate", "cold", "hot"
#}

# init

func create_empty_state(width : int, height : int) -> Array:
	var matrix : Array = []
	for i in range(width):
		matrix.append([])  
		for j in range(height):
			matrix[i].append({"type":"tree", "species":Vector3(1.0, 1.0, 1.0).normalized(), "biome":"temperate"})
	return matrix

# process

func step():
	# loop over each cell
	for i in range(WIDTH):
		for j in range(HEIGHT):
			match state[i][j]["type"]:
				"tree":
					var random_number : float = rand_range(0.0, 1.0)
					if random_number < get_cell_probability_of_death(state[i][j]):
						state[i][j]["type"] = "land"
						state[i][j].erase("species")
				"water":
					pass
				"land":
					var random_number : float = rand_range(0.0, 1.0)
					var random_mutation_number : float = rand_range(0.0, 1.0)
					# get probabilities
					var probability_of_replication_south : float = 0.0
					if  j - 1 > 0 and state[i][j-1]["type"] == "tree":
						probability_of_replication_south += 0.25 * get_cell_probability_of_replication(state[i][j-1])
					var probability_of_replication_north : float = probability_of_replication_south
					if j + 1 < HEIGHT and state[i][j+1]["type"] == "tree":
						probability_of_replication_north += 0.25 * get_cell_probability_of_replication(state[i][j+1])
					var probability_of_replication_west : float = probability_of_replication_north
					if i - 1 > 0 and state[i-1][j]["type"] == "tree":
						probability_of_replication_west += 0.25 * get_cell_probability_of_replication(state[i-1][j])
					var probability_of_replication_east : float = probability_of_replication_west
					if i + 1 < WIDTH and state[i+1][j]["type"] == "tree":
						probability_of_replication_east += 0.25 * get_cell_probability_of_replication(state[i+1][j])
					# replace land with tree if replication
					if random_number < probability_of_replication_south:
						state[i][j] = state[i][j-1].duplicate()
						if random_mutation_number < get_cell_probability_of_mutation(state[i][j]):
							mutate(state[i][j])
					elif random_number < probability_of_replication_north:
						state[i][j] = state[i][j+1].duplicate()
						if random_mutation_number < get_cell_probability_of_mutation(state[i][j]):
							mutate(state[i][j])
					elif random_number < probability_of_replication_west:
						state[i][j] = state[i-1][j].duplicate()
						if random_mutation_number < get_cell_probability_of_mutation(state[i][j]):
							mutate(state[i][j])
					elif random_number < probability_of_replication_east:
						state[i][j] = state[i+1][j].duplicate()
						if random_mutation_number < get_cell_probability_of_mutation(state[i][j]):
							mutate(state[i][j])
	# signal
	emit_signal("step", state)

func get_cell_probability_of_death(tree_cell : Dictionary):
	var d : float = 1.0
	match tree_cell["biome"]:
		"temperate":
			d = (BIOME_SELECTIVITY_TEMPARATE * (tree_cell["species"] - Vector3(0.0, 1.0, 0.0)).length() + 1.0) / (BIOME_SELECTIVITY_TEMPARATE + 1.0)
		"hot":
			d = (BIOME_SELECTIVITY_HOT * (tree_cell["species"] - Vector3(1.0, 0.0, 0.0)).length() + 1.0) / (BIOME_SELECTIVITY_HOT + 1.0)
		"cold":
			d = (BIOME_SELECTIVITY_COLD * (tree_cell["species"] - Vector3(0.0, 0.0, 1.0)).length() + 1.0) / (BIOME_SELECTIVITY_COLD + 1.0)
	return GLOBAL_PROBABILITY_OF_DEATH * d

func get_cell_probability_of_replication(tree_cell : Dictionary):
	return GLOBAL_PROBABILITY_OF_REPLICATION

func get_cell_probability_of_mutation(tree_cell : Dictionary):
	return GLOBAL_PROBABILITY_OF_MUTATION # TODO: deal with mutation zones

func mutate(tree_cell : Dictionary):
	tree_cell["species"] += 0.5 * Vector3(
		rand_range(-MUTATION_INTENSITY, MUTATION_INTENSITY), 
		rand_range(-MUTATION_INTENSITY, MUTATION_INTENSITY),
		rand_range(-MUTATION_INTENSITY, MUTATION_INTENSITY)
		)
	tree_cell["species"] = tree_cell["species"].normalized()

# internal

func _ready():
	randomize()

func _on_Timer_timeout():
	step()
