extends Control

func _ready():
	$World/Simulation.set_empty_state()

func _on_MainMenu_started():
	$World/Pivot/Camera/Pyllo.angry()

func _process(delta):
	$Bonus.value = $World/DiversityProgress.get_diversity()
	$PhyloGeny.global_position = $World/Pivot/Camera.unproject_position($World/Pivot/Camera/Pyllo.global_transform.origin)

func _on_BiodiversityProgress_tool_selected(tool_name):
	$World.current_tool = tool_name

func _on_PhyloGeny_started(dialogue : String):
	pass

func _on_PhyloGeny_finished(dialogue : String):
	$World/Pivot/Camera/Pyllo.idle()
	match dialogue:
		"win":
			$CreditScene.show()
			$Hint.hide()
			$Win.play()
			$Bonus.hide()
			$World/Simulation.stop()
		"gameover":
			$CreditScene.show()
			$Hint.hide()
			$Win.play()
			$Bonus.hide()
			$World/Simulation.stop()

func _on_PhyloGeny_bubble_finished(dialogue : String):
	match dialogue:
		"intro5":
			$World/Simulation.clear()
			$World/Pivot/Camera/Pyllo.speak()
		"intro6":
			$World/Simulation.set_init_state()
		"intro13":
			$Bonus/Bonus.show()
		"intro15":
			$Hint.show()
			$World/Simulation/SimulationCore.MUTATION_INTENSITY = 0.35

func _on_Achievements_achievement(achievement_name : String):
	match achievement_name:
		"tectonik":
			$PhyloGeny.StartDialog("tectonik", 4)
			$World/Pivot/Camera/Pyllo.happy()
		"kangaroo":
			$PhyloGeny.StartDialog("kangaroo", 4)
			$World/Pivot/Camera/Pyllo.speak()
		"matchmaker":
			$PhyloGeny.StartDialog("matchmaker", 3)
			$World/Pivot/Camera/Pyllo.happy()
#		"okbiomer":
#			$PhyloGeny.StartDialog("okbiomer", 4)

func _on_BiodiversityProgress_achievement(achievement_name):
	match achievement_name:
		"newspecies":
			$PhyloGeny.StartDialog("newspecies", 4)
			$World/Pivot/Camera/Pyllo.happy()
		"slowmotion":
			$PhyloGeny.StartDialog("slowmotion", 5)
			$World/Pivot/Camera/Pyllo.angry()
		"bucket":
			$PhyloGeny.StartDialog("bucket", 9)
			$World/Pivot/Camera/Pyllo.happy()

func _on_BiodiversityProgress_loss():
	$PhyloGeny.StartDialog("gameover", 3)
	$World/Pivot/Camera/Pyllo.angry()

func _on_BiodiversityProgress_win():
	$PhyloGeny.StartDialog("win", 3)
	$World/Pivot/Camera/Pyllo.happy()

func _on_World_achievement(achievement_name):
	yield(get_tree().create_timer(1.0), "timeout")
	$PhyloGeny.StartDialog("sandman", 5)
	$World/Pivot/Camera/Pyllo.happy()

func _on_QuitButton_pressed():
	get_tree().quit()
