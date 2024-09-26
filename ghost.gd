class_name Ghost
extends Node2D
@onready var shoes : Sprite2D = $shoes
@onready var body : Sprite2D = $body
@onready var eyes : Sprite2D = $eyes
@onready var hat : Sprite2D = $hat
@onready var accessory_behind : Sprite2D = $accessory_behind
@onready var accessory_front : Sprite2D = $accessory_front
@onready var area_2d : Area2D = $Area2D
@onready var falling = $Falling

var active = true

var spinning = false

var time_offset = 0

var run_awayer = false

var target_range_x = Vector2(-Constants.W/2, Constants.W/2)
var target_range_y = Vector2(0, -Constants.H)
var target : Vector2
var speed : float = 100
var sway_speed : float = 100
var running_home = false

const SPIN_TIME = 2

func spin():
	falling.play()
	spinning = true
	active = false
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = SPIN_TIME
	var f  = func():
		SignalBus.ghost_collected.emit(self)
	timer.timeout.connect(f)
	add_child(timer)

func setup_after_duplicate():
	shoes = $shoes
	body = $body
	eyes = $eyes
	hat = $hatdddd
	accessory_behind = $accessory_behind
	accessory_front = $accessory_front
	area_2d = $Area2D

func run_home(home: Vector2):
	run_awayer = false
	running_home = true
	target = home
	speed = 1000

func _ready():
	random_target()
	body.modulate.a = 0.8
	time_offset = randf() * 1000

func random_target():
	target = Vector2(randi_range(target_range_x.x,target_range_x.y), randi_range(target_range_y.x,target_range_y.y))

func _physics_process(delta):
	falling.stream_paused = true
	# 5 rotations, 3 scale
	if spinning:
		if Constants.sfx:
			falling.stream_paused = false
		var ratio = delta / SPIN_TIME
		var angle = ratio * 5 * 2 * PI
		rotation += angle
		scale.x -= ratio * 0.3
		scale.y -= ratio * 0.3
	
	if active:
		# 0 - 2*PI
		var angle = int(Time.get_ticks_msec() + time_offset) % 3000 / 3000. * PI * 2
		
		var direction = global_position.direction_to(target)
		position += delta * speed * direction
		position += delta * sway_speed * direction.rotated(PI/2) * sin(angle)
		
		if target.distance_to(global_position) < 50:
			if running_home:
				spin()
			else:
				random_target()

func set_eyes(texture : Texture2D):
	if texture == Constants.DISGUISE:
		run_awayer = true
	eyes.texture = texture

func set_shoes(texture : Texture2D):
	shoes.texture = texture

func set_hat(texture : Texture2D):
	hat.texture = texture
	
func set_body(texture : Texture2D):
	body.texture = texture

func get_accessory():
	if accessory_behind.texture:
		return accessory_behind
	else:
		return accessory_front

func set_accessory(texture : Texture2D):
	accessory_behind.texture = null
	accessory_front.texture = null
	if true: # texture == Constants.ACCESSORIES[0]:
		accessory_behind.texture = texture
	else:
		accessory_front.texture = texture

func set_random_location():
	position = Vector2(randi_range(-Constants.W/2, Constants.W/2), randi_range(0, -Constants.H))

func set_target_range(range_x, range_y):
	target_range_x = range_x
	target_range_y = range_y
	random_target()
	
func picturize():
	active = false
	scale = Vector2(.15,.15)
	position = Vector2.ZERO
	
func unpicturize():
	active = true
	scale = Vector2(.3,.3)
	
