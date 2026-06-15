function angle_delta(_from, _to) {
	return (((_to - _from + 540) mod 360) - 180);
}

function angle_assist(_from, _to, _amount) {
	return _from + angle_delta(_from, _to) * clamp(_amount, 0, 1);
}

function input_direction_or_facing(_actor, _input_x, _input_y) {
	if (_input_x != 0 || _input_y != 0) {
		return point_direction(0, 0, _input_x, _input_y);
	}

	return _actor.angle;
}

function refresh_field_bounds() {
	var _tl = instance_find(oFieldTL, 0);
	var _tr = instance_find(oFieldTR, 0);
	var _bl = instance_find(oFieldBL, 0);
	var _br = instance_find(oFieldBR, 0);

	if (_tl == noone || _tr == noone || _bl == noone || _br == noone) {
		var _missing_fields = !variable_global_exists("field_left") || !variable_global_exists("field_top") || !variable_global_exists("field_right") || !variable_global_exists("field_bottom");
		var _invalid_fields = false;

		if (!_missing_fields) {
			_invalid_fields = global.field_right <= global.field_left || global.field_bottom <= global.field_top;
		}

		if (_missing_fields || _invalid_fields) {
			global.field_left = 0;
			global.field_top = 0;
			global.field_right = room_width;
			global.field_bottom = room_height;
			global.field_middle = room_width * 0.5;
		}

		global.field_tl_x = global.field_left;
		global.field_tl_y = global.field_top;
		global.field_tr_x = global.field_right;
		global.field_tr_y = global.field_top;
		global.field_bl_x = global.field_left;
		global.field_bl_y = global.field_bottom;
		global.field_br_x = global.field_right;
		global.field_br_y = global.field_bottom;
		global.field_center_y = (global.field_top + global.field_bottom) * 0.5;
		global.field_m_l = 0;
		global.field_m_r = 0;
		global.field_b_l = global.field_top;
		global.field_b_r = global.field_top;

		return false;
	}

	global.field_tl_x = _tl.x;
	global.field_tl_y = _tl.y;
	global.field_tr_x = _tr.x;
	global.field_tr_y = _tr.y;
	global.field_bl_x = _bl.x;
	global.field_bl_y = _bl.y;
	global.field_br_x = _br.x;
	global.field_br_y = _br.y;

	global.field_left = min(_tl.x, _bl.x);
	global.field_top = min(_tl.y, _tr.y);
	global.field_right = max(_tr.x, _br.x);
	global.field_bottom = max(_bl.y, _br.y);
	global.field_middle = (global.field_left + global.field_right) * 0.5;
	global.field_center_y = (global.field_top + global.field_bottom) * 0.5;

	global.field_m_l = (_bl.x != _tl.x) ? ((_bl.y - _tl.y) / (_bl.x - _tl.x)) : 0;
	global.field_m_r = (_br.x != _tr.x) ? ((_br.y - _tr.y) / (_br.x - _tr.x)) : 0;
	global.field_b_l = _tl.y - global.field_m_l * _tl.x;
	global.field_b_r = _tr.y - global.field_m_r * _tr.x;

	return true;
}

function field_side_x_at_y(_top_x, _top_y, _bottom_x, _bottom_y, _m, _b, _y) {
	if (abs(_m) > 0.0001) {
		return (_y - _b) / _m;
	}

	var _height = _bottom_y - _top_y;
	if (abs(_height) <= 0.0001) return _top_x;

	var _t = clamp((_y - _top_y) / _height, 0, 1);
	return lerp(_top_x, _bottom_x, _t);
}

function field_left_at_y(_y) {
	refresh_field_bounds();
	return field_side_x_at_y(global.field_tl_x, global.field_tl_y, global.field_bl_x, global.field_bl_y, global.field_m_l, global.field_b_l, _y);
}

function field_right_at_y(_y) {
	refresh_field_bounds();
	return field_side_x_at_y(global.field_tr_x, global.field_tr_y, global.field_br_x, global.field_br_y, global.field_m_r, global.field_b_r, _y);
}

function clamp_to_field_point(_x, _y, _side_margin = 4, _top_margin = 8, _bottom_margin = 0) {
	refresh_field_bounds();

	var _top = global.field_top + _top_margin;
	var _bottom = global.field_bottom - _bottom_margin;
	var _cy = clamp(_y, _top, _bottom);
	var _left = field_left_at_y(_cy) + _side_margin;
	var _right = field_right_at_y(_cy) - _side_margin;

	if (_left > _right) {
		var _middle = (_left + _right) * 0.5;
		_left = _middle;
		_right = _middle;
	}

	return {
		x: clamp(_x, _left, _right),
		y: _cy
	};
}

function clamp_to_field_x(_x, _y = undefined, _side_margin = 4) {
	refresh_field_bounds();

	var _sample_y = is_undefined(_y) ? global.field_center_y : _y;
	return clamp(_x, field_left_at_y(_sample_y) + _side_margin, field_right_at_y(_sample_y) - _side_margin);
}

function clamp_to_field_y(_y, _top_margin = 8, _bottom_margin = 0) {
	refresh_field_bounds();
	return clamp(_y, global.field_top + _top_margin, global.field_bottom - _bottom_margin);
}

function field_point_inside(_x, _y, _side_margin = 0, _top_margin = 0, _bottom_margin = 0) {
	refresh_field_bounds();

	if (_y < global.field_top + _top_margin || _y > global.field_bottom - _bottom_margin) {
		return false;
	}

	return _x >= field_left_at_y(_y) + _side_margin && _x <= field_right_at_y(_y) - _side_margin;
}

