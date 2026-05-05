jump = false;
z = 0;
zspd = 0;
grvt = .3;
fric = .08;
isJumping = false;

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
		y = owner.y - 3 + lengthdir_y(_ball_dist + abs(func), owner.angle);
		speed = 0;
	}	
}

state = ball_in_posse_state;