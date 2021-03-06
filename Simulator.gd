extends TextureRect
class_name Simulator

onready var density = $Density
onready var velocity = $Velocity
onready var divergence = $Divergence
onready var final = $Final

export(float) var splat_radius := 10.0;
export(float) var force := 1.0
export(int) var brush_mode := 1
export(ImageTexture) var obstacles_texture

var density_splat
var velocity_splat

var _mouse_pos := Vector2(0.0, 0.0)
var _prev_mouse_pos := Vector2(0.0, 0.0)

var _mode_idx := 0
var _disable_obstacles = false

var empty_texture
var _form

var _lmb_density := true
var _lmb_velocity := true
var _rmb_density := true
var _rmb_velocity := false
var _invert_rmb := true
var _is_cursor_inside_sim := false

func set_viscocity(value):
	value = 1.0 - value
	density.set_viscocity(value)
	velocity.set_viscocity(value)

func set_lmb_density(toggled):
	_lmb_density = toggled

func set_lmb_velocity(toggled):
	_lmb_velocity = toggled
	
func set_rmb_density(toggled):
	_rmb_density = toggled

func set_rmb_velocity(toggled):
	_rmb_velocity = toggled

func set_invert_rmb(toggled):
	_invert_rmb = toggled
	
func is_cursor_inside_sim() -> bool:
	return _is_cursor_inside_sim

func set_form(form : int) -> void:
	_form = form
	density_splat.set_shader_param("brush_form", form)
	#velocity_splat.set_shader_param("brush_form", form)

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
	_mode_idx = id

func get_mode() -> int:
	return _mode_idx

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
	density_splat.set_shader_param("radius", 0.0)
	velocity_splat.set_shader_param("radius", 0.0)
	
	change_mode(3)

func _input(event) -> void:
	if event is InputEventMouse:
		_is_cursor_inside_sim = get_rect().has_point(event.position)
	
	if event is InputEventMouseMotion:
		_prev_mouse_pos = _mouse_pos
		_mouse_pos = event.position

		
func apply_density_splat() -> void:
	if !is_cursor_inside_sim():
		return
	density_splat.set_shader_param("point", _mouse_pos)
	
	var fv = Vector3(force, force, force)
		
	density_splat.set_shader_param("force", fv)
	
	var lmb = _lmb_density and Input.is_mouse_button_pressed(BUTTON_LEFT)
	var rmb = _rmb_density and Input.is_mouse_button_pressed(BUTTON_RIGHT)
	
	if (lmb or rmb):
		if rmb:
			if _invert_rmb:
				density_splat.set_shader_param("brush_mode", 1 if brush_mode == 0 else 0)
			else:
				density_splat.set_shader_param("brush_mode", brush_mode)
		else:
			density_splat.set_shader_param("brush_mode", brush_mode)
		density_splat.set_shader_param("radius", splat_radius*splat_radius)
	else:
		density_splat.set_shader_param("radius", 0.0)

func apply_velocity_splat() -> void:
	if !is_cursor_inside_sim():
		return
	velocity_splat.set_shader_param("point", _mouse_pos)
	
	var lmb = _lmb_velocity and Input.is_mouse_button_pressed(BUTTON_LEFT)
	var rmb = _rmb_velocity and Input.is_mouse_button_pressed(BUTTON_RIGHT)
	
	if (lmb or rmb) && brush_mode == 0:
		var velocity := (_prev_mouse_pos - _mouse_pos).normalized() # do not change it to direction_to since this function is not supported below 3.1.1 version of Godot
		var rest = 0.0
		if Vector2(sign(velocity.x), sign(velocity.y)) != Vector2(0, 0):
			rest = 1.0
		velocity_splat.set_shader_param("force", Vector3(velocity.x, velocity.y, rest))
		velocity_splat.set_shader_param("radius", splat_radius*splat_radius*15)
	else:
		velocity_splat.set_shader_param("radius", 0.0)
	
func _process(_delta : float) -> void:
	apply_density_splat()
	apply_velocity_splat()
	_prev_mouse_pos = _mouse_pos
