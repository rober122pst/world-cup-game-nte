jump = false;
z = 0;
zspd = 0;
grvt = .3;
fric = .08;
isJumping = false;

global.team_player_nearest = noone;
global.opponent_nearest = noone;

owner = noone;
last_owner = noone;
intended_receiver = noone;
pass_team = "";
pass_assist_timer = 0;
pass_target_x = x;
pass_target_y = y;
pass_chain_team = "";
pass_chain_count = 0;
pickup_lock_timer = 0;
prev_x = x;
prev_y = y;

timer_with_poss = 0;
distance_traveled = 0;

x_init = 0;
y_init = 0;

state = noone;

image_speed = 0;

ball_in_posse_state = function() {
	if (owner != noone && instance_exists(owner)) {
		var _ball_dist = 7;

		if (owner.dx != 0 || owner.dy != 0) {
			image_speed = 1;
			timer_with_poss += global.dt;
		} else {
			image_index = 0;
			timer_with_poss = 0;
		}

		var _dribble_wave = sin(timer_with_poss * 0.15) * 6;

		x = owner.x + lengthdir_x(_ball_dist + abs(_dribble_wave), owner.angle);
		y = owner.y - 2 + lengthdir_y(_ball_dist + abs(_dribble_wave), owner.angle);
		speed = 0;
	} else {
		owner = noone;
		global.with_poss = noone;
		state = free_ball_state;
	}
}

free_ball_state = function() {
	var _speed = min((1 * speed) / 5, 1);
	image_speed = _speed;
}

state = free_ball_state;
