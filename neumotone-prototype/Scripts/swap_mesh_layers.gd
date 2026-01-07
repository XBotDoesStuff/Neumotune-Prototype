@tool
extends Node3D

@export_enum("Layer 9", "Layer 10") var target_layer := 0

@export var apply_now := false:
	set(value):
		if value:
			apply_now = false
			swap_layers()

func swap_layers():
	var layer_bit := 1 << (8 + target_layer) # 9 or 10

	var meshes := get_all_meshes(self)
	for mesh in meshes:
		mesh.layers = layer_bit

	print("Updated ", meshes.size(), " mesh(es)")

func get_all_meshes(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []

	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)

		result += get_all_meshes(child)

	return result
