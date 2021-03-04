tool
extends EditorScenePostImport

var shader = preload("res://bitmappy_shader.shader")

func post_import(scene):
    iterate_node(scene)
    return scene


func iterate_node(parent):
    for node in parent.get_children():
        if node is MeshInstance:
            var mesh = node.mesh
            var material = mesh.surface_get_material(0)
            if material is SpatialMaterial:
                print("Modifying material for " + node.name + " to be less shiny.")
                material.params_diffuse_mode = SpatialMaterial.DIFFUSE_TOON
                material.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
                if material.albedo_texture is StreamTexture:
                    var mat = ShaderMaterial.new()
                    mat.shader = shader
                    mat.set_shader_param("tex", material.albedo_texture)
                    mesh.surface_set_material(0, mat)
        iterate_node(node)
