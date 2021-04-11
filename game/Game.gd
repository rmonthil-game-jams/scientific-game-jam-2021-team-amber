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
	match dialogue:
		"intro5":
			$World/Simulation.clear()
		"intro6":
			$World/Simulation.set_init_state()

func _on_Achievements_achievement(achievement_name : String):
	match achievement_name:
		"tectonik":
			print("tectonik")
			$PhyloGeny.StartDialog("tectonik", 3)
		"kangaroo":
			print("kangaroo")
			$PhyloGeny.StartDialog("kangaroo", 3)
		"matchmaker":
			print("matchmaker")
			$PhyloGeny.StartDialog("matchmaker", 2)
		"bucket":
			print("bucket")
			$PhyloGeny.StartDialog("bucket", 8)
#		"okbiomer":
#			$PhyloGeny.StartDialog("okbiomer", 4)
		"sandman":
			$PhyloGeny.StartDialog("sandman", 4)

func _on_BiodiversityProgress_achievement(achievement_name):
	match achievement_name:
		"newspecies":
			$PhyloGeny.StartDialog("newspecies", 3)
		"slowmotion":
			$PhyloGeny.StartDialog("slowmotion", 2)
