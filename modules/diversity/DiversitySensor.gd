extends Node

onready var SIMULATION_CORE : Node = get_tree().root.find_node("SimulationCore", true, false)

const PDF_STEP : float = TAU / 20.0
const PDF_N_THETA : int = int(round(PI / PDF_STEP))
const PDF_N_PHI : int = int(round(TAU / PDF_STEP))

var pdf : Array = []

func get_diversity() -> float:
	var diversity : float = 0.0
	for i in range(PDF_N_THETA):
		for j in range(PDF_N_PHI):
			if pdf[i][j] > 0.0:
				diversity += 1.0
	return diversity

func update_pdf() -> void:
	if SIMULATION_CORE.state:
		# init
		for i in range(PDF_N_THETA):
			for j in range(PDF_N_PHI):
				pdf[i][j] = 0.0
		# compute pdf
		for i in range(SIMULATION_CORE.WIDTH):
			for j in range(SIMULATION_CORE.HEIGHT):
				if SIMULATION_CORE.state[i][j]["type"] == "tree":
					var theta : float = atan2(sqrt(pow(SIMULATION_CORE.state[i][j]["species"][0], 2) + pow(SIMULATION_CORE.state[i][j]["species"][1], 2)), SIMULATION_CORE.state[i][j]["species"][2])
					var phi : float = atan2(SIMULATION_CORE.state[i][j]["species"][1], SIMULATION_CORE.state[i][j]["species"][0])
					var i_theta : int = min(int(theta/PDF_STEP), PDF_N_THETA-1)
					var j_phi : int = min(int(phi/PDF_STEP), PDF_N_PHI-1)
					pdf[i_theta][j_phi] += 1.0

# internal

func _ready():
	pdf = []
	for i in range(PDF_N_THETA):
		pdf.append([])
		for j in range(PDF_N_PHI):
			pdf[i].append(0.0)

## old version
#func get_old_diversity() -> float:
#	if state:
#		# average
#		var n_trees : int = 0
#		var average : Array = [0.0, 0.0, 0.0]
#		for i in range(WIDTH):
#			for j in range(HEIGHT):
#				if state[i][j]["type"] == "tree":
#					for k in range(3):
#						average[k] += state[i][j]["species"][k]
#					n_trees += 1
#		if n_trees > 0:
#			for k in range(3):
#				average[k] /= n_trees
#			# deviation
#			var variance : Array = [0.0, 0.0, 0.0]
#			for i in range(WIDTH):
#				for j in range(HEIGHT):
#					if state[i][j]["type"] == "tree":
#						for k in range(3):
#							variance[k] += (state[i][j]["species"][k] - average[kx]) * (state[i][j]["species"][kj] - average[kj])
#			var deviation : Array = [0.0, 0.0, 0.0]
#			for k in range(3):
#				variance[k] = variance[k] / n_trees
#				deviation[k] = sqrt(abs(variance[k]))
#			# diversity
#			var diversity : float = 0.0
#			for k in range(0, 3):
#				diversity += deviation[k]
#			return diversity / 3
#		else:
#			return 0.0
#	else:
#		return 0.0
