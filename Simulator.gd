extends TextureRect
class_name Simulator

onready var density = $Density
onready var velocity = $Velocity
onready var divergence = $Divergence
onready var final = $Final

#onready var pressure = $Pressure

export(float) var splat_radius := 10.0;
export(float) var force := 1.0
export(int) var brush_mode := 1
export(ImageTexture) var obstacles_texture

var density_splat
var velocity_splat

var mouse_pos := Vector2(0.0, 0.0)
var prev_mouse_pos := Vector2(0.0, 0.0)

var mode_idx := 0
var _disable_obstacles = false

var empty_texture
var _form

func set_form(form : int) -> void:
	_form = form
	density_splat.set_shader_param("form", form)
	velocity_splat.set_shader_param("form", form)		

func create_texture(width : int, height : int):
	var texture = ImageTexture.new()
	texture.create(width, height, Image.FORMAT_BPTC_RGBF, ImageTexture.FLAGS_DEFAULT)
	return texture

func disable_obstacles(toggled : bool) -> void:
	_disable_obstacles = toggled
	if _disable_obstacles:
		obstacles_texture = empty_texture
	else:
		obstacles_texture = preload("res://resources/bounds.png")
	(final.get_node("Final").material as ShaderMaterial).set_shader_param("obstacles_texture", obstacles_texture)

func change_mode(id : int) -> void:
	var v : Viewport
	match id:
		0:
			v = density
		1:
			v = velocity
		2:
			v = divergence
		3:
			v = final
	texture = v.get_texture()
	mode_idx = id

func get_mode() -> int:
	return mode_idx

func clear() -> void:
	divergence.render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
	divergence.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	density.render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
	density.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	velocity.render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
	velocity.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	
func _ready() -> void:
	
	density_splat = $Density/Splat.material
	velocity_splat = $Velocity/Splat.material
	
	empty_texture = create_texture(512, 512)
	
	change_mode(3)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		prev_mouse_pos = mouse_pos
		mouse_pos = event.position
				
func apply_density_splat(pos) -> void:
	if !has_focus():
		return
	density_splat.set_shader_param("point", pos)
	
	var fv
	
	if(brush_mode == 1): # subtract
		fv = Vector3(1, 1, 1) - Vector3(force, force, force)
	else: # add
		fv = Vector3(force, force, force)
	
	density_splat.set_shader_param("force", fv)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		density_splat.set_shader_param("radius", splat_radius*splat_radius)
	else:
		density_splat.set_shader_param("radius", 0.0)
		
func apply_velocity_splat(pos) -> void:
	if !has_focus():
		return
	velocity_splat.set_shader_param("point", pos)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var velocity := mouse_pos.direction_to(prev_mouse_pos)
		var rest = 0.0
		if Vector2(sign(velocity.x), sign(velocity.y)) != Vector2(0, 0):
			rest = 1.0
		velocity_splat.set_shader_param("force", Vector3(velocity.x, velocity.y, rest))
		velocity_splat.set_shader_param("radius", splat_radius*splat_radius*15)
	else:
		velocity_splat.set_shader_param("radius", 0.0)
	
func _process(_delta : float) -> void:
	apply_density_splat(mouse_pos)
	apply_velocity_splat(mouse_pos)
	prev_mouse_pos = mouse_pos
