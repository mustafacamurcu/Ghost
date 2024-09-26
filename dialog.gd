extends Label

var teach_game_text = "Hey! Stop lazing around! Customers are not happy.."
var teach_walk_text = "Use 'WASD' to move around."
var teach_swing_text = "Press 'Space' to swing your net."
var teach_catch_text = "Catch ghosts with your net and put them in your jar."
var teach_release_text = "Press 'R' to release the ghost."
var teach_goal_text = "Customer notes will show on top left. Find those ghosts and bring them back to the yellow zone."
var teach_pirate_text = "First task: I miss my pirate friend. Bring him back."
var teach_random_goal_text = "Now, get back to delivering customer orders. Chop chop!"
var teach_fired_text = "Oh, by the way, make 3 mistakes and you're FIRED!"

var text_to_display = ""
var animation_length = 1

var animation_timer : Timer

var moved = false
var swung = false
var caught = false
var released = false
var collected = false
var available = false

var disabled = false

func animate_text(t):
	text_to_display = t
	animation_timer.start()

func _process(delta):
	if !animation_timer.is_stopped():
		var ratio = (animation_timer.wait_time - animation_timer.time_left) / animation_length
		var num_chars = min(int(ratio * text_to_display.length())+1, text_to_display.length())
		text = text_to_display.left(num_chars)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_timer = Timer.new()
	animation_timer.one_shot = true
	animation_timer.wait_time = animation_length
	add_child(animation_timer)
	teach_game()
	SignalBus.ghost_caught.connect(_on_ghost_caught)
	SignalBus.ghost_released.connect(_on_ghost_released)
	SignalBus.pirate_collected.connect(_on_pirate_collected)
	SignalBus.moved.connect(_on_moved)
	SignalBus.swung.connect(_on_swung)
	SignalBus.show_dialog.connect(_on_show_dialog)

func _on_show_dialog(t):
	if available:
		animate_text(t)

func disable():
	disabled = true

func teach_game():
	animate_text(teach_game_text)
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.one_shot = true
	var f = func():
		if disabled:
			teach_pirate()
		else:
			teach_walk()
		timer.queue_free()
	timer.start()
	timer.timeout.connect(f)

func teach_walk():
	animate_text(teach_walk_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*3
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		var f = func():
			if moved:
				teach_swing()
				timer.queue_free()
		timer.start()
		timer.timeout.connect(f)
	waittimer.timeout.connect(ff)

func teach_swing():
	animate_text(teach_swing_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*3
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		var f = func():
			if swung:
				teach_catch()
				timer.queue_free()
		timer.start()
		timer.timeout.connect(f)
	waittimer.timeout.connect(ff)

func teach_catch():
	animate_text(teach_catch_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*3
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		var f = func():
			if caught:
				teach_release()
				timer.queue_free()
		timer.start()
		timer.timeout.connect(f)
	waittimer.timeout.connect(ff)

func teach_release():
	animate_text(teach_release_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*3
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		var f = func():
			if released:
				teach_goal()
				timer.queue_free()
		timer.start()
		timer.timeout.connect(f)
	waittimer.timeout.connect(ff)

func teach_goal():
	animate_text(teach_goal_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*5
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		teach_pirate()
	waittimer.timeout.connect(ff)

func teach_pirate():
	animate_text(teach_pirate_text)
	owner.give_first_goal()
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*3
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		var f = func():
			if collected:
				teach_random_goal()
				timer.queue_free()
		timer.start()
		timer.timeout.connect(f)
	waittimer.timeout.connect(ff)

func teach_random_goal():
	animate_text(teach_random_goal_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*7
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		teach_fired()
	waittimer.timeout.connect(ff)

func teach_fired():
	animate_text(teach_fired_text)
	var waittimer = Timer.new()
	add_child(waittimer)
	waittimer.wait_time = animation_length*7
	waittimer.one_shot = true
	waittimer.start()
	var ff = func():
		available = true
		animate_text("")
	waittimer.timeout.connect(ff)


func _on_ghost_caught(g_: Ghost):
	caught = true

func _on_ghost_released(g_: Ghost):
	released = true

func _on_pirate_collected():
	collected = true

func _on_swung():
	swung = true

func _on_moved():
	moved = true
