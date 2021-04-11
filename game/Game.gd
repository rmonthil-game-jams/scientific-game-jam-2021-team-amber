extends Control

func _ready():
	$World/Simulation.set_empty_state()

func _on_MainMenu_started():
	$BiodiversityProgress.show()
	$World/Pivot/Camera/Pyllo.angry()

func _process(delta):
	$BiodiversityProgress.value = 300.0 * $World/Simulation.get_diversity()
	$PhyloGeny.global_position = $World/Pivot/Camera.unproject_position($World/Pivot/Camera/Pyllo.global_transform.origin)

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
	$World/Pivot/Camera/Pyllo.idle()

func _on_PhyloGeny_bubble_finished(dialogue : String):
	match dialogue:
		"intro5":
			$World/Simulation.clear()
		"intro6":
			$World/Simulation.set_init_state()

func _on_Achievements_achievement(achievement_name : String):
	match achievement_name:
		"tectonik":
			$PhyloGeny.StartDialog("tectonik", 3)
			$World/Pivot/Camera/Pyllo.happy()
		"kangaroo":
			$PhyloGeny.StartDialog("kangaroo", 3)
			$World/Pivot/Camera/Pyllo.speak()
		"matchmaker":
			$PhyloGeny.StartDialog("matchmaker", 2)
			$World/Pivot/Camera/Pyllo.happy()
		"bucket":
			$PhyloGeny.StartDialog("bucket", 8)
			$World/Pivot/Camera/Pyllo.angry()
#		"okbiomer":
#			$PhyloGeny.StartDialog("okbiomer", 4)
		"sandman":
			$PhyloGeny.StartDialog("sandman", 4)
			$World/Pivot/Camera/Pyllo.happy()

func _on_BiodiversityProgress_achievement(achievement_name):
	match achievement_name:
		"newspecies":
			$PhyloGeny.StartDialog("newspecies", 3)
		"slowmotion":
			$PhyloGeny.StartDialog("slowmotion", 2)

func _on_BiodiversityProgress_win():
	$CreditScene.show()
