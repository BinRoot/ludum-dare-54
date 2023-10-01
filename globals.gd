extends Node

const ITEM_RAW_FISH: String = 'raw_fish'
const ITEM_COOKED_FISH: String = 'cooked_fish'
const ITEM_MONEY: String = 'money'

const STATE_SELF: String = "self"
const STATE_MARKET: String = "market"
const INVENTORY: String = "inventory"
const HP: String = "hp"
const INPUT: String = "input"
const OUTPUT: String = "output"
const NAME: String = "name"
const LOCATION:String = "location"

const LOCATION_MARKET = "market"
const LOCATION_DOCKS = "docks"
const LOCATION_BUSHES = "bushes"
const LOCATION_CAMP = "camp"

var hp_start = 20
var hp_gain_from_eating_cooked_fish = 5
var hp_loss_from_time = 1

var money_start = 10
var money_cost_of_cooked_fish = 6
var money_cost_of_raw_fish = 3

const RESCUED: String = "rescued"

const CHARACTER_RES: Resource = preload("res://scenes/character.tscn")

var boat_sunk: bool = false

var market_inventory = {
	Globals.ITEM_COOKED_FISH: 0,
	Globals.ITEM_RAW_FISH: 0,
}

var skill_eat = {
	Globals.NAME: "eat",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x > 0
			}
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x - 1
			},
			Globals.HP: func(x): return x + Globals.hp_gain_from_eating_cooked_fish
		}
	}
}

var skill_buy_cooked_fish = {
	Globals.NAME: "buy_cooked_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x >= Globals.money_cost_of_cooked_fish
			},
			Globals.LOCATION: func(x): return x == Globals.LOCATION_MARKET
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x > 0
			}
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x - Globals.money_cost_of_cooked_fish,
				Globals.ITEM_COOKED_FISH: func(x): return x + 1
			}
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x - 1
			}
		}
	}
}

var skill_buy_raw_fish = {
	Globals.NAME: "buy_raw_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x >= Globals.money_cost_of_raw_fish
			},
			Globals.LOCATION: func(x): return x == Globals.LOCATION_MARKET
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x > 0
			}
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x - Globals.money_cost_of_raw_fish,
				Globals.ITEM_RAW_FISH: func(x): return x + 1
			}
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x - 1
			}
		}
	}
}

var skill_sell_cooked_fish = {
	Globals.NAME: "sell_cooked_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x > 0
			},
			Globals.LOCATION: func(x): return x == Globals.LOCATION_MARKET
		},
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x + Globals.money_cost_of_cooked_fish,
				Globals.ITEM_COOKED_FISH: func(x): return x - 1
			}
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_COOKED_FISH: func(x): return x + 1
			}
		}
	}
}

var skill_navigate_to_market = {
	Globals.NAME: "navigate_to_market",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(x): return x != Globals.LOCATION_MARKET
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(_x): return Globals.LOCATION_MARKET
		}
	}
}

var skill_navigate_to_docks = {
	Globals.NAME: "navigate_to_docks",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(x): return x != Globals.LOCATION_DOCKS
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(_x): return Globals.LOCATION_DOCKS
		}
	}
}

var skill_navigate_to_camp = {
	Globals.NAME: "navigate_to_camp",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(x): return x != Globals.LOCATION_CAMP
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(_x): return Globals.LOCATION_CAMP
		}
	}
}

var skill_sell_raw_fish = {
	Globals.NAME: "sell_raw_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x > 0
			},
			Globals.LOCATION: func(x): return x == Globals.LOCATION_MARKET
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_MONEY: func(x): return x + Globals.money_cost_of_raw_fish,
				Globals.ITEM_RAW_FISH: func(x): return x - 1
			}
		},
		Globals.STATE_MARKET: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x + 1
			}
		}
	}
}

var skill_fight = {
	Globals.NAME: "fight",
	Globals.INPUT: {
		Globals.STATE_SELF: {}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x + 2,
				Globals.ITEM_MONEY: func(x): return x + 5
			},
			Globals.HP: func(x): return x - 5
		}
	}
}

var skill_catch_fish = {
	Globals.NAME: "catch_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.LOCATION: func(x): return x == Globals.LOCATION_DOCKS
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x + 2
			}
		}
	}
}

var skill_cook_fish = {
	Globals.NAME: "cook_fish",
	Globals.INPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x > 0
			},
			Globals.LOCATION: func(x): return x == Globals.LOCATION_CAMP
		}
	},
	Globals.OUTPUT: {
		Globals.STATE_SELF: {
			Globals.INVENTORY: {
				Globals.ITEM_RAW_FISH: func(x): return x - 1,
				Globals.ITEM_COOKED_FISH: func(x): return x + 2
			}
		}
	}
}

