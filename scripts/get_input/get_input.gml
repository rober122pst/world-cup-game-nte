#macro KEY_RIGHT keyboard_check(vk_right)
#macro KEY_LEFT keyboard_check(vk_left)
#macro KEY_UP keyboard_check(vk_up)
#macro KEY_DOWN keyboard_check(vk_down)
#macro KEY_SHOOT keyboard_check(ord("Z"))
#macro KEY_SHOOT_PRESSED keyboard_check_pressed(ord("Z"))
#macro KEY_SHOOT_RELEASED keyboard_check_released(ord("Z"))
#macro KEY_PASS keyboard_check_pressed(ord("X"))
#macro KEY_TACKLE keyboard_check_pressed(ord("C"))


enum SHOOT_STATE {
	SHOOTING,
	PASSING,
	SHOT,
	PASSED,
	FREEZE
}

enum PLAYER_ROLE {
	DEFENDER,
	MIDFIELDER,
	ATTACKER
}

enum AI_INTENT {
	HOLD,
	CHASE_BALL,
	SUPPORT,
	MARK,
	PRESS,
	TRACK,
	DRIBBLE,
	PASS,
	SHOOT,
	TACKLE
}
