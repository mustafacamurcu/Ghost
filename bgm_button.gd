extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	toggled.connect(_on_toggled)

func _on_toggled(on):
	SignalBus.bgm_toggled.emit(on)