function project_velocity_to_line(_vx, _vy, _x1, _y1, _x2, _y2) {
	var _tx = _x2 - _x1;
	var _ty = _y2 - _y1;
	var _len_sq = _tx * _tx + _ty * _ty;

	if (_len_sq <= 0) {
		return { hspd: 0, vspd: 0 };
	}

	var _amount = (_vx * _tx + _vy * _ty) / _len_sq;
	return {
		hspd: _tx * _amount,
		vspd: _ty * _amount
	};
}

function constrain_field_motion(_x, _y, _hspd, _vspd, _dt, _side_margin = 4, _top_margin = 8, _bottom_margin = 0) {
	refresh_field_bounds();

	var _next_x = _x + _hspd * _dt;
	var _next_y = _y + _vspd * _dt;
	var _top = global.field_top + _top_margin;
	var _bottom = global.field_bottom - _bottom_margin;

	if (_next_y < _top) {
		_next_y = _top;
		if (_vspd < 0) _vspd = 0;
	} else if (_next_y > _bottom) {
		_next_y = _bottom;
		if (_vspd > 0) _vspd = 0;
	}

	var _left = field_left_at_y(_next_y) + _side_margin;
	var _right = field_right_at_y(_next_y) - _side_margin;

	if (_left > _right) {
		var _middle = (_left + _right) * 0.5;
		_left = _middle;
		_right = _middle;
	}

	if (_next_x < _left) {
		_next_x = _left;
		var _slide_l = project_velocity_to_line(_hspd, _vspd, global.field_tl_x + _side_margin, global.field_tl_y, global.field_bl_x + _side_margin, global.field_bl_y);
		_hspd = _slide_l.hspd;
		_vspd = _slide_l.vspd;
	} else if (_next_x > _right) {
		_next_x = _right;
		var _slide_r = project_velocity_to_line(_hspd, _vspd, global.field_tr_x - _side_margin, global.field_tr_y, global.field_br_x - _side_margin, global.field_br_y);
		_hspd = _slide_r.hspd;
		_vspd = _slide_r.vspd;
	}

	var _point = clamp_to_field_point(_next_x, _next_y, _side_margin, _top_margin, _bottom_margin);
	return {
		x: _point.x,
		y: _point.y,
		hspd: _hspd,
		vspd: _vspd
	};
}

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

	var _field_motion = constrain_field_motion(x, y, hspd, vspd, global.dt);
	x = _field_motion.x;
	y = _field_motion.y;
	hspd = _field_motion.hspd;
	vspd = _field_motion.vspd;

	if (abs(hspd) <= .1 && abs(vspd) <= .1) {
		sprite_index = sprPlayerIdleSide;
	} else {
		sprite_index = sprPlayerSide;
	}

	if (abs(dx) > 0.05) {
		image_xscale = sign(dx);
	}
}

function move_actor_towards(_actor, _target_x, _target_y, _margin = 6) {
	with (_actor) {
		var _dist = point_distance(x, y, _target_x, _target_y);

		if (_dist > _margin) {
			dx = (_target_x - x) / _dist;
			dy = (_target_y - y) / _dist;
		} else {
			dx = 0;
			dy = 0;
		}

		player_move();
	}
}

function refresh_player_targets(_actor) {
	with (oBar) {
		if (team != _actor.my_team) {
			_actor.target = id;
		} else {
			_actor.my_goal = id;
		}
	}

	if (_actor.target != noone && _actor.my_goal != noone) {
		_actor.field_side = actor_attack_dir(_actor);
		refresh_player_role(_actor);
	}
}

function update_player_timers(_actor) {
	with (_actor) {
		if (tackle_cooldown > 0) tackle_cooldown = max(tackle_cooldown - global.dt, 0);
		if (ai_intent_timer > 0) ai_intent_timer = max(ai_intent_timer - global.dt, 0);
		if (pass_cooldown > 0) pass_cooldown = max(pass_cooldown - global.dt, 0);
		if (receive_lock_timer > 0) receive_lock_timer = max(receive_lock_timer - global.dt, 0);
		if (possession_grace_timer > 0) possession_grace_timer = max(possession_grace_timer - global.dt, 0);
		if (ai_pass_patience > 0) ai_pass_patience = max(ai_pass_patience - global.dt, 0);

		if (has_ball) {
			ball_hold_timer += global.dt;
		} else {
			ball_hold_timer = 0;
		}
	}
}

function set_ball_owner(_actor) {
	if (_actor == noone || !instance_exists(_actor)) return;

	var _last_owner = oBall.last_owner;
	var _was_intended_receiver = (oBall.intended_receiver != noone && oBall.intended_receiver == _actor);
	var _same_team_pass = (_last_owner != noone && instance_exists(_last_owner) && _last_owner.my_team == _actor.my_team);

	with (oEntity) {
		if (has_ball && id != _actor) {
			has_ball = false;
		}
	}

	with (_actor) {
		has_ball = true;
		force = 0;
		current_shoot_state = -1;
		set_alarm = false;
		possession_grace_timer = (my_team == global.team_home) ? 42 : 20;

		if (_was_intended_receiver && _same_team_pass) {
			// Evita a devolucao automatica que virava tabelinha infinita.
			receive_lock_timer = 34;
			pass_cooldown = max(pass_cooldown, 48);
			ai_pass_patience = 28 + irandom(10);
			ai_intent_timer = 0;
		}
	}

	with (oBall) {
		owner = _actor;
		speed = 0;
		jump = false;
		z = 0;
		zspd = 0;

		if (!_same_team_pass) {
			pass_chain_team = _actor.my_team;
			pass_chain_count = 0;
		}

		intended_receiver = noone;
		pass_assist_timer = 0;
		pickup_lock_timer = 0;
		state = ball_in_posse_state;
	}

	global.with_poss = _actor;
}

