extends Spatial

func _ready():
	$SimulationVisual.generate_from_state($SimulationCore.state)
