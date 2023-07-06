@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	iterate(scene)
	return scene

func iterate(node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			for idx in child.mesh.get_surface_count():
				var mat = child.mesh.surface_get_material(idx) as StandardMaterial3D
				mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
				
		else:
			iterate(child)