function release_ball(_actor, _kick_force, _kick_dir, _jump = false) {
	if (_actor == noone || !instance_exists(_actor)) return;

	audio_play_sound(sndBallKick, 1, 0, 1, 0, random_range(0.95, 1.05));

	with (_actor) {
		has_ball = false;
		force = 0;
		current_shoot_state = SHOOT_STATE.FREEZE;
		set_alarm = false;
		angle = _kick_dir;
		state = free_state;
	}

	with (oBall) {
		owner = noone;
		speed = max(_kick_force, 0);
		direction = _kick_dir;
		jump = _jump;
		last_owner = _actor;
		pickup_lock_timer = 7;
		x_init = x;
		y_init = y;
		state = free_ball_state;
	}

	global.with_poss = noone;
}

function shot(_actor = self) {
	var _jump = _actor.force >= _actor.max_force * 0.75;
	release_ball(_actor, _actor.force, _actor.angle, _jump);
}

function kick_ball_to_point(_actor, _target_x, _target_y, _kick_force, _jump = false) {
	if (!_actor.has_ball) return;

	var _dir = point_direction(_actor.x, _actor.y, _target_x, _target_y);
	_actor.angle = _dir;
	_actor.force = _kick_force;
	release_ball(_actor, _kick_force, _dir, _jump);
}

function pass_force_for_distance(_distance) {
	return clamp(_distance * oBall.fric * 0.98 + 1.1, 4.8, 15.5);
}

function pass_to_teammate(_actor, _receiver, _raw_dir = undefined, _assist = 0.72) {
	if (_receiver == noone || !instance_exists(_receiver) || !_actor.has_ball) return false;

	var _distance = point_distance(_actor.x, _actor.y, _receiver.x, _receiver.y);
	var _lead_time = clamp(_distance / 18, 2, 7);
	var _target_pos = clamp_to_field_point(_receiver.x + _receiver.hspd * _lead_time, _receiver.y + _receiver.vspd * _lead_time);
	var _target_x = _target_pos.x;
	var _target_y = _target_pos.y;
	var _target_dir = point_direction(_actor.x, _actor.y, _target_x, _target_y);
	var _pass_dir = _target_dir;

	if (!is_undefined(_raw_dir)) {
		_pass_dir = angle_assist(_raw_dir, _target_dir, _assist);
	}

	with (_actor) {
		decision = "Passe para " + _receiver.role_label;
		last_pass_target = _receiver;
		pass_cooldown = 44;
		ai_pass_patience = 36;
	}

	with (oBall) {
		intended_receiver = _receiver;
		pass_team = _actor.my_team;
		pass_assist_timer = 34;
		pass_target_x = _target_x;
		pass_target_y = _target_y;

		if (pass_chain_team == _actor.my_team) {
			pass_chain_count++;
		} else {
			pass_chain_team = _actor.my_team;
			pass_chain_count = 1;
		}
	}

	release_ball(_actor, pass_force_for_distance(_distance), _pass_dir, false);
	return true;
}

function pass(_actor) {
	var _target = best_open_pass_target(_actor.teamplayer_obj, _actor.opponent_team_obj, _actor);
	if (_target.teamplayer == noone) {
		_target = nearest_teamplayer(_actor.teamplayer_obj, _actor);
	}

	if (_target.teamplayer != noone) {
		return pass_to_teammate(_actor, _target.teamplayer);
	}

	return false;
}

function increment_shoot_force(_actor) {
	if (_actor.current_shoot_state == SHOOT_STATE.SHOOTING) {
		_actor.force += _actor.increment_force * global.dt;

		if (_actor.force >= _actor.max_force) {
			_actor.force = _actor.max_force;
		}
	}
}

function player_pass_with_assist(_actor, _raw_dir) {
	var _target = best_player_pass_target(_actor, _raw_dir);

	if (_target.teamplayer != noone) {
		return pass_to_teammate(_actor, _target.teamplayer, _raw_dir, global.pass_assist_strength);
	}

	release_ball(_actor, 9, _raw_dir, false);
	return true;
}

function player_shoot_with_assist(_actor, _raw_dir) {
	var _shot = shot_score(_actor);
	var _shoot_dir = _raw_dir;
	var _force = clamp(_actor.force, 10, _actor.max_force);

	if (_shot.can || abs(angle_delta(_raw_dir, point_direction(_actor.x, _actor.y, _shot.target_x, _shot.target_y))) < 58) {
		var _target_dir = point_direction(_actor.x, _actor.y, _shot.target_x, _shot.target_y);
		_shoot_dir = angle_assist(_raw_dir, _target_dir, global.shoot_assist_strength);
	}

	release_ball(_actor, _force, _shoot_dir, _force >= _actor.max_force * 0.72);
}

