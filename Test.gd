extends Control

onready var sim = $VBoxContainer/Simulator
onready var mode_button = $VBoxContainer/PanelContainer/VBox/HBoxContainer/MenuButton

onready var input_tab = $VBoxContainer/PanelContainer/VBox/InputSettings
onready var sim_tab = $VBoxContainer/PanelContainer/VBox/SimulationSettings

onready var tab_input_button = $VBoxContainer/PanelContainer/VBox/HBoxContainer2/InputSetupMode
onready var tab_sim_button = $VBoxContainer/PanelContainer/VBox/HBoxContainer2/SimulationSetupMode

onready var add_button = $VBoxContainer/PanelContainer/VBox/HBoxContainer/Add
onready var sub_button = $VBoxContainer/PanelContainer/VBox/HBoxContainer/Sub

var curr_tab = 0
var curr_surf = 3

const MAX_TAB = 2
const MAX_SURF = 4

var mode = 0

func _ready() -> void:
	sim.grab_focus()

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
		
	
	if Input.is_action_just_pressed("switch_settings"):
		curr_tab = wrapi(curr_tab + 1, 0, MAX_TAB)
		match curr_tab:
			0:
				tab_input_button.pressed = true
				_on_InputSetupMode_pressed()
			1:
				tab_sim_button.pressed = true
				_on_SimulationSetupMode_pressed()
	
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

func _on_Radius_value_changed(value : float) -> void:
	if sim:
		sim.splat_radius = value

func _on_Force_value_changed(value : float) -> void:
	if sim:
		sim.force = value

func _on_Add_pressed() -> void:
	mode = 0
	if sim:
		sim.brush_mode = 0

func _on_Sub_pressed() -> void:
	mode = 1
	if sim:
		sim.brush_mode = 1
