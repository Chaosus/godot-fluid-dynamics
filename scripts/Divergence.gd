extends Viewport

onready var divergence := $Divergence.material as ShaderMaterial

func _ready():
	
	var velocity = get_parent().get_node("Velocity").get_texture()
	var obstacle = preload("res://resources/bounds.png")
	
	divergence.set_shader_param("velocity_texture", velocity)
	divergence.set_shader_param("obstacle_texture", obstacle)