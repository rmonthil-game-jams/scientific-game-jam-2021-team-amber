extends Control

func _ready():
	$World/Simulation.set_empty_state()

func _on_MainMenu_started():
	$BiodiversityProgress.show()

func _process(delta):
	$BiodiversityProgress.value = 1000.0 * $World/Simulation.get_diversity()

func _on_BiodiversityProgress_tool_selected(tool_name):
	$World.current_tool = tool_name

var current_tool : String = ""
func _on_PhyloGeny_started(dialogue : String):
	current_tool = $World.current_tool
	$World.current_tool = ""
	$BiodiversityProgress.hide()

func _on_PhyloGeny_finished(dialogue : String):
	$World.current_tool = current_tool
	$BiodiversityProgress.show()

func _on_PhyloGeny_bubble_finished(dialogue : String):
	match dialogue:
		"intro5":
			$World/Simulation.clear()
		"intro6":
			$World/Simulation.set_init_state()
