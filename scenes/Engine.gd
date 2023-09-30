extends Node

const ITEM_RAW_FISH: String = 'raw_fish'
const ITEM_COOKED_FISH: String = 'cooked_fish'
const ITEM_MONEY: String = 'money'

const STATE_SELF: String = "self"
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

var utilities_by_action = {}

var current_state = {
	STATE_SELF: {
		INVENTORY: {
			ITEM_RAW_FISH: 0,
			ITEM_COOKED_FISH: 0,
			ITEM_MONEY: 0,
		},
		HP: Globals.hp_start,
		LOCATION: LOCATION_DOCKS,
	},
}

var skill_eat = {
	NAME: "eat",
	INPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_COOKED_FISH: func(x): return x > 0
			}
		}
	},
	OUTPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_COOKED_FISH: func(x): return x - 1
			},
			HP: func(x): return x + Globals.hp_gain_from_eating_cooked_fish
		}
	}
}

var skill_buy_cooked_fish = {
	NAME: "buy_cooked_fish",
	INPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_MONEY: func(x): return x >= Globals.money_cost_of_cooked_fish
			},
			LOCATION: func(x): return x == LOCATION_MARKET
		}
	},
	OUTPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_MONEY: func(x): return x - Globals.money_cost_of_cooked_fish,
				ITEM_COOKED_FISH: func(x): return x + 1
			}
		}
	}
}

var skill_navigate_to_market = {
	NAME: "navigate_to_market",
	INPUT: {
		STATE_SELF: {
			LOCATION: func(x): return x != LOCATION_MARKET
		}
	},
	OUTPUT: {
		STATE_SELF: {
			LOCATION: func(x): return LOCATION_MARKET
		}
	}
}

var skill_navigate_to_docks = {
	NAME: "navigate_to_docks",
	INPUT: {
		STATE_SELF: {
			LOCATION: func(x): return x != LOCATION_DOCKS
		}
	},
	OUTPUT: {
		STATE_SELF: {
			LOCATION: func(x): return LOCATION_DOCKS
		}
	}
}

var skill_sell_raw_fish = {
	NAME: "sell_raw_fish",
	INPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_RAW_FISH: func(x): return x > 0
			},
			LOCATION: func(x): return x == LOCATION_MARKET
		}
	},
	OUTPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_MONEY: func(x): return x + Globals.money_cost_of_raw_fish,
				ITEM_RAW_FISH: func(x): return x - 1
			}
		}
	}
}

var skill_catch_fish = {
	NAME: "catch_fish",
	INPUT: {
		STATE_SELF: {
			LOCATION: func(x): return x == LOCATION_DOCKS
		}
	},
	OUTPUT: {
		STATE_SELF: {
			INVENTORY: {
				ITEM_RAW_FISH: func(x): return x + 2
			}
		}
	}
}

var skills = [
	skill_eat,
	skill_buy_cooked_fish,
	skill_navigate_to_market,
	skill_navigate_to_docks,
	skill_sell_raw_fish,
	skill_catch_fish,
]


func _ready():
	pass


func _process(delta):
	var pathAndState = sample()
	var path = pathAndState["path"]
	var state = pathAndState["state"]
	var action_name = path[0]
	var utility = state[STATE_SELF][HP]
	if action_name not in utilities_by_action:
		utilities_by_action[action_name] = []
	utilities_by_action[action_name].push_back(utility)


func utility(path):
	pass


func sample():
	var state = current_state.duplicate(true)
	var path = traverse(20, state, [])
	return { "path": path, "state": state }


func is_skill_valid(skill, state):
	# Check state HP
	if state[STATE_SELF][HP] <= 0:
		return false
	
	var skill_input_self = skill[INPUT][STATE_SELF]
	
	# Check inventory
	if INVENTORY in skill_input_self:
		var self_inventory_criteria = skill_input_self[INVENTORY]
		var is_inventory_valid = true
		for inventory_name in self_inventory_criteria:
			var inventory_value = state[STATE_SELF][INVENTORY][inventory_name]
			if not self_inventory_criteria[inventory_name].call(inventory_value):
				is_inventory_valid = false
				break
		if not is_inventory_valid:
			return false
			
	# Check location
	if LOCATION in skill_input_self:
		var self_location_criteria = skill_input_self[LOCATION]
		var is_location_valid = self_location_criteria.call(state[STATE_SELF][LOCATION])
		if not is_location_valid:
			return false
			
	return true


func do_skill(skill, state):
	# Update HP
	if HP in skill[OUTPUT][STATE_SELF]:
		var hp_update = skill[OUTPUT][STATE_SELF][HP]
		state[STATE_SELF][HP] = hp_update.call(state[STATE_SELF][HP])
		
	# Update inventory
	if INVENTORY in skill[OUTPUT][STATE_SELF]:
		for inventory_name in skill[OUTPUT][STATE_SELF][INVENTORY]:
			state[STATE_SELF][INVENTORY][inventory_name] = skill[OUTPUT][STATE_SELF][INVENTORY][inventory_name].call(
				state[STATE_SELF][INVENTORY][inventory_name]
			)
			
	# Update location
	if LOCATION in skill[OUTPUT][STATE_SELF]:
		state[STATE_SELF][LOCATION] = skill[OUTPUT][STATE_SELF][LOCATION].call(
			state[STATE_SELF][LOCATION]
		)
	
	# Post-skill effects
	state[STATE_SELF][HP] -= Globals.hp_loss_from_time


func traverse(depth, state, path):
	if depth <= 0:
		return path
	var valid_skill_indices = []
	for i in range(len(skills)):
		if is_skill_valid(skills[i], state):
			valid_skill_indices.push_back(i)
	if len(valid_skill_indices) > 0:
		var chosen_skill_index = valid_skill_indices[randi() % len(valid_skill_indices)]
		do_skill(skills[chosen_skill_index], state)
		return traverse(depth - 1, state, path + [skills[chosen_skill_index][NAME]])
	else:
		return path


func commit_action() -> String:
	var max_avg_utility: float = -1
	var best_action: String
	for action_name in utilities_by_action:
		var utilities = utilities_by_action[action_name]
		if len(utilities) > 0:
			var avg_utility = utilities.reduce(func (x, y): return x + y) / (0.0 + len(utilities))
			if avg_utility > max_avg_utility:
				max_avg_utility = avg_utility
				best_action = action_name
				
	print('best_action: ', best_action, ', max_avg_utility: ', max_avg_utility)
				
	utilities_by_action = {}
	
	
	if best_action != null:
		var skill_idx = skills.find(func(x): return x[NAME] == best_action)
		var found_skill
		for skill in skills:
			if skill[NAME] == best_action:
				found_skill = skill
				break
		do_skill(found_skill, current_state)
	return best_action
	


func _on_timer_timeout():
	var action_name = commit_action()
	print(action_name)
