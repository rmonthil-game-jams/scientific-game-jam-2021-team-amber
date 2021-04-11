extends Control

func _ready():
	$World/Simulation.set_empty_state()

func _on_MainMenu_started():
	$BiodiversityProgress.show()

func _process(delta):
	$BiodiversityProgress.value = 300.0 * $World/Simulation.get_diversity()

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
	print(dialogue)
	match dialogue:
		"intro5":
			print("poire")
			$World/Simulation.clear()
		"intro6":
			print("pomme")
			$World/Simulation.set_init_state()

func _on_Achievements_achievement(achievement_name : String):
	match achievement_name:
		"tectonik":
			$PhyloGeny.StartDialog("teck", 6)
		"kangaroo":
			pass
