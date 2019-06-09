extends OptionButton

func _ready() -> void:
	add_item("1. Density")
	add_item("2. Velocity")
	add_item("3. Divergence")
	add_item("4. Final")
	select(3)
