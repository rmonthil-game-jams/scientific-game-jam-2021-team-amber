extends Control

func _ready():
	$Achievements.set_process(false)

func _on_MainMenu_started():
	$BiodiversityProgress.show()

func _process(delta):
	$BiodiversityProgress.value = 1000.0 * $World/Simulation.get_diversity()

func _on_BiodiversityProgress_tool_selected(tool_name):
	$World.current_tool = tool_name
