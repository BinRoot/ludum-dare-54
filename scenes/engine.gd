extends Node

signal character_died



var utilities_by_action = {}

var current_state = {
	Globals.STATE_SELF: {
		Globals.INVENTORY: {
			Globals.ITEM_RAW_FISH: 0,
			Globals.ITEM_COOKED_FISH: 0,
			Globals.ITEM_MONEY: 0,
		},
		Globals.HP: Globals.hp_start,
		Globals.LOCATION: Globals.LOCATION_BUSHES,
	},
	Globals.STATE_MARKET: {
		Globals.INVENTORY: {
			Globals.ITEM_RAW_FISH: 0,
			Globals.ITEM_COOKED_FISH: 0,
			Globals.ITEM_MONEY: 0,
		},
	}
}



var skills = [
	Globals.skill_eat,
	Globals.skill_buy_raw_fish,
	Globals.skill_buy_cooked_fish,
	Globals.skill_sell_cooked_fish,
	Globals.skill_sell_raw_fish,	
	Globals.skill_navigate_to_market,
	Globals.skill_navigate_to_docks,
	Globals.skill_navigate_to_camp,
]


func _ready():
	pass


func _physics_process(_delta):
	if current_state[Globals.STATE_SELF][Globals.HP] <= 0:
		emit_signal("character_died")
		return
	current_state[Globals.STATE_MARKET][Globals.INVENTORY] = Globals.market_inventory
	for i in range(5):
		register_sample()


func register_sample():
	var pathAndState = sample()
	var path = pathAndState["path"]
	var state = pathAndState["state"]
	var action_name = path[0]
	var utility = state[Globals.STATE_SELF][Globals.HP]
	if action_name not in utilities_by_action:
		utilities_by_action[action_name] = []
	utilities_by_action[action_name].push_back(utility)


func sample():
	var state = current_state.duplicate(true)
	var path = traverse(10, state, [])
	return { "path": path, "state": state }


func set_money(money):
	current_state[Globals.STATE_SELF][Globals.INVENTORY][Globals.ITEM_MONEY] = money


func remove_skills(skill_names):
	for skill_name_to_remove in skill_names:
		for skill in skills:
			if skill[Globals.NAME] == skill_name_to_remove:
				print('actually removed ', skill[Globals.NAME])
				skill[Globals.INPUT] = {
					Globals.STATE_SELF: {
						Globals.LOCATION: func(x): return false
					}
				}
				break


func add_skills(_skills):
	for s in _skills:
		skills.push_back(s)


func is_skill_valid(skill, state):
	# Check state HP
	if state[Globals.STATE_SELF][Globals.HP] <= 0:
		return false
	
	if Globals.STATE_SELF in skill[Globals.INPUT]:
		var skill_input_self = skill[Globals.INPUT][Globals.STATE_SELF]
	
		# Check inventory
		if Globals.INVENTORY in skill_input_self:
			var self_inventory_criteria = skill_input_self[Globals.INVENTORY]
			var is_inventory_valid = true
			for inventory_name in self_inventory_criteria:
				var inventory_value = state[Globals.STATE_SELF][Globals.INVENTORY][inventory_name]
				if not self_inventory_criteria[inventory_name].call(inventory_value):
					is_inventory_valid = false
					break
			if not is_inventory_valid:
				return false
				
		# Check location
		if Globals.LOCATION in skill_input_self:
			var self_location_criteria = skill_input_self[Globals.LOCATION]
			var is_location_valid = self_location_criteria.call(state[Globals.STATE_SELF][Globals.LOCATION])
			if not is_location_valid:
				return false
				
	# Check market
	if Globals.STATE_MARKET in skill[Globals.INPUT]:
		var skill_input_market = skill[Globals.INPUT][Globals.STATE_MARKET]
		if Globals.INVENTORY in skill_input_market:
			var market_inventory_criteria = skill_input_market[Globals.INVENTORY]
			var is_inventory_valid = true
			for inventory_name in market_inventory_criteria:
				var inventory_value = state[Globals.STATE_MARKET][Globals.INVENTORY][inventory_name]
				if not market_inventory_criteria[inventory_name].call(inventory_value):
					is_inventory_valid = false
					break
			if not is_inventory_valid:
				return false
			
	return true


