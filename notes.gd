extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.new_note.connect(_on_new_note)
	pass # Replace with function body.

func _on_new_note(note: String):
	text = note
