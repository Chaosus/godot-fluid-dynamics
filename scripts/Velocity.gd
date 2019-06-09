extends Viewport

onready var project_surface = $Project.material as ShaderMaterial
#onready var project_surface2 = $Project.material as ShaderMaterial

var divergence

func _ready():
	divergence = get_parent().get_node("Divergence").get_texture()
	project_surface.set_shader_param("divergence_texture", divergence)
	#project_surface2.set_shader_param("divergence_texture", divergence)
	pass