function start_tackle(_actor, _dir) {
	if (_actor == noone || !instance_exists(_actor)) return false;
	if (_actor.tackle_cooldown > 0 || _actor.is_tackling || _actor.has_ball) return false;

	with (_actor) {
		is_tackling = true;
		tackle_timer = 14;
		tackle_cooldown = 66 + irandom(22);
		tackle_dir = _dir;
		tackle_hit_done = false;
		angle = _dir;
		decision = "Carrinho";
		dx = lengthdir_x(1, _dir);
		dy = lengthdir_y(1, _dir);
		
		sprite_index = sprPlayerTackle;
	}

	return true;
}

function finish_tackle_if_hit(_actor) {
	if (_actor.tackle_hit_done) return;

	var _holder = global.with_poss;
	if (_holder != noone && instance_exists(_holder) && _holder.my_team != _actor.my_team) {
		var _dist_holder = point_distance(_actor.x, _actor.y, _holder.x, _holder.y);

		if (_dist_holder <= 17) {
			with (_holder) {
				has_ball = false;
				current_shoot_state = -1;
				force = 0;
			}

			set_ball_owner(_actor);
			_actor.tackle_hit_done = true;
			_actor.tackle_timer = min(_actor.tackle_timer, 5);
			return;
		}
	}

	if (ball_is_free() && point_distance(_actor.x, _actor.y, oBall.x, oBall.y) <= 18) {
		set_ball_owner(_actor);
		_actor.tackle_hit_done = true;
		_actor.tackle_timer = min(_actor.tackle_timer, 5);
	}
}

function update_tackle_motion(_actor) {
	with (_actor) {
		var _speed = max_spd * 1.75;
		var _motion = constrain_field_motion(x, y, lengthdir_x(_speed, tackle_dir), lengthdir_y(_speed, tackle_dir), global.dt);
		x = _motion.x;
		y = _motion.y;

		hspd = _motion.hspd * (0.75 / 1.75);
		vspd = _motion.vspd * (0.75 / 1.75);
		sprite_index = sprPlayerSide;

		if (abs(lengthdir_x(1, tackle_dir)) > 0.05) {
			image_xscale = sign(lengthdir_x(1, tackle_dir));
		}

		finish_tackle_if_hit(id);
		tackle_timer -= global.dt;

		if (tackle_timer <= 0) {
			is_tackling = false;
			tackle_timer = 0;
			hspd *= 0.35;
			vspd *= 0.35;
		}
	}
}

function receive_pass_position(_actor) {
	if (oBall.owner != noone) return false;
	if (oBall.intended_receiver != _actor) return false;
	if (oBall.pass_assist_timer <= 0) return false;
	if (global.player_controlling == _actor) return false;

	_actor.decision = "Recebendo passe";
	move_actor_towards(_actor, oBall.pass_target_x, oBall.pass_target_y, 5);
	return true;
}

function freeze(_actor) {
	with (_actor) {
		sprite_index = sprPlayerIdleSide;
		var _freeze_pos = clamp_to_field_point(x + .45 * -image_xscale, y);
		x = _freeze_pos.x;
		y = _freeze_pos.y;

		if (!set_alarm) {
			// Pausa curta para o chute ter peso sem travar demais o arcade.
			alarm[0] = max(round(game_get_speed(gamespeed_fps) * 0.16), 4);
			force = 0;
			set_alarm = true;
		}
	}
}

function shape_target_for_actor(_actor) {
	var _dir = actor_attack_dir(_actor);
	var _target_x = _actor.initial_x;
	var _target_y = _actor.initial_y;
	var _ball_influence = 0.18;
	var _push = 0;

	if (_actor.player_role == PLAYER_ROLE.DEFENDER) {
		_ball_influence = 0.14;
		_push = is_team_with_pos() ? 18 : -22;
	} else if (_actor.player_role == PLAYER_ROLE.MIDFIELDER) {
		_ball_influence = 0.28;
		_push = is_team_with_pos() ? 42 : -6;
	} else {
		_ball_influence = 0.24;
		_push = is_team_with_pos() ? 62 : 12;
	}

	if (ball_is_free()) {
		_push *= 0.35;
		_ball_influence += 0.08;
	}

	_target_x += _push * _dir;
	_target_y = lerp(_target_y, oBall.y, _ball_influence);

	var _target_pos = clamp_to_field_point(_target_x, _target_y);
	return {
		target_x: _target_pos.x,
		target_y: _target_pos.y
	};
}

function go_to_position(_actor) {
	with (_actor) {
		decision = role_label + " em bloco";
		mark_target = noone;
	}

	var _shape = shape_target_for_actor(_actor);
	move_actor_towards(_actor, _shape.target_x, _shape.target_y, 8);
}

function go_to_ball(_actor) {
	with (_actor) {
		decision = "Bola livre";
		mark_target = noone;
	}

	move_actor_towards(_actor, oBall.x, oBall.y, 5);
}

function support_attack(_actor) {
	var _space = find_support_space(_actor);

	with (_actor) {
		decision = role_label + " apoiando";
		mark_target = noone;
		pos_target_x = _space.target_x;
		pos_target_y = _space.target_y;
	}

	move_actor_towards(_actor, _space.target_x, _space.target_y, 9);
}

