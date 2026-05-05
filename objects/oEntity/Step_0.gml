if (busy_timer > 0) {
	busy_timer--;	
} else {
	is_busy = false;	
}


if (object_index != oPlayer && !is_busy) current_action_node = ai_tree.evaluate(id);

if (current_action_node != -1) {
	current_action_node.execute_logic(id);	
}

with (oBar) {
	if (team != other.my_team) {
		other.target = id;
		break;
	}
}