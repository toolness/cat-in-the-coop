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
                var tex = material.get_texture(SpatialMaterial.TEXTURE_ALBEDO)
                if tex:
                    var size = tex.get_size()
                    var image = tex.get_data()
                    image.decompress()
                    image.lock()
                    var color = image.get_pixel(size.x / 2, size.y / 2)
                    image.unlock()
                    print("Center is color " + str(color))
                    material.set_texture(SpatialMaterial.TEXTURE_ALBEDO, null)
                    material.albedo_color = color
                    print("Albedo color is now " + str(material.albedo_color) + ".")
    return scene
