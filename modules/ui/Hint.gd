extends Control

onready var core : Node = get_node("../World/Simulation/SimulationCore")
onready var achievements : Node = get_node("../Achievements")
onready var bioDiv : Node = get_node("../Biodiversity")
onready var Genie : Node = get_node("../PhyloGeny")

func _process(delta):
	if core.isAllSet :
		visible = true
	else :
		visible = false

func _on_TextureButton_pressed():
	#Achievements from achievement script
	if  not achievements.onceTectonik :
		Genie.StartDialog("hint_tectonik", 1)
	if  not achievements.onceIsland :
		Genie.StartDialog("hint_kangaroo", 1)
	# from Biodiversitybar script
	if  not bioDiv.newSpeciesOnce :
		Genie.StartDialog("hint_newspecies", 1)
	if  not bioDiv.sandmanOnce :
		Genie.StartDialog("hint_sandman", 1)
