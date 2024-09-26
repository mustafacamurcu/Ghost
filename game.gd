extends Node2D

@onready var tilemap = $Map
@onready var ghosts = $Ghosts
@onready var player : Player = $Player
@onready var dropoff : Area2D = $Dropoff
@onready var collision_shape_2d = $Dropoff/CollisionShape2D
@onready var hearts = $Hearts
@onready var question_marks = $QuestionMarks
@onready var teleporter = $Teleporter
@onready var tile_map = $TileMap

@onready var success = $Success
@onready var success_2 = $Success2
@onready var success_3 = $Success3
@onready var failure_1 = $Failure1
@onready var lose_screen = $CanvasLayer/Lose
@onready var win_screen = $CanvasLayer/Win

var success_sounds
const GHOST = preload("res://ghost.tscn")

var score = 0
var num_ghosts = 20
var current_goal : Goal
var pirate_goal
var cutie_goal

var lives = 3

var initial_goals : Array[Goal] = []

class Goal:
	var eyes
	var accessory
	var hat
	func check_ghost(ghost: Ghost):
		return ghost.eyes.texture == eyes and ghost.get_accessory().texture == accessory and ghost.hat.texture == hat
	func generate_note():
		var eye_word = Constants.WORDS[eyes]
		var hat_word = Constants.WORDS[hat]
		var acc_word = Constants.WORDS[accessory]
		var note = "Find customer's friend:
			- {hat}
			- {eyes}
			- {accesory}".format({"hat":hat_word, "eyes": eye_word, "accesory": acc_word})
		return note

func _physics_process(delta):
	for ghost : Ghost in ghosts.get_children():
		if ghost.run_awayer:
			var dist = player.position.distance_to(ghost.position)
			if dist < 1000:
				ghost.speed = 700
				ghost.target = player.position.direction_to(ghost.position) * 2000 + ghost.position
			elif dist > 1500:
				ghost.speed = 100

func generate_random_goal():
	return generate_goal(Constants.EYES.pick_random(), Constants.HATS.pick_random(), Constants.ACCESSORIES.pick_random())

func win():
	win_screen.show()
	pass

func lose():
	lose_screen.show()
	pass

func next_goal():
	if initial_goals.is_empty():
		win()
	var goal : Goal = initial_goals.pop_front()
	var has = false
	for ghost in ghosts.get_children():
		if goal.check_ghost(ghost):
			has = true
			break
	if not has:
		var goal_ghost = GHOST.instantiate()
		ghosts.add_child(goal_ghost)
		goal_ghost.set_eyes(goal.eyes)
		goal_ghost.set_hat(goal.hat)
		goal_ghost.set_accessory(goal.accessory)
		goal_ghost.set_random_location()
	SignalBus.new_note.emit(goal.generate_note())
	return goal

func generate_goal(eyes, hat, accessory):
	var goal_ghost = GHOST.instantiate()
	ghosts.add_child(goal_ghost)
	goal_ghost.set_eyes(eyes)
	goal_ghost.set_hat(hat)
	goal_ghost.set_accessory(accessory)
	goal_ghost.set_random_location()
	
	var goal = Goal.new()
	goal.eyes = eyes
	goal.hat = hat
	goal.accessory = accessory
	return goal

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create goals
	pirate_goal = generate_goal(Constants.EYEPATCH, Constants.PIRATEHAT, Constants.BIRD)
	initial_goals.append(pirate_goal)
	cutie_goal = generate_goal(Constants.SLEEPYEYES, Constants.FLOWER_BEANIE, Constants.FLOWER)
	initial_goals.append(cutie_goal)
	for i in range(20):
		initial_goals.append(generate_random_goal())
	
	success_sounds = [success,success_2,success_3]
	
	SignalBus.ghost_caught.connect(_on_ghost_caught)
	SignalBus.ghost_released.connect(_on_ghost_released)
	SignalBus.ghost_collected.connect(_on_ghost_collected)
	
func _on_ghost_caught(ghost: Ghost):
	ghosts.remove_child(ghost)

func _on_ghost_released(ghost: Ghost):
	var rect : Rect2 = collision_shape_2d.shape.get_rect()
	rect.position += collision_shape_2d.global_position
	if rect.has_point(player.global_position):
		ghost.run_home(teleporter.position)

func _on_ghost_collected(ghost: Ghost):
	print(ghost.eyes == Constants.SLEEPYEYES)
	print(ghost.hat == Constants.FLOWER_BEANIE)
	print(ghost.get_accessory() == Constants.FLOWER)
	if current_goal:
		print(current_goal.eyes == Constants.SLEEPYEYES)
		print(current_goal.hat == Constants.FLOWER_BEANIE)
		print(current_goal.accessory == Constants.FLOWER)
	print(ghost)
	print(ghost.get_accessory())
	print(ghost.get_accessory().texture)
	print(Constants.WORDS[ghost.eyes.texture])
	print(Constants.WORDS[ghost.hat.texture])
	print(Constants.WORDS[ghost.get_accessory().texture])
	if current_goal:
		print(Constants.WORDS[current_goal.eyes])
		print(Constants.WORDS[current_goal.hat])
		print(Constants.WORDS[current_goal.accessory])
	if current_goal and current_goal.check_ghost(ghost):
		if current_goal == pirate_goal:
			SignalBus.pirate_collected.emit()
		score += 100
		if Constants.sfx:
			success_sounds.pick_random().play()
		SignalBus.show_dialog.emit("Yay! My friend is back!")
		SignalBus.score_changed.emit(score)
		ghost.queue_free()
		hearts.position = ghost.global_position
		hearts.emitting = true
		current_goal = next_goal()
	else:
		ghost.queue_free()
		SignalBus.show_dialog.emit("Who's this?? I don't know this person! I want my money back! >:|")
		lives -= 1
		SignalBus.lives_changed.emit(lives)
		if Constants.sfx:
			failure_1.play()
		if lives == 0:
			lose()
		question_marks.position = ghost.global_position
		question_marks.emitting = true

func _unhandled_key_input(event):
	if event.is_action('escape'):
		SignalBus.escape_pressed.emit()

func give_first_goal():
	current_goal = next_goal()

func disable_tutorial():
	$CanvasLayer/TextureRect/Dialog.disable()