var characters: Array = [
	{
		"name": "Convict",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/convict_face.tscn"),
		"shouts": [
			"Time for an island prison break?",
			"Not quite Alcatraz, but it's close!",
			"Ahoy there, need a five-star escape artist?",
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Circus Monkey",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/circus_monkey_face.tscn"),
		"shouts": [
			"Forget the trapeze, I need a sea breeze!",
			"Ooh Oooh Ahh Ahhh!",
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Vampire",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/vampire_face.tscn"),
		"shouts": [
			"Sunblock's running out, get me outta here!",
			"Anyone got a coffin ship?",
			"This ship bites!",
		],
		"skills": [
			skill_fight,
		],
		"money": 5
	},
	{
		"name": "Aristocrat",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/aristocrat_face.tscn"),
		"shouts": [
			"Rescue me, I've run out of caviar!",
			"I demand a first-class lifeboat!",
			"Ahoy, commoners! First one to save me gets knighted!",
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 15
	},
	{
		"name": "Leper",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/leper_face.tscn"),
		"shouts": [
			"I've been social distancing before it was cool",
			"Quarantine on land is bad, but at sea it's worse!",
		],
		"skills": [
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Fortune Teller",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/fortune_teller.tscn"),
		"shouts": [
			"Tarot says it's time to pick me up!",
			"I foresee a rescue in my immediate future!",
			"Help, or I'll hex your GPS!",
		],
		"skills": [
			skill_catch_fish
		],
		"money": 5
	},
	{
		"name": "Duck",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/duck_face.tscn"),
		"shouts": [
			"What a quack-tastrophe!",
			"Waddle I do now? Help!",
			"No ducking around, get me outta here!",
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Housewife",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/housewife_face.tscn"),
		"shouts": [
			"This isn't the kind of 'swept away' I had in mind!",
			"No bake sale can fix this!",
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 5
	},
	{
		"name": "Child",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/child_face.tscn"),
		"shouts": [
			"Mom said no swimming!",
			"Is it snack time yet?",
			"Can I go home now?"
		],
		"skills": [
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Grandma",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/grandma_face.tscn"),
		"shouts": [
			"This isn't my idea of a senior cruise!",
			"I've got wisdom, you've got a boat. Deal?",
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 5
	},
	{
		"name": "Orphan",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/orphan_face.tscn"),
		"shouts": [
			"From foster care to nautical flare!",
			"Adopt me off this island, ASAP!",
			"Wanted: New guardians with a yacht!",
		],
		"skills": [
			skill_catch_fish,
		],
		"money": 0
	},
	{
		"name": "Fisherman",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/fisherman_face.tscn"),
		"shouts": [
			"Reel me in, captain!",
			"Gone fishin'... too far!",
			"I've got bait, you've got boat!"
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 5
	},
	{
		"name": "Chef",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/chef_face.tscn"),
		"shouts": [
			"Out of the frying pan, into the open sea!",
			"Only thing salty is how long it takes for a rescue!"
		],
		"skills": [
			skill_cook_fish,
			skill_fight,
		],
		"money": 5
	},
	{
		"name": "Doctor",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/doctor_face.tscn"),
		"shouts": [
			"I can offer free health care!",
			"This boat is not FDA-approved!",
			"From emergency room to emergency raft!"
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 10
	},
	{
		"name": "Lumberjack",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/lumberjack_face.tscn"),
		"shouts": [
			"Flannels don't float, help!",
			"Timber!"
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Cowboy",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/cowboy_face.tscn"),
		"shouts": [
			"These boots weren't made for swimming!",
			"Lasso me up a lifeboat!",
			"Not my first rodeo, but could be my last!"
		],
		"skills": [
			skill_fight,
			skill_catch_fish,
		],
		"money": 0
	},
	{
		"name": "Sailor",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/sailor_face.tscn"),
		"shouts": [
			"Permission to come aboard?",
			"I've got spinach!"
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Opera Singer",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/opera_singer_face.tscn"),
		"shouts": [
			"It's not over 'til the fat lady sails!",
			"Ahoy, I can't duet alone here!",
			"Encore? More like on-shore!"
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 5
	},
	{
		"name": "Dog",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/dog_face.tscn"),
		"shouts": [
			"This dog park is wet!",
			"Woof woof woof woof!"
		],
		"skills": [
			skill_catch_fish,
			skill_fight,
		],
		"money": 0
	},
	{
		"name": "Seamstress",
		"is_alive": true,
		RESCUED: false,
		"face": preload("res://scenes/characters/seamstress_face.tscn"),
		"shouts": [
			"Measure twice, rescue once!",
			"Tangled in wool, and also in woe!"
		],
		"skills": [
			skill_cook_fish,
		],
		"money": 5
	},
]

func get_character_by_name(character_name: String):
	for character in Globals.characters:
		if character["name"] == character_name:
			return character
	return null
