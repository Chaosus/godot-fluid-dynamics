extends OptionButton

func _ready() -> void:
	add_item("Density")
	add_item("Velocity")
	add_item("Divergence")
	add_item("Final")
	select(3)
