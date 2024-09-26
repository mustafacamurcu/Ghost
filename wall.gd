extends StaticBody2D
@onready var polygon_2d = $Polygon2D
@onready var collision_shape_2d = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var halfsize = Constants.TILE_SIZE / 2
	polygon_2d.polygon = [
		Vector2(-halfsize, -halfsize),
		Vector2(-halfsize, +halfsize),
		Vector2(+halfsize, +halfsize),
		Vector2(+halfsize, -halfsize)
	]
	collision_shape_2d.shape.size = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)
