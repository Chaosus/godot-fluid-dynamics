extends Control

onready var sim = $VBoxContainer/Simulator
onready var mode_button = $VBoxContainer/PanelContainer/HBoxContainer/MenuButton

func _ready() -> void:
	sim.grab_focus()

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("mode_density"):
		mode_button.select(0)
		sim.change_mode(0)
	if Input.is_action_just_pressed("mode_velocity"):
		mode_button.select(1)
		sim.change_mode(1)
	if Input.is_action_just_pressed("mode_divergence"):
		mode_button.select(2)
		sim.change_mode(2)
	if Input.is_action_just_pressed("mode_final"):
		mode_button.select(3)
		sim.change_mode(3)
	if Input.is_action_just_pressed("clear"):
		sim.clear()
		
func _on_MenuButton_item_selected(id : int) -> void:
	sim.change_mode(id)

func _on_ResetButton_pressed() -> void:
	sim.clear()
