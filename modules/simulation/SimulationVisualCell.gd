extends Spatial

signal selected

var I : int = -1
var J : int = -1

var is_land_spawning : bool = false
var is_land_clearing : bool = false
var is_trees_spawning : bool = false
var is_trees_clearing : bool = false

var state : Dictionary = {} setget _set_state

# interface

func preshovel():
	pass

# internal

func _set_state(val : Dictionary):
	if val and is_inside_tree():
		if val["type"] == "water":
			_clear_land()
			_clear_tree()
		elif val["type"] == "land":
			_clear_tree()
			if "biome" in state:
				if val["biome"] != state["biome"]:
					_clear_land()
					_spawn_land(val["biome"])
			else:
				_spawn_land(val["biome"])
		elif val["type"] == "tree":
			if "biome" in state:
				if val["biome"] != state["biome"]:
					_clear_land()
					_spawn_land(val["biome"])
			else:
				_spawn_land(val["biome"])
			if "species" in state:
				if val["species"] != state["species"]:
					_clear_tree()
					_spawn_tree(val["species"], val["biome"])
			else:
				_spawn_tree(val["species"], val["biome"])
	state = val

func _spawn_land(biome : String):
	if not is_land_spawning:
		if is_land_clearing:
			$TweenLand.stop_all()
			$TimerClearLand.stop()
			is_land_clearing = false
		is_land_spawning = true
		# build tween
		$TweenLand.interpolate_property($Ground, "translation", $Ground.translation, Vector3(0.0, 0.0, 0.0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		# start tween
		$TweenLand.start()
		$Ground.show()

func _clear_land():
	if not is_land_clearing:
		if is_land_spawning:
			$TweenLand.stop_all()
			is_land_spawning = false
		is_land_clearing = true
		# build tween
		$TweenLand.interpolate_property($Ground, "translation", $Ground.translation, Vector3(0.0, -0.6, 0.0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		# start tween
		$TweenLand.start()
		# clear
		$TimerClearLand.start()

func _spawn_tree(species : Vector3, biome : String):
	if not is_trees_spawning:
		if is_trees_clearing:
			$TimerClearTrees.stop()
			$TweenTrees.stop_all()
			is_trees_clearing = false
		is_trees_spawning = true
		# build trees
		for i in range(randi()%3 + 1):
			var new_tree : Spatial
			match (randi() % 3):
				0:
					new_tree = preload("res://game/assets/biome_neutral/scenes/TreeSmall.tscn").instance()
				1:
					new_tree = preload("res://game/assets/biome_neutral/scenes/Tree.tscn").instance()
				2:
					new_tree = preload("res://game/assets/biome_neutral/scenes/TreeLarge.tscn").instance()
			$Ground/Trees.add_child(new_tree)
			# materials
			## foliage
			var foliage_material : SpatialMaterial = preload("res://game/assets/biome_neutral/scenes/leaves.tres").duplicate()
			foliage_material.albedo_color = Color(species.x, species.y, species.z)
			new_tree.get_node("MeshInstance").set_surface_material(1, foliage_material)
			## intern
			var intern_material : SpatialMaterial = preload("res://game/assets/biome_neutral/scenes/leaves.tres").duplicate()
			intern_material.albedo_color = Color(species.x, species.y, species.z)
			new_tree.get_node("MeshInstance").set_surface_material(2, intern_material)
			# translation
			new_tree.translation += Vector3(rand_range(-0.3, 0.3), 0.0, rand_range(-0.3, 0.3))
			new_tree.translation.y += 0.5
			new_tree.scale = Vector3(0.01, 0.01, 0.01)
			$TweenTrees.interpolate_property(new_tree, "scale", Vector3(0.01, 0.01, 0.01), Vector3(1.0, 1.0, 1.0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.5)
			$TweenTrees.start()

func _clear_tree():
	if not is_trees_clearing:
		if is_trees_spawning:
			$TweenTrees.stop_all()
			is_trees_spawning = false
		is_trees_clearing = true
		# build tween
		for tree in $Ground/Trees.get_children():
			$TweenTrees.interpolate_property(tree, "scale", Vector3(1.0, 1.0, 1.0), Vector3(0.01, 0.01, 0.01), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$TweenTrees.start()
		# clear
		$TimerClearTrees.start()

func _enter_tree():
	_set_state(state)

func _on_TimerClearTrees_timeout():
	for tree in $Ground/Trees.get_children():
		tree.queue_free()

func _on_TimerClearLand_timeout():
	$Ground.hide()