func do_skill(skill, state, is_real=false):
	
	var output = skill[Globals.OUTPUT]
	
	if Globals.STATE_SELF in output:
		# Update HP
		if Globals.HP in skill[Globals.OUTPUT][Globals.STATE_SELF]:
			var hp_update = skill[Globals.OUTPUT][Globals.STATE_SELF][Globals.HP]
			state[Globals.STATE_SELF][Globals.HP] = hp_update.call(state[Globals.STATE_SELF][Globals.HP])
		
		# Update inventory
		var is_real_fight = is_real and skill[Globals.NAME] == "fight"
		if not is_real_fight and Globals.INVENTORY in output[Globals.STATE_SELF]:
			for inventory_name in skill[Globals.OUTPUT][Globals.STATE_SELF][Globals.INVENTORY]:
				state[Globals.STATE_SELF][Globals.INVENTORY][inventory_name] = skill[Globals.OUTPUT][Globals.STATE_SELF][Globals.INVENTORY][inventory_name].call(
					state[Globals.STATE_SELF][Globals.INVENTORY][inventory_name]
				)
			
		# Update location
		if Globals.LOCATION in output[Globals.STATE_SELF]:
			state[Globals.STATE_SELF][Globals.LOCATION] = skill[Globals.OUTPUT][Globals.STATE_SELF][Globals.LOCATION].call(
				state[Globals.STATE_SELF][Globals.LOCATION]
			)
	
	# Update market
	if Globals.STATE_MARKET in output:
		if Globals.INVENTORY in output[Globals.STATE_MARKET]:
			for inventory_name in skill[Globals.OUTPUT][Globals.STATE_MARKET][Globals.INVENTORY]:
				state[Globals.STATE_MARKET][Globals.INVENTORY][inventory_name] = skill[Globals.OUTPUT][Globals.STATE_MARKET][Globals.INVENTORY][inventory_name].call(
					state[Globals.STATE_MARKET][Globals.INVENTORY][inventory_name]
				)
		if is_real:
			Globals.market_inventory = state[Globals.STATE_MARKET][Globals.INVENTORY]
	
	# Optimistic bias that markets always improve
	if not is_real and randi() % 2 == 0:
		var market_items = state[Globals.STATE_MARKET][Globals.INVENTORY].keys()
		var inventory_name = market_items[randi() % len(market_items)]
		state[Globals.STATE_MARKET][Globals.INVENTORY][inventory_name] += 1
	
	# Post-skill effects
	state[Globals.STATE_SELF][Globals.HP] -= Globals.hp_loss_from_time


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
		return traverse(depth - 1, state, path + [skills[chosen_skill_index][Globals.NAME]])
	else:
		return path


func commit_action() -> String:
	var max_avg_utility: float = -1
	var best_action: String
	for action_name in utilities_by_action:
		var utilities = utilities_by_action[action_name]
		if len(utilities) > 0:
			var avg_utility = utilities.reduce(func (x, y): return x + y) / (0.0 + len(utilities))
			var high_utilities = utilities.filter(func(x): return x > avg_utility)
			var avg_high_utility = avg_utility
			if len(high_utilities) > 0:
				avg_high_utility = high_utilities.reduce(func (x, y): return x + y) / (0.0 + len(high_utilities))
			
#			print('--- ', action_name ,': ', avg_utility, ', ', avg_high_utility)
			if avg_high_utility > max_avg_utility:
				max_avg_utility = avg_high_utility
				best_action = action_name
				
#	print('best_action: ', best_action, ', max_avg_utility: ', max_avg_utility)
				
	utilities_by_action = {}
	
	
	if best_action != null:
		var found_skill
		for skill in skills:
			if skill[Globals.NAME] == best_action:
				found_skill = skill
				break
		do_skill(found_skill, current_state, true)
	return best_action
	

