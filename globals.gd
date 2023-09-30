extends Node

var hp_start = 20
var hp_gain_from_eating_cooked_fish = 5
var hp_loss_from_time = 1

var money_start = 10
var money_cost_of_cooked_fish = 5
var money_cost_of_raw_fish = 3

const RESCUED: String = "rescued"

var characters: Array = [
	{
		"name": "Convict",
		RESCUED: false,
	},
	{
		"name": "Circus Monkey",
		RESCUED: false,
	},
	{
		"name": "Vampire",
		RESCUED: false,
	},
	{
		"name": "Aristocrat",
		RESCUED: false,
	},
	{
		"name": "Leper",
		RESCUED: false,
	},
	{
		"name": "Forune Teller",
		RESCUED: false,
	},
	{
		"name": "Duck",
		RESCUED: false,
	},
	{
		"name": "Housewife",
		RESCUED: false,
	},
	{
		"name": "Child",
		RESCUED: false,
	},
	{
		"name": "Grandma",
		RESCUED: false,
	},
	{
		"name": "Orphan",
		RESCUED: false,
	},
	{
		"name": "Fisherman",
		RESCUED: false,
	},
	{
		"name": "Chef",
		RESCUED: false,
	},
	{
		"name": "Doctor",
		RESCUED: false,
	},
	{
		"name": "Lumberjack",
		RESCUED: false,
	},
	{
		"name": "Cowboy",
		RESCUED: false,
	},
	{
		"name": "Sailor",
		RESCUED: false,
	},
	{
		"name": "Opera Singer",
		RESCUED: false,
	},
	{
		"name": "Dog",
		RESCUED: false,
	},
	{
		"name": "Seamstress",
		RESCUED: false,
	},
]

