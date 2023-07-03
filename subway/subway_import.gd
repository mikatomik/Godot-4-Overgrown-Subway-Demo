@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	for child in scene.get_children():
		if child is MeshInstance3D:
			for idx in child.get_surface_override_material_count():
				var m = child.get_active_material(idx) as StandardMaterial3D
				m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		
	return scene
