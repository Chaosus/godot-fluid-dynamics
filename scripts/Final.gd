extends Viewport

func _ready():
	($Final.material as ShaderMaterial).set_shader_param("density_texture", get_parent().get_node("Density").get_texture())