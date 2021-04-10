extends Node

func _on_MainMenu_started():
	$BiodiversityProgress.show()

func _process(delta):
	$BiodiversityProgress.value = 1000.0 * $World/Simulation.get_diversity()
