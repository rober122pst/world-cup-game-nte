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

function go_to_ball (_actor) {
	_actor.decision = "Indo atras da bola";
	_actor.dx = sign(oBall.x - _actor.x);
	_actor.dy = sign(oBall.y - _actor.y);

	_actor.free_state();
}

function shooting(_actor) {
	shoot(_actor.id);
	if (_actor.current_shoot_state == -1) _actor.current_shoot_state = SHOOT_STATE.SHOOTING;
	_actor.timer_to_shoot += 1 / game_get_speed(gamespeed_fps);
	
	var req_force = ( goal_distance(_actor.target)*_actor.max_force ) / 375 // 375 é a distancia maxima que a bola vai
	var req_time = req_force * 2;
	
	if (_actor.timer_to_shoot >= random_range(req_force - 1, req_force + 5) && _actor.current_shoot_state != SHOOT_STATE.SHOT) {
		_actor.current_shoot_state = SHOOT_STATE.SHOT;
		_actor.timer_to_shoot = 0;
	}
}

function shoot(_actor) {
	_actor.decision = "Chutando";
	if(_actor.current_shoot_state == SHOOT_STATE.SHOOTING) {
		_actor.force+=_actor.increment_force;

		if(_actor.force >= _actor.max_force) {
			_actor.force = _actor.max_force;
			_actor.current_shoot_state = SHOOT_STATE.SHOT;
		}
	}
	
	if(_actor.current_shoot_state == SHOOT_STATE.SHOT) {
		global.with_poss = noone;
		oBall.speed = _actor.force;
		oBall.direction = _actor.angle;
		oBall.x_init = oBall.x;
		oBall.y_init = oBall.y;
		
		if (_actor.force >= _actor.max_force*.75)
			oBall.jump = true;

		_actor.force = 0;	
		_actor.current_shoot_state = -1;
	
		_actor.state = _actor.free_state;
	}
}

function pass(_actor) {
	_actor.decision = "Passando";
}

function get_back(_actor) {
	_actor.decision = "Voltando";
}

function go_to_goal(_actor) {
	_actor.decision = "Indo pro gol";
	
	_actor.dx = sign(_actor.target.x - _actor.x);
	_actor.dy = sign(_actor.target.y - _actor.y - random_range(-1, 1));
	
	_actor.free_state();
}