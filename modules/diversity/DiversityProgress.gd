extends Spatial

export(float) var MAX_DIVERSITY : float = 25.0

# interface

func get_diversity() -> float:
	return $DiversitySensor.get_diversity() / MAX_DIVERSITY

# bar

var blocks : Dictionary = {}

func _process(_delta):
	$DiversitySensor.update_pdf()
	# update bar
	for i_theta in range($DiversitySensor.PDF_N_THETA):
		for j_phi in range($DiversitySensor.PDF_N_PHI):
			var key : String = str(i_theta) + "_" + str(j_phi)
			if $DiversitySensor.pdf[i_theta][j_phi] > 0.0:
				if not key in blocks:
					# create new cube
					var new_mesh_instance : MeshInstance = MeshInstance.new()
					new_mesh_instance.mesh = CubeMesh.new()
					new_mesh_instance.mesh.size.x = $Reference.mesh.size.x
					new_mesh_instance.mesh.size.y = $Reference.mesh.size.y / MAX_DIVERSITY
					new_mesh_instance.mesh.size.z = $Reference.mesh.size.z
					new_mesh_instance.material_override = SpatialMaterial.new()
					# compute color
					var theta : float = $DiversitySensor.PDF_STEP * (i_theta + 0.5)
					var phi : float = $DiversitySensor.PDF_STEP * (j_phi + 0.5)
					new_mesh_instance.material_override.albedo_color = Color(cos(phi)*sin(theta), sin(phi)*sin(theta), cos(theta))
					# add
					$Bar.add_child(new_mesh_instance)
					blocks[key] = new_mesh_instance
			else:
				if key in blocks:
					blocks[key].queue_free()
					blocks.erase(key)
	# edit position
	var keys : Array = blocks.keys()
	for i in range(keys.size()):
		blocks[keys[i]].translation.y = (i + 0.5) * $Reference.mesh.size.y / MAX_DIVERSITY
