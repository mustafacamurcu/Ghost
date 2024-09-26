extends TextureRect

@onready var jar = $Jar
var ghost
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.ghost_caught.connect(_on_ghost_caught)
	SignalBus.ghost_released.connect(_on_ghost_released)
	pass # Replace with function body.

func _on_ghost_released(g : Ghost):
	ghost.queue_free()

func _on_ghost_caught(g : Ghost):
	ghost = g.duplicate()
	ghost.picturize()
	jar.add_child(ghost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
