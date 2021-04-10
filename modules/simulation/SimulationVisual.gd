extends Spatial

const DX : float = 1.0

var width : int = 0
var height : int = 0
var cells : Array = []

func generate_from_state(state : Array):
	# clean
	for cell in $Cells.get_children():
		cell.queue_free()
	# init
	width = state.size()
	height = state[0].size()
	cells = []
	# generation loop
	for i in range(width):
		cells.append([])
		for j in range(height):
			# create cell
			cells[i].append(preload("res://modules/simulation/SimulationVisualCell.tscn").instance())
			$Cells.add_child(cells[i][j])
			# set cell parameters
			cells[i][j].translation = Vector3((i - width/2) * DX, 0.0, (j - height/2) + DX)
			cells[i][j].I = i
			cells[i][j].J = j
			# set state
			cells[i][j].state = state[i][j].duplicate()

func update_to_state(state : Array):
	# generation loop
	for i in range(width):
		for j in range(height):
			if cells[i][j].state != state[i][j]:
				cells[i][j].state = state[i][j].duplicate()

func _on_SimulationCore_step(state : Array):
	update_to_state(state)
