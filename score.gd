extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.score_changed.connect(_on_score_changed)
	pass # Replace with function body.

func _on_score_changed(score):
	text = str(score)
