extends Camera2D
@onready var player = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	#limit_bottom = Constants.H
	#limit_right = Constants.W
	#limit_top = 0
	#limit_left = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
	pass
