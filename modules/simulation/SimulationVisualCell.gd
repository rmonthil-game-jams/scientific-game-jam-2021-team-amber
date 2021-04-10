extends Spatial

var state : Dictionary = {} setget _set_state

func _set_state(val : Dictionary):
	if val and is_inside_tree():
		if val["type"] == "water":
			$MeshInstance.hide()
		elif val["type"] == "land":
			$MeshInstance.show()
			$MeshInstance.material_override.albedo_color = Color.white
		elif val["type"] == "tree":
			$MeshInstance.show()
			$MeshInstance.material_override.albedo_color = Color(val["species"].x, val["species"].y, val["species"].z)
	state = val

func _enter_tree():
	_set_state(state)
