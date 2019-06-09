extends HBoxContainer
class_name SimSlider

signal value_changed(value)

onready var slider = $HSlider
onready var spin_box = $SpinBox
onready var reset_button = $ResetButton

export(float) var max_value = 5.0
export(float) var step = 0.1
export(float) var defval = 0.0
export(float) var min_value = 0.0

func increase() -> void:
	slider.value += step

func decrease() -> void:
	slider.value -= step

func get_value() -> float:
	return slider.value

func reset() -> void:
	slider.value = defval
	reset_button.disabled = true

func _ready() -> void:
	slider.min_value = min_value
	slider.max_value = max_value
	slider.step = step
	slider.value = defval
	spin_box.min_value = min_value
	spin_box.max_value = max_value
	spin_box.step = step
	spin_box.value = defval
	$Label.text = get_name() + ":"

func _on_SpinBox_value_changed(value : float) -> void:
	slider.value = value
	if slider.value != defval:
		reset_button.disabled = false
	else:
		reset_button.disabled = true
	emit_signal("value_changed", value)

func _on_HSlider_value_changed(value : float) -> void:
	spin_box.value = value

func _on_ResetButton_pressed() -> void:
	reset()