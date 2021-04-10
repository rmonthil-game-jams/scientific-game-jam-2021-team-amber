extends Spatial

signal selected

var I : int = -1
var J : int = -1

var state : Dictionary = {} setget _set_state

func _set_state(val : Dictionary):
	if val and is_inside_tree():
		if val["type"] == "water":
			$Land.hide()
			$Tree.hide()
		elif val["type"] == "land":
			$Land.show()
			$Tree.hide()
		elif val["type"] == "tree":
			$Land.show()
			$Tree.show()
			$Tree/Folliage.material_override.albedo_color = Color(val["species"].x, val["species"].y, val["species"].z)
	state = val

func _enter_tree():
	_set_state(state)