function mark_free_opponent(_actor) {
	var _target = find_mark_target(_actor);
	_actor.mark_target = _target;

	if (_target == noone || !instance_exists(_target)) {
		go_to_position(_actor);
		return;
	}

	var _target_x = _target.x;
	var _target_y = _target.y;

	if (_actor.my_goal != noone) {
		var _cover_dir = point_direction(_target.x, _target.y, _actor.my_goal.x, _actor.my_goal.y);
		var _cover_dist = (_actor.player_role == PLAYER_ROLE.DEFENDER) ? 34 : 25;
		_target_x += lengthdir_x(_cover_dist, _cover_dir);
		_target_y += lengthdir_y(_cover_dist, _cover_dir);
	}

	var _shape = shape_target_for_actor(_actor);
	_target_x = lerp(_target_x, _shape.target_x, 0.18);
	_target_y = lerp(_target_y, _shape.target_y, 0.18);

	_actor.decision = "Marcando " + _target.role_label;
	move_actor_towards(_actor, _target_x, _target_y, 10);
}

function press_opponent(_actor) {
	var _holder = global.with_poss;
	if (_holder == noone || !instance_exists(_holder)) {
		go_to_position(_actor);
		return;
	}

	if (_actor.ai_intent_timer <= 5 && bot_should_tackle(_actor)) {
		start_tackle(_actor, point_direction(_actor.x, _actor.y, _holder.x, _holder.y));
		return;
	}

	var _goal_dir = point_direction(_holder.x, _holder.y, _actor.my_goal.x, _actor.my_goal.y);
	var _contain_dist = (_actor.player_role == PLAYER_ROLE.DEFENDER) ? 32 : 25;
	var _target_x = _holder.x + lengthdir_x(_contain_dist, _goal_dir);
	var _target_y = _holder.y + lengthdir_y(_contain_dist, _goal_dir);

	_actor.decision = "Cercando";
	move_actor_towards(_actor, _target_x, _target_y, 6);
}

function dribble_with_ball(_actor) {
	var _dir = actor_attack_dir(_actor);
	var _near = nearest_opponent(_actor);
	var _forward = 50;
	var _lane = sign(_actor.initial_y - oBall.y);
	if (_lane == 0) _lane = choose(-1, 1);

	if (_actor.player_role == PLAYER_ROLE.ATTACKER) _forward = 70;
	if (_actor.player_role == PLAYER_ROLE.DEFENDER) _forward = 34;

	var _target_x = _actor.x + _forward * _dir;
	var _target_y = lerp(_actor.y, _actor.initial_y + _lane * 34, 0.55);

	if (_near.opponent != noone && _near.distance < 42) {
		var _away = point_direction(_near.opponent.x, _near.opponent.y, _actor.x, _actor.y);
		_target_x += lengthdir_x(22, _away);
		_target_y += lengthdir_y(34, _away);
	}

	_actor.decision = role_name(_actor.player_role) + " conduzindo";
	oBall.pass_chain_count = 0;
	var _target_pos = clamp_to_field_point(_target_x, _target_y);
	move_actor_towards(_actor, _target_pos.x, _target_pos.y, 6);
}

function ai_shoot(_actor) {
	var _shot = shot_score(_actor);
	var _dist = point_distance(_actor.x, _actor.y, _shot.target_x, _shot.target_y);
	var _force = clamp(_dist * oBall.fric * 1.28 + 4 + random_range(-1, 1), 11, _actor.max_force);

	_actor.decision = "Finalizando";
	kick_ball_to_point(_actor, _shot.target_x, _shot.target_y, _force, _force > _actor.max_force * 0.72);
}

function choose_ai_context(_actor) {
	if (_actor.has_ball) return "with_ball";
	if (ball_is_free()) return "free_ball";
	if (is_team_with_pos()) return "team_ball";
	return "defense";
}

function commit_ai_intent(_actor, _intent, _frames) {
	_actor.ai_intent = _intent;
	_actor.ai_intent_timer = _frames + irandom(6);
	_actor.ai_decision_noise = random(1);
}

function choose_ai_with_ball(_actor) {
	var _pressure = nearest_opponent_distance_at(_actor.x, _actor.y, _actor.opponent_team_obj);
	var _pass_target = best_open_pass_target(_actor.teamplayer_obj, _actor.opponent_team_obj, _actor);
	var _shot = shot_score(_actor);
	var _pass_bias = 0;
	var _min_hold = 26;

	if (_actor.player_role == PLAYER_ROLE.DEFENDER) _pass_bias += 18;
	if (_actor.player_role == PLAYER_ROLE.MIDFIELDER) _pass_bias += 8;
	if (_pressure < 30) _pass_bias += 34;
	if (_actor.ball_hold_timer > 72) _pass_bias += 18;
	if (_actor.player_role == PLAYER_ROLE.ATTACKER) _pass_bias -= 26;
	if (oBall.pass_chain_count >= 2) _pass_bias -= 58;

	if (_actor.receive_lock_timer > 0 || _actor.ai_pass_patience > 0 || _actor.ball_hold_timer < _min_hold) {
		if (_shot.can && _actor.player_role == PLAYER_ROLE.ATTACKER && _shot.score > 70) {
			commit_ai_intent(_actor, AI_INTENT.SHOOT, 12);
			return;
		}

		commit_ai_intent(_actor, AI_INTENT.DRIBBLE, 26);
		return;
	}

	if (_pass_target.teamplayer != noone && _pass_target.score + _pass_bias > _shot.score + 26 && _actor.pass_cooldown <= 0 && _pass_target.score > 72) {
		commit_ai_intent(_actor, AI_INTENT.PASS, 16);
		return;
	}

	var _shoot_bias = (_actor.player_role == PLAYER_ROLE.ATTACKER) ? 24 : 0;
	if (_actor.player_role == PLAYER_ROLE.DEFENDER) _shoot_bias -= 35;

	if (_shot.can && _shot.score + _shoot_bias + random_range(-8, 12) > 50) {
		commit_ai_intent(_actor, AI_INTENT.SHOOT, 14);
		return;
	}

	commit_ai_intent(_actor, AI_INTENT.DRIBBLE, 28);
}

