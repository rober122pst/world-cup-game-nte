#macro KEY_RIGHT keyboard_check(vk_right)
#macro KEY_LEFT keyboard_check(vk_left)
#macro KEY_UP keyboard_check(vk_up)
#macro KEY_DOWN keyboard_check(vk_down)
#macro KEY_SHOOT keyboard_check_pressed(ord("Z"))
#macro KEY_PASS keyboard_check_pressed(ord("X"))


enum SHOOT_STATE {
	SHOOTING,
	PASSING,
	SHOT,
	PASSED
}