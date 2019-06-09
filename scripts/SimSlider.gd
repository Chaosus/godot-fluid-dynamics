tool
extends HBoxContainer

signal value_changed(value)

onready var slider = $HSlider
onready var spin_box = $SpinBox
onready var reset_button = $ResetButton

export(float) var max_value = 5.0
export(float) var step = 0.1
export(float) var defval = 0.0

func _ready():
	slider.max_value = max_value
	slider.step = step
	slider.value = defval
	spin_box.step = step
	$Label.text = get_name() + ":"

func _on_SpinBox_value_changed(value):
	slider.value = value
	if slider.value != defval:
		reset_button.disabled = false
	else:
		reset_button.disabled = true
	emit_signal("value_changed", value)

func _on_HSlider_value_changed(value):
	spin_box.value = value

func _on_ResetButton_pressed():
	slider.value = defval
	reset_button.disabled = true
