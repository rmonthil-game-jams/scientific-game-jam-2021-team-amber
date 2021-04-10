extends Control

signal selected

var I : int = -1
var J : int = -1

var state : Dictionary = {} setget _set_state

func _set_state(val : Dictionary):
	if val and is_inside_tree():
		if val["type"] == "water":
			$Folliage.hide()
			$Land.color = Color(0.3, 0.7, 1.0)
		elif val["type"] == "land":
			$Folliage.hide()
			match val["biome"]:
				"temperate":
					$Land.color = Color(0.3, 1.0, 0.5)
				"hot":
					$Land.color = Color(0.7, 0.6, 0.3)
				"cold":
					$Land.color = Color(1.0, 1.0, 1.0)
		elif val["type"] == "tree":
			$Land.show()
			match val["biome"]:
				"temperate":
					$Land.color = Color(0.3, 1.0, 0.5)
				"hot":
					$Land.color = Color(0.7, 0.6, 0.3)
				"cold":
					$Land.color = Color(1.0, 1.0, 1.0)
			$Folliage.show()
			$Folliage.color = Color(val["species"].x, val["species"].y, val["species"].z)
	state = val

func _enter_tree():
	_set_state(state)
