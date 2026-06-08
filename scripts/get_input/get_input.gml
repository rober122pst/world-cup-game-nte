#macro KEY_RIGHT keyboard_check(vk_right)
#macro KEY_LEFT keyboard_check(vk_left)
#macro KEY_UP keyboard_check(vk_up)
#macro KEY_DOWN keyboard_check(vk_down)
#macro KEY_SHOOT keyboard_check(ord("Z"))
#macro KEY_PASS keyboard_check_pressed(ord("X"))

//var up, down, left, right;

//up = keyboard_check(ord("W"));
//down = keyboard_check(ord("S"));
//left = keyboard_check(ord("D"));
//left = keyboard_check(ord("S"));

//velh = (left - right) * max_vel;

//x += velh;
 
//velv = (down - up) * max_vel;

enum SHOOT_STATE {
	SHOOTING,
	PASSING,
	SHOT,
	PASSED,
	FREEZE
}