function choose_ai_without_ball(_actor) {
	if (ball_is_free()) {
		if (am_i_closest_to_ball(_actor)) {
			commit_ai_intent(_actor, AI_INTENT.CHASE_BALL, 12);
		} else if (should_support_attack(_actor)) {
			commit_ai_intent(_actor, AI_INTENT.SUPPORT, 18);
		} else {
			commit_ai_intent(_actor, AI_INTENT.HOLD, 22);
		}

		return;
	}

	if (is_team_with_pos()) {
		if (should_support_attack(_actor)) {
			commit_ai_intent(_actor, AI_INTENT.SUPPORT, 20);
		} else {
			commit_ai_intent(_actor, AI_INTENT.HOLD, 26);
		}

		return;
	}

	var _holder = global.with_poss;

	if (bot_should_tackle(_actor)) {
		commit_ai_intent(_actor, AI_INTENT.TACKLE, 8);
	} else if (should_press_holder(_actor, _holder)) {
		commit_ai_intent(_actor, AI_INTENT.PRESS, 18);
	} else if (_actor.player_role == PLAYER_ROLE.ATTACKER) {
		commit_ai_intent(_actor, AI_INTENT.TRACK, 24);
	} else {
		commit_ai_intent(_actor, AI_INTENT.MARK, 24);
	}
}

function execute_ai_intent(_actor) {
	switch (_actor.ai_intent) {
		case AI_INTENT.CHASE_BALL:
			go_to_ball(_actor);
			break;

		case AI_INTENT.SUPPORT:
			support_attack(_actor);
			break;

		case AI_INTENT.MARK:
		case AI_INTENT.TRACK:
			mark_free_opponent(_actor);
			break;

		case AI_INTENT.PRESS:
			press_opponent(_actor);
			break;

		case AI_INTENT.TACKLE:
			if (!start_tackle(_actor, point_direction(_actor.x, _actor.y, oBall.x, oBall.y))) {
				press_opponent(_actor);
			}
			break;

		case AI_INTENT.DRIBBLE:
			dribble_with_ball(_actor);
			break;

		case AI_INTENT.PASS:
			if (!pass(_actor)) {
				dribble_with_ball(_actor);
			}
			break;

		case AI_INTENT.SHOOT:
			ai_shoot(_actor);
			break;

		default:
			go_to_position(_actor);
			break;
	}
}

function ai_update(_actor) {
	if (is_freeze()) {
		freeze(_actor);
		return;
	}

	if (receive_pass_position(_actor)) {
		return;
	}

	var _context = choose_ai_context(_actor);
	if (_context != _actor.ai_context) {
		_actor.ai_context = _context;
		_actor.ai_intent_timer = 0;
	}

	if (_actor.ai_intent_timer <= 0) {
		if (_actor.has_ball) {
			choose_ai_with_ball(_actor);
		} else {
			choose_ai_without_ball(_actor);
		}
	}

	execute_ai_intent(_actor);
}

function ball_bounce_from_frame(_normal_dir, _power = 0.68) {
	direction = _normal_dir + angle_delta(_normal_dir, direction + 180) * 0.35;
	speed *= _power;

	if (abs(z) > 2) {
		zspd = min(zspd, 0) * -0.45;
	}

	intended_receiver = noone;
	pass_assist_timer = 0;
	pass_chain_count = 0;
}

function ball_reflect_from_wall(_x1, _y1, _x2, _y2, _power) {
	var _vx = lengthdir_x(speed, direction);
	var _vy = lengthdir_y(speed, direction);
	var _tx = _x2 - _x1;
	var _ty = _y2 - _y1;
	var _len_sq = _tx * _tx + _ty * _ty;

	if (_len_sq <= 0) {
		speed = 0;
		return;
	}

	var _dot = (_vx * _tx + _vy * _ty) / _len_sq;
	var _slide_x = _tx * _dot;
	var _slide_y = _ty * _dot;
	var _normal_x = _vx - _slide_x;
	var _normal_y = _vy - _slide_y;
	var _bounce_x = _slide_x - _normal_x * _power;
	var _bounce_y = _slide_y - _normal_y * _power;

	speed = point_distance(0, 0, _bounce_x, _bounce_y);
	if (speed > 0) {
		direction = point_direction(0, 0, _bounce_x, _bounce_y);
	}
}

function is_goal(_side, _y) {
	var _is_goal = false;
	var _ball = id; // Garante a referência correta à bola

    with (oBar) {
        if (instance_exists(top_post) && instance_exists(bottom_post)) {  
            // 1. A bola está passando "entre" eles no eixo Y?
            var upper_y_limit = min(top_post.y, bottom_post.y);
            var lower_y_limit = max(top_post.y, bottom_post.y);
    
            if (_y >= upper_y_limit && _y <= lower_y_limit) {
                
                var _left_goal = x < global.field_middle;
                var _same_side = (_side == "left" && _left_goal) || (_side == "right" && !_left_goal);            
                
                // Só processa se estivermos olhando para a trave correta daquele lado
                if (_same_side) {
                    var A = bottom_post.y - top_post.y;
                    var B = top_post.x - bottom_post.x;
                    var C = (bottom_post.x * top_post.y) - (top_post.x * bottom_post.y);
            
                    var corner_upper_l = sign(A * _ball.bbox_left + B * _ball.bbox_top + C);
                    var corner_upper_r = sign(A * _ball.bbox_right + B * _ball.bbox_top + C);
                    var corner_lower_l = sign(A * _ball.bbox_left + B * _ball.bbox_bottom + C);
                    var corner_lower_r = sign(A * _ball.bbox_right + B * _ball.bbox_bottom + C);
                    
                    var goal_side = _side == "left" ? -1 : 1;

                    // Condição 2: Atravessou totalmente a linha?
                    if (corner_upper_l == corner_upper_r && corner_upper_r == corner_lower_l && corner_lower_l == corner_lower_r) {
                        if (corner_upper_l == goal_side) {
                            _is_goal = true;
                        }
                    }
                }
            }
        }   
    }
	
	return _is_goal;
}

