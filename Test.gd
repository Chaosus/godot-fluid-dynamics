extends Control

onready var sim = $VBoxContainer/Simulator
onready var mode_button = $VBoxContainer/PanelContainer/HBox/VBox/HBoxContainer/MenuButton

onready var input_tab = $VBoxContainer/PanelContainer/HBox/VBox/InputTab
onready var sim_tab = $VBoxContainer/PanelContainer/HBox/VBox/SimTab

onready var add_button = $VBoxContainer/PanelContainer/HBox/VBox/ModeBox/Add
onready var sub_button = $VBoxContainer/PanelContainer/HBox/VBox/ModeBox/Sub

onready var reset_input_button = $VBoxContainer/PanelContainer/HBox/VBox/InputTab/InputHeader/ResetButton
onready var reset_sim_button = $VBoxContainer/PanelContainer/HBox/VBox/SimTab/SimHeader/ResetButton

onready var input_tab_button = $VBoxContainer/PanelContainer/HBox/VBox/Tabs/InputTabButton
onready var sim_tab_button = $VBoxContainer/PanelContainer/HBox/VBox/Tabs/SimTabButton

var radius_control
var force_control

var all_settings = []
var input_settings = []
var sim_settings = []

var curr_surf = 3

const MAX_TAB = 2
const MAX_SURF = 4

var mode = 0

func _ready() -> void:
	sim.grab_focus()
	
	radius_control = $VBoxContainer/PanelContainer/HBox/VBox/InputTab/InputSettings/Radius
	force_control = $VBoxContainer/PanelContainer/HBox/VBox/InputTab/InputSettings/Force
	
	input_settings.append($VBoxContainer/PanelContainer/HBox/VBox/InputTab/InputSettings/InvertRMB)
	input_settings.append(radius_control)
	input_settings.append(force_control)

	sim_settings.append($VBoxContainer/PanelContainer/HBox/VBox/SimTab/SimulationSettings/DisableObstacles)
	sim_settings.append($VBoxContainer/PanelContainer/HBox/VBox/SimTab/SimulationSettings/Viscocity)
	sim_settings.append($VBoxContainer/PanelContainer/HBox/VBox/SimTab/SimulationSettings/Vorticity)
	
	all_settings.append(input_settings)
	all_settings.append(sim_settings)
	
	OS.set_window_title("FluidDynamics " + "(512 x 512)")
	
func set_surface(idx : int) -> void:
	curr_surf = idx
	mode_button.select(idx)
	sim.change_mode(idx)

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("switch_surface_backward"):
		set_surface(wrapi(curr_surf - 1, 0, MAX_SURF))
	if Input.is_action_just_pressed("switch_surface_forward"):
		set_surface(wrapi(curr_surf + 1, 0, MAX_SURF))
	
	if sim.is_cursor_inside_sim():
		if Input.is_action_just_pressed("surf_density"):
			set_surface(0)
		if Input.is_action_just_pressed("surf_velocity"):
			set_surface(1)
		if Input.is_action_just_pressed("surf_divergence"):
			set_surface(2)
		if Input.is_action_just_pressed("surf_final"):
			set_surface(3)
	
	if Input.is_action_just_pressed("clear"):
		sim.clear()
		
	if Input.is_action_just_pressed("switch_modes"):
		mode = wrapi(mode + 1, 0, 2)
		if mode == 0:
			add_button.pressed = true
			sim.brush_mode = 0
		else:
			sub_button.pressed = true
			sim.brush_mode = 1
	
	if Input.is_action_just_released("increase_radius"):
		if Input.is_key_pressed(KEY_SHIFT):
			force_control.increase()
		else:
			radius_control.increase()
	if Input.is_action_just_released("decrease_radius"):
		if Input.is_key_pressed(KEY_SHIFT):
			force_control.decrease()
		else:
			radius_control.decrease()
	
func _on_MenuButton_item_selected(id : int) -> void:
	sim.change_mode(id)

func _on_ResetButton_pressed() -> void:
	sim.clear()

func _on_InputSetupMode_pressed() -> void:
	sim_tab.visible = false
	input_tab.visible = true

func _on_SimulationSetupMode_pressed() -> void:
	sim_tab.visible = true
	input_tab.visible = false

func check_settings():
	reset_input_button.disabled = true
	for item in input_settings:
		if item.get_value() != item.defval:
			reset_input_button.disabled = false
			break
	reset_sim_button.disabled = true
	for item in sim_settings:
		if item.get_value() != item.defval:
			reset_sim_button.disabled = false
			break

func _on_Radius_value_changed(value):
	if sim:
		check_settings()
		sim.splat_radius = value

func _on_Force_value_changed(value):
	if sim:
		check_settings()
		sim.force = value

func _on_Add_pressed() -> void:
	mode = 0
	if sim:
		sim.brush_mode = 0

func _on_Sub_pressed() -> void:
	mode = 1
	if sim:
		sim.brush_mode = 1
		
func _on_ResetInputSubSettings_pressed():
	for item in input_settings:
		item.reset()

func _on_ResetSimSubSettings_pressed():
	for item in sim_settings:
		item.reset()

func _on_DisableObstacles_checked_changed(button_pressed : bool) -> void:
	if sim:
		check_settings()
		sim.disable_obstacles(button_pressed)

func _on_Viscocity_value_changed(_value):
	if sim:
		check_settings()
		sim.set_viscocity(_value)

func _on_Vorticity_value_changed(_value):
	if sim:
		check_settings()

func _on_CircleFormButton_pressed():
	if sim:
		sim.set_form(0)

func _on_SquareFormButton_pressed():
	if sim:
		sim.set_form(1)

func _on_LMB_Density_toggled(button_pressed):
	if sim:
		sim.set_lmb_density(button_pressed)

func _on_LMB_Velocity_toggled(button_pressed):
	if sim:
		sim.set_lmb_velocity(button_pressed)

func _on_RMB_Density_toggled(button_pressed):
	if sim:
		sim.set_rmb_density(button_pressed)

func _on_RMB_Velocity_toggled(button_pressed):
	if sim:
		sim.set_rmb_velocity(button_pressed)

func _on_InvertRMB_checked_changed(button_pressed):
	if sim:
		check_settings()
		sim.set_invert_rmb(button_pressed)

func _on_InputTabButton_pressed():
	input_tab_button.pressed = true
	sim_tab_button.pressed = false
	input_tab.visible = true
	sim_tab.visible = false

func _on_SimTabButton_pressed():
	input_tab_button.pressed = false
	sim_tab_button.pressed = true
	input_tab.visible = false
	sim_tab.visible = true

