var target_fps = 60;
global.dt = clamp(delta_time / (1000000 / target_fps), 0.35, 1.8);

if (global.match_state == MATCH_STATE.PLAYING) global.timer += global.dt;

refresh_field_bounds();

if (control_switch_timer > 0) {
	control_switch_timer = max(control_switch_timer - global.dt, 0);
}

if (global.with_poss != noone && !instance_exists(global.with_poss)) {
	global.with_poss = noone;
}

var _current = (global.player_controlling != noone && instance_exists(global.player_controlling)) ? global.player_controlling : noone;
var _desired = noone;

if (global.with_poss == noone) {
	_desired = best_control_player_for_ball(oTeamPlayer, _current);
} else if (global.with_poss.my_team == global.team_home) {
	_desired = global.with_poss;
} else {
	_desired = best_control_player_for_defense(oTeamPlayer, global.with_poss, _current);
}

if (_desired != noone && instance_exists(_desired)) {
	var _force_switch = false;

	if (_current == noone) _force_switch = true;
	if (global.with_poss == _desired) _force_switch = true;
	if (global.with_poss == noone && _desired != _current) _force_switch = true;

	if (_force_switch || control_switch_timer <= 0) {
		global.player_controlling = _desired;
		last_player_with_control = _desired;
		control_switch_timer = 8;
	}
}


switch (global.match_state) {
	case MATCH_STATE.CURIOSITY:
	case MATCH_STATE.GOAL:
	case MATCH_STATE.VAR:
		if (!has_seted) set_alarm = true;
		break;
}

if (set_alarm) {
	has_seted = true;
	alarm[2] = game_get_speed(gamespeed_fps)*1.5;
	set_alarm = false;
}

with (all) {
	depth = -bbox_bottom;
}
