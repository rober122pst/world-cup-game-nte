ai_tree = noone;
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