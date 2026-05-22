jump = false;
z = 0;
zspd = 0;
grvt = .3;
fric = .08;
isJumping = false;

global.team_player_nearest = noone;
global.opponent_nearest= noone;

owner = noone;

timer_with_poss = 0;

distancia_pecorrida = 0;

x_init = 0; y_init = 0;

state = noone;

image_speed = 0;

ball_in_posse_state = function() {
	if (owner != noone) {
		var _ball_dist = 7;
		if (owner.dx != 0 || owner.dy != 0) {
			image_speed = 1;
			timer_with_poss += global.dt;
		}
		else {
			image_index = 0;
			timer_with_poss = 0;	
		}
	
		var func = sin(timer_with_poss * 0.15) * 6;
	
		x = owner.x + lengthdir_x(_ball_dist + abs(func), owner.angle);
		y = owner.y - 2 + lengthdir_y(_ball_dist + abs(func), owner.angle);
		speed = 0;
	} else {
		state = free_ball_state;	
	}
}

free_ball_state = function() {
	var _speed = min((1*speed) / 5, 1);
	//if (_speed > 0.01) show_debug_message(_speed);
	image_speed = _speed;	
}

state = free_ball_state;