function ball_inside_goal_mouth(_side, _y, _x) {
	var _inside = false;
    var net_depth = 21;

    with (oBar) {
        if (instance_exists(top_post) && instance_exists(bottom_post)) {
            var _left_goal = x < global.field_middle;
            var _same_side = (_side == "left" && _left_goal) || (_side == "right" && !_left_goal);
			var _ball = id;

            if (_same_side) {
                var upper_y_limit = top_post.y;
                var lower_y_limit = bottom_post.y;
                var goal_line_x = top_post.x;

                var _y_ok = (_y >= upper_y_limit && _y <= lower_y_limit);

                var _x_ok;
                if (_side == "left") {
                    // entre a linha de gol e o fundo da rede (com uma margem de tolerância)
                    _x_ok = (_x <= goal_line_x + 4) && (_x >= goal_line_x - net_depth - 4);
                } else if (_side == "right") {
                    _x_ok = (_x >= goal_line_x - 4) && (_x <= goal_line_x + net_depth + 4);
                }

                if (_y_ok && _x_ok) {		
                    _inside = true;
                }
            }
        }
    }

    return _inside;
}

function ball_hit_field_wall(_from_x, _from_y) {
	refresh_field_bounds();

	var _wall_height_z = variable_instance_exists(id, "wall_height_z") ? wall_height_z : -8;
	var _wall_margin = variable_instance_exists(id, "wall_margin") ? wall_margin : 0;

	if (owner != noone) {
		var _held_pos = clamp_to_field_point(x, y, _wall_margin, 0, 0);
		x = _held_pos.x;
		y = _held_pos.y;
		return;
	}

	if (z <= _wall_height_z) return;
	if (field_point_inside(x, y, _wall_margin, 0, 0)) return;

	var _side = "";
	var _top = global.field_top;
	var _bottom = global.field_bottom;

	if (y < _top) {
		_side = "top";
	} else if (y > _bottom) {
		_side = "bottom";
	} else if (x < field_left_at_y(y) + _wall_margin) {
		_side = "left";
	} else if (x > field_right_at_y(y) - _wall_margin) {
		_side = "right";
	}
	
	if (goal_in_net(_side, y, x)) return;

	if (!field_point_inside(_from_x, _from_y, _wall_margin, 0, 0)) return;
    
	var _hit_pos = clamp_to_field_point(x, y, _wall_margin, 0, 0);
	x = _hit_pos.x;
	y = _hit_pos.y;

	var _stop_speed = variable_instance_exists(id, "wall_stop_speed") ? wall_stop_speed : 1.15;
	var _bounce_power = variable_instance_exists(id, "wall_bounce_power") ? wall_bounce_power : 0.62;

	intended_receiver = noone;
	pass_assist_timer = 0;
	pass_chain_count = 0;

	if (speed <= _stop_speed || _side == "") {
		speed = 0;
		return;
	}

	switch (_side) {
		case "top":
			ball_reflect_from_wall(global.field_tl_x, global.field_tl_y, global.field_tr_x, global.field_tr_y, _bounce_power);
			break;

		case "bottom":
			ball_reflect_from_wall(global.field_bl_x, global.field_bl_y, global.field_br_x, global.field_br_y, _bounce_power);
			break;

		case "left":
			ball_reflect_from_wall(global.field_tl_x, global.field_tl_y, global.field_bl_x, global.field_bl_y, _bounce_power);
			break;

		case "right":
			ball_reflect_from_wall(global.field_tr_x, global.field_tr_y, global.field_br_x, global.field_br_y, _bounce_power);
			break;
	}

	if (speed <= _stop_speed) {
		speed = 0;
	}
}

