tool
extends HBoxContainer
class_name SimCheckBox

onready var checkbox = $CheckBox
onready var reset_button = $ResetButton

signal checked_changed(button_pressed)

export(String) var checkbox_text
export(bool) var defval

func get_value() -> bool:
	return checkbox.pressed

func reset():
	checkbox.pressed = defval
	reset_button.disabled = true
	_on_CheckBox_toggled(defval)

func _ready():
	checkbox.text = checkbox_text
	checkbox.pressed = defval

func _on_ResetButton_pressed():
	reset()

func _on_CheckBox_toggled(button_pressed):
	emit_signal("checked_changed", button_pressed)
	if button_pressed != defval:
		reset_button.disabled = false
	else:
		reset_button.disabled = true
