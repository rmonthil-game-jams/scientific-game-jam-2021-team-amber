extends Control

func _on_MainMenu_started():
	$BiodiversityProgress.show()

func _process(delta):
	$BiodiversityProgress.value = 300.0 * $World/Simulation.get_diversity()

func _on_BiodiversityProgress_tool_selected(tool_name):
	$World.current_tool = tool_name

var current_tool : String = ""
func _on_PhyloGeny_started():
	current_tool = $World.current_tool
	$World.current_tool = ""
	$BiodiversityProgress.hide()

func _on_PhyloGeny_finished():
	$World.current_tool = current_tool
	$BiodiversityProgress.show()