function goal_in_net(_side, _y, _x) {
	var inside_goal = ball_inside_goal_mouth(_side, _y, _x);
	if (inside_goal) {
	    // --- A BOLA ENTROU NO GOL: FÍSICA DA REDE ---
	    var net_depth = 21;   // Profundidade do fundo da rede (Ajuste para o visual do seu jogo)
	    var net_bounce = 0.2; // Rede absorve a energia do chute (0.0 a 1.0)

	    with (oBar) {
	        var _left_goal = x < global.field_middle;
	        var _same_side = (_side == "left" && _left_goal) || (_side == "right" && !_left_goal);

	        if (_same_side && instance_exists(top_post)) {
	            var upper_y_limit = top_post.y;
	            var lower_y_limit = bottom_post.y;
	            var goal_line_x = top_post.x; 
				
	            // 1. Colisão com o Fundo da Rede (Eixo X)
	            if (_side == "left") {
	                var back_net_x = goal_line_x - net_depth;
	                if (_x < back_net_x) {
						audio_play_sound(sndGoalNet, 1, 0);
	                    other.x = back_net_x;
	                    other.speed *= -net_bounce; // Inverte e amortece
	                }
					
					if (global.match_state != MATCH_STATE.GOAL) {
						global.scores[1]++;
					}
	            } else if (_side == "right") {
	                var back_net_x = goal_line_x + net_depth;
	                if (_x > back_net_x) {
						audio_play_sound(sndGoalNet, 1, 0);
	                    other.x = back_net_x;	
	                    other.speed *= -net_bounce; // Inverte e amortece
	                }
					
					if (global.match_state != MATCH_STATE.GOAL) {
						global.scores[0]++;
					}
	            }

	            // 2. Colisão com as Laterais da Rede (Eixo Y)
	            // Impede que a bola vaze por "dentro" do gol caso bata na malha lateral
	            if (_y < upper_y_limit) {
					audio_play_sound(sndGoalNet, 1, 0);
	                other.y = upper_y_limit;
					
	                other.speed *= -net_bounce;
	            } else if (_y > lower_y_limit) {
					audio_play_sound(sndGoalNet, 1, 0);
	                other.y = lower_y_limit;
					
	                other.speed *= -net_bounce;
	            }
				
				global.match_state = MATCH_STATE.GOAL;
	        }	
	    }
		
			
	    return true; 
	}
}

function segment_point_distance(_x1, _y1, _x2, _y2, _px, _py) {
	var _seg_x = _x2 - _x1;
	var _seg_y = _y2 - _y1;
	var _len_sq = _seg_x * _seg_x + _seg_y * _seg_y;
	if (_len_sq <= 0) return point_distance(_x1, _y1, _px, _py);

	var _t = ((_px - _x1) * _seg_x + (_py - _y1) * _seg_y) / _len_sq;
	_t = clamp(_t, 0, 1);

	var _cx = lerp(_x1, _x2, _t);
	var _cy = lerp(_y1, _y2, _t);
	return point_distance(_cx, _cy, _px, _py);
}

function goal_frame_collision() {
	if (owner != noone || speed <= 0.4) return;

	var _post_radius = 5.5;
	var _crossbar_radius = 4.5;
	var _goal_height_z = -24;
	var _ball_z = z;

	with (oBar) {
		if (top_post != noone && bottom_post != noone) {
			var _goal_x = x;
			var _top_y = min(top_post.y, bottom_post.y);
			var _bottom_y = max(top_post.y, bottom_post.y);
			var _other = other;

			if (_ball_z >= _goal_height_z) {
				var _top_hit = segment_point_distance(_other.prev_x, _other.prev_y, _other.x, _other.y, top_post.x, top_post.y) <= _post_radius;
				var _bottom_hit = segment_point_distance(_other.prev_x, _other.prev_y, _other.x, _other.y, bottom_post.x, bottom_post.y) <= _post_radius;

				if (_top_hit || _bottom_hit) {
					with (_other) {
						var _hit_x = _top_hit ? other.top_post.x : other.bottom_post.x;
						var _hit_y = _top_hit ? other.top_post.y : other.bottom_post.y;
						x = prev_x;
						y = prev_y;
						audio_play_sound(sndGoalpost, 1, 0);
						ball_bounce_from_frame(point_direction(_hit_x, _hit_y, x, y), 0.58);
					}

					break;
				}
			}

			var _crosses_goal_line = (_other.prev_x - _goal_x) * (_other.x - _goal_x) <= 0 && abs(_other.x - _goal_x) <= 12;
			var _inside_mouth = _other.y >= _top_y && _other.y <= _bottom_y;
			var _at_crossbar_height = abs(_ball_z - _goal_height_z) <= _crossbar_radius;

			if (_crosses_goal_line && _inside_mouth && _at_crossbar_height) {
				with (_other) {
					x = prev_x;
					y = prev_y;
					zspd = abs(zspd) * 0.55;
					ball_bounce_from_frame((other.x < room_width * 0.5) ? 0 : 180, 0.62);
				}

				break;
			}
		}
	}
}

function player_control_update(_actor) {
	if (is_freeze()) {
		freeze(_actor);
		return;
	}

	var _input_x = KEY_RIGHT - KEY_LEFT;
	var _input_y = KEY_DOWN - KEY_UP;
	var _raw_dir = input_direction_or_facing(_actor, _input_x, _input_y);

	with (_actor) {
		dx = _input_x;
		dy = _input_y;

		if (!has_ball && ball_is_free() && dx == 0 && dy == 0) {
			var _dist_ball = point_distance(x, y, oBall.x, oBall.y);
			if (_dist_ball > 5) {
				dx = (oBall.x - x) / _dist_ball;
				dy = (oBall.y - y) / _dist_ball;
				decision = "Auto na bola";
			}
		}

		if (KEY_TACKLE && !has_ball) {
			start_tackle(id, _raw_dir);
		}

		if (!is_tackling) {
			if (has_ball) {
				if (KEY_PASS && pass_cooldown <= 0) {
					player_pass_with_assist(id, _raw_dir);
				} else if (KEY_SHOOT) {
					current_shoot_state = SHOOT_STATE.SHOOTING;
					increment_shoot_force(id);
				} else if (current_shoot_state == SHOOT_STATE.SHOOTING || KEY_SHOOT_RELEASED) {
					player_shoot_with_assist(id, _raw_dir);
				}
			} else {
				current_shoot_state = -1;
				force = 0;
			}

			if (!is_tackling) {
				player_move();
			}
		}
	}
}
