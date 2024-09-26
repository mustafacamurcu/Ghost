class_name Player
extends CharacterBody2D
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var catcher : Area2D = $Catcher
@onready var animation_tree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree['parameters/playback']
@onready var ghosts = $"../Ghosts"

@onready var walk_sound = $WalkSound
@onready var catch_sound = $CatchSound

@export var catching = false

var speed = Constants.TILE_SIZE*4
var caught_ghost : Ghost
var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true


func _physics_process(delta):
	var dir_x = Input.get_axis('left', 'right')
	var dir_y = Input.get_axis('up', 'down')
	
	if dir_x > 0:
		sprite_2d.flip_h = true
	elif dir_x < 0:
		sprite_2d.flip_h = false

	walk_sound.stream_paused = true
	if Input.is_action_just_pressed("catch"):
		if Constants.sfx:
			catch_sound.play()
		state_machine.travel('Catch')
		SignalBus.swung.emit()
	elif state_machine.get_current_node() != 'Catch':
		velocity = Vector2(dir_x, dir_y).normalized() * speed
		if velocity.length() > 0:
			direction = velocity.normalized()
			if direction.x > 0:
				catcher.position.x = abs(catcher.position.x)
			else:
				catcher.position.x = -abs(catcher.position.x)
			state_machine.travel('Walk')
			if Constants.sfx:
				walk_sound.stream_paused = false
			move_and_slide()
			SignalBus.moved.emit()
		else:
			state_machine.travel('Idle')


	animation_tree['parameters/Catch/blend_position'] = direction.x
	animation_tree['parameters/Walk/blend_position'].x = direction.x
	animation_tree['parameters/Walk/blend_position'].y = direction.y

	if catching:
		var areas = catcher.get_overlapping_areas()
		for area in areas:
			if area.owner is Ghost:
				var ghost = area.owner
				if !caught_ghost:
					caught_ghost = ghost
					caught_ghost.run_awayer = false
					caught_ghost.speed = 100
					SignalBus.ghost_caught.emit(caught_ghost)
				else:
					SignalBus.show_dialog.emit("Your jar is full. Release the ghost in the jar first if you want to catch a new one.")
	
	if Input.is_action_just_pressed("release"):
		if caught_ghost:
			SignalBus.ghost_released.emit(caught_ghost)
			caught_ghost.unpicturize()
			caught_ghost.position = global_position
			ghosts.add_child(caught_ghost)
			caught_ghost = null
