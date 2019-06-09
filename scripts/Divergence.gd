extends Viewport

onready var input := $Divergence.material as ShaderMaterial

var velocity

func _ready():
	velocity = get_parent().get_node("Velocity").get_texture()
	input.set_shader_param("velocity_texture", velocity)
