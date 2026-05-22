if (busy_timer > 0) {
	busy_timer-=global.dt;	
} else {
	is_busy = false;	
}

//if (has_ball) show_debug_message(decision);


if (global.player_controlling != id && !is_busy) {
	current_action_node = ai_tree.evaluate(id);
} else {
	if (global.player_controlling == id) {
		state();

		dx = KEY_RIGHT - KEY_LEFT;
		dy = KEY_DOWN - KEY_UP;

		if (KEY_SHOOT && has_ball) {
			current_shoot_state = SHOOT_STATE.SHOOTING;
			increment_shoot_force(id);	
		} else if (current_shoot_state == SHOOT_STATE.SHOOTING) {
			if (current_shoot_state != SHOOT_STATE.SHOT) {
				current_shoot_state = SHOOT_STATE.SHOT;
			}
			if (current_shoot_state = SHOOT_STATE.SHOT) {
				shot();
			}
		}	
	}	
}

if (current_action_node != -1 && global.player_controlling != id) {
	current_action_node.execute_logic(id);	
}

with (oBar) {
	if (team != other.my_team) {
		other.target = id;
	} else {
		other.my_goal = id;
	}
}