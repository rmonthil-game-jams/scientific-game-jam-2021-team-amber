extends RayCast

signal preselected(i, j)
signal selected(i, j)

var current : Spatial = null

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var camera : Camera = get_viewport().get_camera()
		look_at(camera.project_ray_origin(event.position) + camera.project_ray_normal(event.position), Vector3.UP)
		force_raycast_update()
		if is_colliding():
			if get_collider().get_parent() != current:
				current = get_collider().get_parent()
				if Input.is_mouse_button_pressed(BUTTON_LEFT):
					emit_signal("selected", current.I, current.J)
				else:
					emit_signal("preselected", current.I, current.J)
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if is_colliding():
				if get_collider() and not get_collider().is_queued_for_deletion():
					current = get_collider().get_parent()
					emit_signal("selected", current.I, current.J)
