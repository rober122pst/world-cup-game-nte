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
	
	y += vspd * global.dt;
	x += hspd * global.dt;
	
	if (abs(hspd) <= .1 && abs(vspd) <= .1) {
		sprite_index = sprPlayerIdleSide;
	} else {
		sprite_index = sprPlayerSide;	
	}
	
	if (dx != 0)
		image_xscale = dx;

}

function go_to_ball (_actor) {
	_actor.decision = "Indo atras da bola";
	_actor.dx = sign(oBall.x - _actor.x);
	_actor.dy = sign(oBall.y - _actor.y);

	_actor.free_state();
}

function increment_shoot_force(_actor) {
	if(_actor.current_shoot_state == SHOOT_STATE.SHOOTING) {
		_actor.force += _actor.increment_force*global.dt;

		if(_actor.force >= _actor.max_force) {
			_actor.force = _actor.max_force;
			_actor.current_shoot_state = SHOOT_STATE.SHOT;
		}
	}
}

function shooting(_actor) {
	with (_actor) {
		shoot(id);
		show_debug_message(current_shoot_state == SHOOT_STATE.SHOOTING)
		if (current_shoot_state == -1) current_shoot_state = SHOOT_STATE.SHOOTING;
		timer_to_shoot++;
	
		var req_force = ( goal_distance(target).goal_dist*max_force ) / 375 // 375 é a distancia maxima que a bola vai
		var req_time = req_force * 2;

		if (timer_to_shoot >= random_range(req_time - 1, req_time + 5) && current_shoot_state != SHOOT_STATE.SHOT) {			
			current_shoot_state = SHOOT_STATE.SHOT;
			timer_to_shoot = 0;
		}
	}
}

function shoot(_actor) {
	with (_actor) {
		decision = "Chutando";
		if(current_shoot_state == SHOOT_STATE.SHOOTING) {
			force+=increment_force;

			if(force >= max_force) {
				force = max_force;
				current_shoot_state = SHOOT_STATE.SHOT;
			}
		}
	
		if(current_shoot_state == SHOOT_STATE.SHOT) {
			shot();
		}
	}
}

function shot() {
	has_ball = false;
	global.with_poss = noone;
	
	with (oBall) {
		owner = noone;
		speed = other.force;
		direction = other.angle;
		other.x_init = x;
		other.y_init = y;
	}
	
	if (force >= max_force*.75)
		oBall.jump = true;
		
	force = 0;	
	current_shoot_state = -1;
	
	state = free_state;	
}

function pass(_actor) {
	with (_actor) {
		decision = "Passando";
		var nearest = nearest_teamplayer(teamplayer_obj);
		
		current_shoot_state = SHOOT_STATE.SHOT;
		force = ( nearest.distance*max_force ) / 375 // 375 é a distancia maxima que a bola vai
		angle = point_direction(x, y, nearest.teamplayer.x, nearest.teamplayer.y);
		
		shoot(id);	
	}
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