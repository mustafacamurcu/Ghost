extends Node

const TILES_WIDTH = 26
const TILES_HEIGHT = 20
const TILE_SIZE = 512
const W = TILES_WIDTH * TILE_SIZE
const H = TILES_HEIGHT * TILE_SIZE


const BODIES = [preload("res://parts/bodies/ghost.png")]
const SHOES = [preload("res://parts/shoes/black_shoe_left.png"), preload("res://parts/shoes/black_shoe_right.png"), preload("res://parts/shoes/boots.png"), preload("res://parts/shoes/pink_shoes.png")]
const HATS = [preload("res://parts/hats/blue_cap.png"), preload("res://parts/hats/flower_beanie.png"), preload("res://parts/hats/music_beanie.png"), preload("res://parts/hats/orange_beanie.png"), preload("res://parts/hats/perryhat.png"), preload("res://parts/hats/pink_cap.png"), preload("res://parts/hats/piratehat.png"), preload("res://parts/hats/strawhat.png"), preload("res://parts/hats/yellow_beanie.png")]
const EYES = [preload("res://parts/eyes/disguise.png"), preload("res://parts/eyes/eyepatch.png"), preload("res://parts/eyes/eyes.png"), preload("res://parts/eyes/nerdglasses.png"), preload("res://parts/eyes/roundglasses.png"), preload("res://parts/eyes/sleepyeyes.png"), preload("res://parts/eyes/smalleyes.png"), preload("res://parts/eyes/purpleglasses.png")]
const ACCESSORIES = [preload("res://parts/accessories/baseball_bat.png"), preload("res://parts/accessories/basketball.png"), preload("res://parts/accessories/bird.png"), preload("res://parts/accessories/bird_red.png"), preload("res://parts/accessories/flower.png"), preload("res://parts/accessories/telescope.png"), preload("res://parts/accessories/tennis.png")]

const EYEPATCH = preload("res://parts/eyes/eyepatch.png")
const DISGUISE = preload("res://parts/eyes/disguise.png")
const PURPLEGLASSES = preload("res://parts/eyes/purpleglasses.png")

const BIRD = preload("res://parts/accessories/bird.png")
const PIRATEHAT = preload("res://parts/hats/piratehat.png")
const FLOWER = preload("res://parts/accessories/flower.png")
const SLEEPYEYES = preload("res://parts/eyes/sleepyeyes.png")
const FLOWER_BEANIE = preload("res://parts/hats/flower_beanie.png")
const TELESCOPE = preload("res://parts/accessories/telescope.png")

const NORMAL_EYES = preload("res://parts/eyes/eyes.png")
const NERDGLASSES = preload("res://parts/eyes/nerdglasses.png")
const ROUNDGLASSES = preload("res://parts/eyes/roundglasses.png")
const SMALLEYES = preload("res://parts/eyes/smalleyes.png")
const BLUE_CAP = preload("res://parts/hats/blue_cap.png")
const MUSIC_BEANIE = preload("res://parts/hats/music_beanie.png")
const ORANGE_BEANIE = preload("res://parts/hats/orange_beanie.png")
const PERRYHAT = preload("res://parts/hats/perryhat.png")
const PINK_CAP = preload("res://parts/hats/pink_cap.png")
const STRAWHAT = preload("res://parts/hats/strawhat.png")
const YELLOW_BEANIE = preload("res://parts/hats/yellow_beanie.png")
const TENNIS = preload("res://parts/accessories/tennis.png")
const BIRD_RED = preload("res://parts/accessories/bird_red.png")
const BASKETBALL = preload("res://parts/accessories/basketball.png")
const BASEBALL_BAT = preload("res://parts/accessories/baseball_bat.png")

const WORDS = {
	EYEPATCH: "Eye Patch",
	BASEBALL_BAT: "Baseball Bat",
	BIRD_RED: "Red Bird",
	TENNIS: "Tennis",
	BASKETBALL: "Basketball",
	DISGUISE: "SUSPICION",
	PURPLEGLASSES: "Sunglasses",
	BIRD: "Parrot",
	PIRATEHAT: "Pirate Hat",
	TELESCOPE: "Telescope",
	FLOWER: "Flowers",
	SLEEPYEYES: "Sleepy",
	FLOWER_BEANIE: "Flower Beanie",
	NORMAL_EYES: "Good Eyes",
	NERDGLASSES: "Square Glasses",
	ROUNDGLASSES: "Round Glasses",
	SMALLEYES: "Squinty Eyes",
	BLUE_CAP: "Blue Cap",
	MUSIC_BEANIE: "Music Beanie",
	ORANGE_BEANIE: "Regular Orange Beanie",
	PERRYHAT: "Adventurer Hat",
	PINK_CAP: "Pink Cap",
	STRAWHAT: "Straw Hat",
	YELLOW_BEANIE: "Regular Yellow Beanie",
}

var sfx = true
func _on_sfx_toggled(on):
	sfx = on

func _ready():
	SignalBus.sfx_toggled.connect(_on_sfx_toggled)

