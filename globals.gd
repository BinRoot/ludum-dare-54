extends Node

var hp_start = 20
var hp_gain_from_eating_cooked_fish = 5
var hp_loss_from_time = 1

var money_start = 10
var money_cost_of_cooked_fish = 5
var money_cost_of_raw_fish = 3

const RESCUED: String = "rescued"

const CHARACTER_RES: Resource = preload("res://scenes/character.tscn")

var boat_sunk: bool = false

var characters: Array = [
	{
		"name": "Convict",
		RESCUED: false,
		"face": preload("res://scenes/characters/convict_face.tscn"),
		"shouts": [
			"Time for an island prison break?",
			"Not quite Alcatraz, but it's close!",
			"Ahoy there, need a five-star escape artist?",
		]
	},
	{
		"name": "Circus Monkey",
		RESCUED: false,
		"face": preload("res://scenes/characters/circus_monkey_face.tscn"),
		"shouts": [
			"Forget the trapeze, I need a sea breeze!",
			"Ooh Oooh Ahh Ahhh!",
		]
	},
	{
		"name": "Vampire",
		RESCUED: false,
		"face": preload("res://scenes/characters/vampire_face.tscn"),
		"shouts": [
			"Sunblock's running out, get me outta here!",
			"Anyone got a coffin ship?",
			"This ship bites!",
		]
	},
	{
		"name": "Aristocrat",
		RESCUED: false,
		"face": preload("res://scenes/characters/aristocrat_face.tscn"),
		"shouts": [
			"Rescue me, I've run out of caviar!",
			"I demand a first-class lifeboat!",
			"Ahoy, commoners! First one to save me gets knighted!",
		]
	},
	{
		"name": "Leper",
		RESCUED: false,
		"face": preload("res://scenes/characters/leper_face.tscn"),
		"shouts": [
			"I've been social distancing before it was cool",
			"Quarantine on land is bad, but at sea it's worse!",
		]
	},
	{
		"name": "Fortune Teller",
		RESCUED: false,
		"face": preload("res://scenes/characters/fortune_teller.tscn"),
		"shouts": [
			"Tarot says it's time to pick me up!",
			"I foresee a rescue in my immediate future!",
			"Help, or I'll hex your GPS!",
		]
	},
	{
		"name": "Duck",
		RESCUED: false,
		"face": preload("res://scenes/characters/duck_face.tscn"),
		"shouts": [
			"What a quack-tastrophe!",
			"Waddle I do now? Help!",
			"No ducking around, get me outta here!",
		]
	},
	{
		"name": "Housewife",
		RESCUED: false,
		"face": preload("res://scenes/characters/housewife_face.tscn"),
		"shouts": [
			"This isn't the kind of 'swept away' I had in mind!",
			"No bake sale can fix this!",
		]
	},
	{
		"name": "Child",
		RESCUED: false,
		"face": preload("res://scenes/characters/child_face.tscn"),
		"shouts": [
			"Mom said no swimming!",
			"Is it snack time yet?",
			"Can I go home now?"
		]
	},
	{
		"name": "Grandma",
		RESCUED: false,
		"face": preload("res://scenes/characters/grandma_face.tscn"),
		"shouts": [
			"This isn't my idea of a senior cruise!",
			"I've got wisdom, you've got a boat. Deal?",
		]
	},
	{
		"name": "Orphan",
		RESCUED: false,
		"face": preload("res://scenes/characters/orphan_face.tscn"),
		"shouts": [
			"From foster care to nautical flare!",
			"Adopt me off this island, ASAP!",
			"Wanted: New guardians with a yacht!",
		]
	},
	{
		"name": "Fisherman",
		RESCUED: false,
		"face": preload("res://scenes/characters/fisherman_face.tscn"),
		"shouts": [
			"Reel me in, captain!",
			"Gone fishin'... too far!",
			"I've got bait, you've got boat!"
		]
	},
	{
		"name": "Chef",
		RESCUED: false,
		"face": preload("res://scenes/characters/chef_face.tscn"),
		"shouts": [
			"Out of the frying pan, into the open sea!",
			"Only thing salty is how long it takes for a rescue!"
		]
	},
	{
		"name": "Doctor",
		RESCUED: false,
		"face": preload("res://scenes/characters/doctor_face.tscn"),
		"shouts": [
			"I can offer free health care!",
			"This boat is not FDA-approved!",
			"From emergency room to emergency raft!"
		]
	},
	{
		"name": "Lumberjack",
		RESCUED: false,
		"face": preload("res://scenes/characters/lumberjack_face.tscn"),
		"shouts": [
			"Flannels don't float, help!",
			"Timber!"
		]
	},
	{
		"name": "Cowboy",
		RESCUED: false,
		"face": preload("res://scenes/characters/cowboy_face.tscn"),
		"shouts": [
			"These boots weren't made for swimming!",
			"Lasso me up a lifeboat!",
			"Not my first rodeo, but could be my last!"
		]
	},
	{
		"name": "Sailor",
		RESCUED: false,
		"face": preload("res://scenes/characters/sailor_face.tscn"),
		"shouts": [
			"Permission to come aboard?",
			"I've got spinach!"
		]
	},
	{
		"name": "Opera Singer",
		RESCUED: false,
		"face": preload("res://scenes/characters/opera_singer_face.tscn"),
		"shouts": [
			"It's not over 'til the fat lady sails!",
			"Ahoy, I can't duet alone here!",
			"Encore? More like on-shore!"
		]
	},
	{
		"name": "Dog",
		RESCUED: false,
		"face": preload("res://scenes/characters/dog_face.tscn"),
		"shouts": [
			"This dog park is wet!",
			"Woof woof woof woof!"
		]
	},
	{
		"name": "Seamstress",
		RESCUED: false,
		"face": preload("res://scenes/characters/seamstress_face.tscn"),
		"shouts": [
			"Measure twice, rescue once!",
			"Tangled in wool, and also in woe!"
		]
	},
]

func get_character_by_name(character_name: String):
	for character in Globals.characters:
		if character["name"] == character_name:
			return character
	return null
