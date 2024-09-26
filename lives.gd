extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.lives_changed.connect(_on_lives_changed)
	pass # Replace with function body.

func _on_lives_changed(lives):
	text = str(lives)
