extends Viewport

onready var advection := $Advection.material as ShaderMaterial

onready var splat_buffer = $Buffer

var diffusions = []

func set_viscocity(value):
	for s in diffusions:
		s.set_shader_param("viscocity", value)

func _ready():
	
	var velocity = get_parent().get_node("Velocity").get_texture()
	var obstacle = preload("res://resources/bounds.png")
	
	advection.set_shader_param("velocity_texture", velocity)
	advection.set_shader_param("obstacle_texture", obstacle)
	
	# generate diffusion steps
	generate_diffusion_steps(20, 0.0001)
	
func generate_diffusion_steps(step_count, viscocity):
	var n = splat_buffer
	for i in range(step_count):
		n = generate_diffusion_step(n, i, viscocity)
	
func generate_diffusion_step(tnode, i, v):
	var node = TextureRect.new()
	var sm = ShaderMaterial.new()
	diffusions.append(sm)
	sm.shader = preload("res://shaders/diffusion.shader")
	sm.set_shader_param("viscocity", v)
	node.material = sm
	node.name = "Diffusion" + str(i)
	var tex = ImageTexture.new()
	tex.create(512, 512, Image.FORMAT_RGBA8)
	node.texture = tex
	var buffer = BackBufferCopy.new()
	buffer.name = "DiffusionBuffer" + str(i)
	buffer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	add_child_below_node(tnode, node)
	add_child_below_node(node, buffer)
	return buffer