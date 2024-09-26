extends Node2D

const GHOST = preload("res://ghost.tscn")
@onready var ghosts = $Ghosts
@onready var start_menu = $StartMenu
@onready var options = $Options

const GAME = preload("res://game.tscn")

var game_scene : PackedScene

func _on_options_pressed():
	start_menu.hide()
	options.show()

func _on_back_to_menu_pressed():
	start_menu.show()
	options.hide()

func _ready():
	SignalBus.options_pressed.connect(_on_options_pressed)
	SignalBus.back_to_menu_pressed.connect(_on_back_to_menu_pressed)
	
	var background : Polygon2D = Polygon2D.new()
	var w = 1920
	var h = 1280
	background.polygon = [
		Vector2(-w,-h),
		Vector2(-w,h),
		Vector2(w,h),
		Vector2(w,-h)]
	background.color = Color.html("#644d97")
	background.z_index = -1
	add_child(background)
	
	for i in range(100):
		var ghost = GHOST.instantiate()
		ghosts.add_child(ghost)
		ghost.set_eyes(Constants.EYES.pick_random())
		ghost.set_body(Constants.BODIES.pick_random())
		ghost.set_shoes(Constants.SHOES.pick_random())
		ghost.set_hat(Constants.HATS.pick_random())
		ghost.set_accessory(Constants.ACCESSORIES.pick_random())
		ghost.position = Vector2(randi()%1920, randi()%1280)
		ghost.set_target_range(Vector2(0,1920), Vector2(0,1280))
		ghost.scale = Vector2(0.05,0.05)
		ghost.speed = 60
		ghost.sway_speed = 30
