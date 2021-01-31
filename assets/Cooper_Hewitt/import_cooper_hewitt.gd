tool
extends EditorScenePostImport

func post_import(scene):
    for node in scene.get_children():
        if node is MeshInstance:
            var mesh = node.mesh
            var material = mesh.surface_get_material(0)
            if material is SpatialMaterial:
                print("Modifying material for " + node.name + " to be less shiny.")
                material.params_diffuse_mode = SpatialMaterial.DIFFUSE_TOON
                material.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
    return scene
