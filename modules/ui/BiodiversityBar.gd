extends Control

onready var bar = get_node("BioBar")
onready var tween = bar.get_child(0)

export(Array, float) var bonusPercentages

var biodiversityCount : float = 12;
var bonuses : Array

var mouseOver1 : bool = false
var mouseOver2 : bool = false
var mouseOver3 : bool = false
var mouseOver4 : bool = false

var currentButton = ""
#func CreateBonus():
#	for i in range(bonusPercentages.size()):
#		pass
#	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.value = biodiversityCount
	var barLength = bar.margin_right
	
	bonuses = tween.get_children()
	
	for i in range(bonuses.size()):
		bonuses[i].modulate.a = 0
		bonuses[i].rect_scale = Vector2(0.8,0.8)


func _process(delta):
	
	## Update bar value
	bar.value += 0.1
	
	for i in range(bonuses.size()):
		
		## Discover the buttons given the progress bar
		if bar.value >= bonusPercentages[i] :
			bonuses[i].modulate.a = 1


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if mouseOver1 && bonusPercentages[0] <= bar.value :
				if currentButton == "neutral" :
					Disable($BioBar/Tween/Neutral)
					currentButton = ""
					
				else : 
					Enable($BioBar/Tween/Neutral)
					currentButton = "neutral"
				
			if mouseOver2 && bonusPercentages[1] <= bar.value :
				if currentButton == "tropical" :
					Disable($BioBar/Tween/Tropical)
					currentButton = ""
				else : 
					Enable($BioBar/Tween/Tropical)
					currentButton = "tropical"
			
			if mouseOver3 && bonusPercentages[2] <= bar.value :
				if currentButton == "hot" :
					Disable($BioBar/Tween/Hot)
					currentButton = ""
				else : 
					Enable($BioBar/Tween/Hot)
					currentButton = "hot"
			
			if mouseOver4 && bonusPercentages[3] <= bar.value :
				if currentButton == "cold" :
					Disable($BioBar/Tween/Cold)
					currentButton = ""
				else : 
					Enable($BioBar/Tween/Cold)
					currentButton = "cold"



func _on_Bonus1_mouse_entered():
	mouseOver1 = true
func _on_Bonus1_mouse_exited():
	mouseOver1 = false
	
func _on_Bonus2_mouse_entered():
	mouseOver2 = true
func _on_Bonus2_mouse_exited():
	mouseOver2 = false

func _on_Bonus3_mouse_entered():
	mouseOver3 = true
func _on_Bonus3_mouse_exited():
	mouseOver3 = false
	
func _on_Bonus4_mouse_entered():
	mouseOver4 = true
func _on_Bonus4_mouse_exited():
	mouseOver4 = false


func Enable(var TexRect):
	
	for i in range(bonuses.size()):
		if bonuses[i] != TexRect:
			Disable(bonuses[i])
		else :
			tween.interpolate_property(TexRect, "rect_scale", TexRect.rect_scale, Vector2(1.15,1.15),0.05)
			tween.start()
	
func Disable(var TexRect):
	tween.interpolate_property(TexRect, "rect_scale", TexRect.rect_scale, Vector2(0.8,0.8),0.05)
	tween.start()
