posse = 1;
marcando = 2;
atacando = 3;

dx = 0;
dy = 0;
angle = 0;

hspd = 0; vspd = 0;
max_spd = 3;

acc = 0.4; fric = 0.15;

timer_with_poss = 0;

state = noone;

target = noone;


current_shoot_state = -1;

force = 0;
max_force = 30;
increment_force = 1;

set_alarm = false;

opponent_team_obj = oOpponentPlayer;
my_team = global.team_home;

freeze_state = function () {
	if (!set_alarm) {
		alarm[0] = game_get_speed(gamespeed_fps) / 2;
		set_alarm = true;
	}
}

free_state = function () {
	player_move();
	
	if (place_meeting(x, y, oBall)) {
		state = poss_state;		
	}
	
	current_shoot_state = -1;
}

poss_state = function () {
	player_move();
	global.with_poss = id;
	
	if (dx != 0 || dy != 0) timer_with_poss++; else timer_with_poss = lerp(timer_with_poss, 0, 1);
	var _ball_dist = 7;
	var _pad = 3;
	
	var func = sin(timer_with_poss * 0.15) * 6;
	
	oBall.x = x + lengthdir_x(_ball_dist + abs(func), angle);
	oBall.y = y - _pad + lengthdir_y(_ball_dist + abs(func), angle);
	
	if (KEY_SHOOT) {
		if (current_shoot_state == -1) {
			current_shoot_state = SHOOT_STATE.SHOOTING;	
		} else if (current_shoot_state == SHOOT_STATE.SHOOTING) {
			current_shoot_state = SHOOT_STATE.SHOT;	
		}
	}
	
	if(current_shoot_state == SHOOT_STATE.SHOOTING) {
		force+=increment_force;

		if(force >= max_force) {
			force = max_force;
			current_shoot_state = SHOOT_STATE.SHOT;
		}
	}
	
	if(current_shoot_state == SHOOT_STATE.SHOT) {
		/*if(distance_to_object(oBar) < 192) {
			if(oBall.direction != 180) {
				oBall.direction = 0;
				oBall.x += forca*velx;
				oBall.y += forca*vely;
				oBall.speed = forca;
			}else {
				oBall.speed = forca;
			}
		}else {
			oBall.speed = forca;
		}*/
		oBall.speed = force;
		oBall.direction = angle;
		
		oBall.jump = true;

		force = 0;	
		current_shoot_state = -1;
		set_alarm = false;
		state = freeze_state;
	}
}

state = free_state;