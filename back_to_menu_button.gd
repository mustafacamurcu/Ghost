extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	SignalBus.back_to_menu_pressed.emit()
