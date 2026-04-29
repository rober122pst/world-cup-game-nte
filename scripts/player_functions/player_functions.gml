function player_move() {
	if (dx != 0 || dy != 0) {
		var _input_dist = point_distance(0, 0, dx, dy);
		angle = point_direction(0, 0, dx, dy);
		
		hspd += (dx / _input_dist) * acc;
		vspd += (dy / _input_dist) * acc;
		
		var _current_vel = point_distance(0, 0, hspd, vspd);
		if (_current_vel >= max_spd) {
			hspd = (hspd / _current_vel) * max_spd;
			vspd = (vspd / _current_vel) * max_spd;
		}
	} else {
		hspd = lerp(hspd, 0, fric);	
		vspd = lerp(vspd, 0, fric);	
	}
	
	y += vspd;
	x += hspd;
	
	if (abs(hspd) <= .1 && abs(vspd) <= .1) {
		sprite_index = sprPlayerIdleSide;
	} else {
		sprite_index = sprPlayerSide;	
	}
	
	if (dx != 0)
		image_xscale = dx;
		
	if (global.with_poss == id) {
		if (dx != 0 || dy != 0) timer_with_poss++; else timer_with_poss = lerp(timer_with_poss, 0, 1);
		var _ball_dist = 7;
		var _pad = 3;
	
		var func = sin(timer_with_poss * 0.15) * 6;
	
		oBall.x = x + lengthdir_x(_ball_dist + abs(func), angle);
		oBall.y = y - _pad + lengthdir_y(_ball_dist + abs(func), angle);
	
		if (KEY_SHOOT) {
			current_shoot_state = SHOOT_STATE.SHOOTING;
			state = shoot_state;
		}	
	}
}

function go_to_ball() {
	show_debug_message("Indo atras da bola");
	dx = sign(oBall.x - x);
	dy = sign(oBall.y - y);

	free_state();
}

function shoot() {
	if(current_shoot_state == SHOOT_STATE.SHOOTING) {
		force+=increment_force;

		if(force >= max_force) {
			force = max_force;
			current_shoot_state = SHOOT_STATE.SHOT;
		}
	}
	
	if(current_shoot_state == SHOOT_STATE.SHOT) {
		oBall.speed = force;
		oBall.direction = angle;
		
		if (force >= force*.75)
			oBall.jump = true;

		force = 0;	
		current_shoot_state = -1;

		state = free_state;
	}	
}