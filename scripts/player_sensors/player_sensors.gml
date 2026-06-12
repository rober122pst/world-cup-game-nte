function goal_distance(_goal) {
	if (_goal == noone || !instance_exists(_goal)) {
		return { angle: 0, goal_dist: 9999 };
	}

	var _goal_post_1 = _goal.top_post;
	var _goal_post_2 = _goal.bottom_post;

	if (_goal_post_1 == noone || _goal_post_2 == noone) {
		return { angle: 0, goal_dist: point_distance(x, y, _goal.x, _goal.y) };
	}

	var _dir_goal_1 = point_direction(x, y, _goal_post_1.x, _goal_post_1.y);
	var _dir_goal_2 = point_direction(x, y, _goal_post_2.x, _goal_post_2.y);
	var _angle = abs(angle_difference(_dir_goal_1, _dir_goal_2));
	var _goal_dist = point_distance(x, y, _goal.x, _goal.y);

	return { angle: _angle, goal_dist: _goal_dist };
}

function actor_attack_dir(_actor) {
	if (_actor.target != noone && _actor.my_goal != noone) {
		return sign(_actor.target.x - _actor.my_goal.x);
	}

	return (_actor.my_team == global.team_home) ? 1 : -1;
}

function actor_progress_to_goal(_actor, _x = undefined) {
	if (_actor.target == noone || _actor.my_goal == noone) return 0.5;

	var _dir = actor_attack_dir(_actor);
	var _sample_x = is_undefined(_x) ? _actor.x : _x;
	var _span = max(abs(_actor.target.x - _actor.my_goal.x), 1);
	return clamp(((_sample_x - _actor.my_goal.x) * _dir) / _span, 0, 1);
}

function role_name(_role) {
	switch (_role) {
		case PLAYER_ROLE.DEFENDER: return "Defensor";
		case PLAYER_ROLE.ATTACKER: return "Atacante";
	}

	return "Meio";
}

function refresh_player_role(_actor) {
	if (_actor.target == noone || _actor.my_goal == noone) return;

	var _dir = actor_attack_dir(_actor);
	var _my_progress = (_actor.initial_x - _actor.my_goal.x) * _dir;
	var _rank = 0;
	var _team_count = 0;

	with (_actor.teamplayer_obj) {
		_team_count++;

		var _progress = (initial_x - _actor.my_goal.x) * _dir;
		if (_progress < _my_progress || (_progress == _my_progress && id < _actor.id)) {
			_rank++;
		}
	}

	var _defender_count = max(1, floor(_team_count * 0.34));
	var _midfielder_limit = max(_defender_count + 1, floor(_team_count * 0.67));

	if (_rank < _defender_count) {
		_actor.player_role = PLAYER_ROLE.DEFENDER;
	} else if (_rank < _midfielder_limit) {
		_actor.player_role = PLAYER_ROLE.MIDFIELDER;
	} else {
		_actor.player_role = PLAYER_ROLE.ATTACKER;
	}

	_actor.role_label = role_name(_actor.player_role);
}

function is_freeze() {
	return current_shoot_state == SHOOT_STATE.FREEZE;
}

function ball_is_free() {
	return global.with_poss == noone || !instance_exists(global.with_poss);
}

function is_team_with_pos() {
	if (ball_is_free()) return false;
	return global.with_poss.my_team == my_team;
}

function ball_distance() {
	return point_distance(x, y, oBall.x, oBall.y);
}

function enemies_around(_opponent_obj, _radius) {
	var _enemies = ds_list_create();
	var _number = collision_circle_list(x, y, _radius, _opponent_obj, false, true, _enemies, true);
	ds_list_destroy(_enemies);

	return _number;
}

function is_surrounded(_opponent_obj, _radius) {
	return enemies_around(_opponent_obj, _radius) > 2;
}

function nearest_opponent_distance_at(_x, _y, _opponent_obj) {
	var _distance = 9999;

	with (_opponent_obj) {
		var _d = point_distance(x, y, _x, _y);
		if (_d < _distance) {
			_distance = _d;
		}
	}

	return _distance;
}

function nearest_opponent(_actor) {
	var _opponent = noone;
	var _distance = 9999;

	with (_actor.opponent_team_obj) {
		var _d = point_distance(x, y, _actor.x, _actor.y);
		if (_d < _distance) {
			_distance = _d;
			_opponent = id;
		}
	}

	return { opponent: _opponent, distance: _distance };
}

function nearest_teamplayer(_teamplayer_obj, _actor = self) {
	var _teamplayer = noone;
	var _distance = 9999;

	with (_teamplayer_obj) {
		if (id != _actor.id) {
			var _d = point_distance(x, y, _actor.x, _actor.y);
			if (_d < _distance) {
				_distance = _d;
				_teamplayer = id;
			}
		}
	}

	return { teamplayer: _teamplayer, distance: _distance };
}

function player_forward_amount(_actor, _candidate) {
	var _dir = actor_attack_dir(_actor);
	return (_candidate.x - _actor.x) * _dir;
}

function pass_lane_score(_actor, _receiver, _opponent_obj) {
	var _distance = point_distance(_actor.x, _actor.y, _receiver.x, _receiver.y);
	var _space = nearest_opponent_distance_at(_receiver.x, _receiver.y, _opponent_obj);
	var _blocked = collision_line(_actor.x, _actor.y, _receiver.x, _receiver.y, _opponent_obj, false, true);
	var _forward = player_forward_amount(_actor, _receiver);
	var _ideal_distance = 115;

	var _score = 0;
	_score += _space * 0.9;
	_score -= abs(_distance - _ideal_distance) * 0.42;
	_score += clamp(_forward, -70, 120) * 0.45;

	if (_blocked == noone) {
		_score += 70;
	} else {
		_score -= 95;
	}

	if (_receiver.player_role == PLAYER_ROLE.ATTACKER) _score += 18;
	if (_receiver.player_role == PLAYER_ROLE.MIDFIELDER) _score += 8;
	if (_actor.player_role == PLAYER_ROLE.DEFENDER && _forward > 12) _score += 22;
	if (_distance < 34) _score -= 90;
	if (_distance > 260) _score -= 110;

	return { score: _score, distance: _distance, blocked: _blocked };
}

function best_open_pass_target(_teamplayer_obj, _opponent_obj, _actor = self) {
	var _best_player = noone;
	var _best_distance = 9999;
	var _best_score = -999999;

	with (_teamplayer_obj) {
		if (id != _actor.id) {
			var _lane = pass_lane_score(_actor, id, _opponent_obj);

			if (_lane.distance >= 30 && _lane.distance <= 265 && _lane.score > _best_score) {
				_best_score = _lane.score;
				_best_player = id;
				_best_distance = _lane.distance;
			}
		}
	}

	return { teamplayer: _best_player, distance: _best_distance, score: _best_score };
}

function best_player_pass_target(_actor, _raw_dir) {
	var _best_player = noone;
	var _best_distance = 9999;
	var _best_score = -999999;
	var _max_cone = 82;

	with (_actor.teamplayer_obj) {
		if (id != _actor.id) {
			var _distance = point_distance(x, y, _actor.x, _actor.y);
			if (_distance >= 28 && _distance <= 285) {
				var _target_dir = point_direction(_actor.x, _actor.y, x, y);
				var _angle_diff = abs(angle_delta(_raw_dir, _target_dir));

				if (_angle_diff <= _max_cone) {
					var _lane = pass_lane_score(_actor, id, _actor.opponent_team_obj);
					var _score = _lane.score - _angle_diff * 2.15;

					if (_angle_diff <= 22) _score += 45;
					if (id == _actor.last_pass_target) _score += 12;

					if (_score > _best_score) {
						_best_score = _score;
						_best_player = id;
						_best_distance = _distance;
					}
				}
			}
		}
	}

	return { teamplayer: _best_player, distance: _best_distance, score: _best_score };
}

function teamplayer_is_free(_teamplayer_obj, _opponent_obj, _actor = self) {
	var _target = best_open_pass_target(_teamplayer_obj, _opponent_obj, _actor);
	return _target.teamplayer != noone && _target.score > 35;
}

function closest_teamplayer_to_the_ball(_teamplayer_obj) {
	var _closest_player = noone;
	var _shortest_distance = 999999;

	if (!instance_exists(oBall)) return noone;

	var _ball_x = oBall.x;
	var _ball_y = oBall.y;

	with (_teamplayer_obj) {
		if (global.with_poss != id) {
			var _d = point_distance(x, y, _ball_x, _ball_y);

			if (_d < _shortest_distance) {
				_shortest_distance = _d;
				_closest_player = id;
			}
		}
	}

	return _closest_player;
}

function best_control_player_for_ball(_teamplayer_obj, _current) {
	var _best_player = noone;
	var _best_score = 999999;

	with (_teamplayer_obj) {
		var _score = point_distance(x, y, oBall.x, oBall.y);

		if (id == _current) _score -= 22;
		if (player_role == PLAYER_ROLE.ATTACKER) _score -= 4;

		if (_score < _best_score) {
			_best_score = _score;
			_best_player = id;
		}
	}

	return _best_player;
}

function best_control_player_for_defense(_teamplayer_obj, _holder, _current) {
	if (_holder == noone || !instance_exists(_holder)) {
		return best_control_player_for_ball(_teamplayer_obj, _current);
	}

	var _best_player = noone;
	var _best_score = 999999;

	with (_teamplayer_obj) {
		var _holder_dist = point_distance(x, y, _holder.x, _holder.y);
		var _ball_dist = point_distance(x, y, oBall.x, oBall.y);
		var _score = _holder_dist * 0.78 + _ball_dist * 0.22;

		if (id == _current) _score -= 26;
		if (player_role == PLAYER_ROLE.DEFENDER) _score -= 8;
		if (player_role == PLAYER_ROLE.ATTACKER && _holder_dist > 130) _score += 18;

		if (_score < _best_score) {
			_best_score = _score;
			_best_player = id;
		}
	}

	return _best_player;
}

function am_i_closest_to_ball(_actor) {
	var _closest = closest_teamplayer_to_the_ball(_actor.object_index);
	return _closest == _actor.id;
}

function support_rank(_actor) {
	var _holder = global.with_poss;
	if (_holder == noone || !instance_exists(_holder)) return 99;

	var _rank = 0;
	var _my_dist = point_distance(_actor.x, _actor.y, _holder.x, _holder.y);

	with (_actor.teamplayer_obj) {
		if (id != _actor.id && id != _holder) {
			var _dist = point_distance(x, y, _holder.x, _holder.y);
			if (_dist < _my_dist) {
				_rank++;
			}
		}
	}

	return _rank;
}

function should_support_attack(_actor) {
	var _holder = global.with_poss;
	if (_holder == noone || !instance_exists(_holder)) return false;
	if (_holder == _actor.id) return false;
	if (_holder.my_team != _actor.my_team) return false;

	if (_actor.player_role == PLAYER_ROLE.DEFENDER) {
		return support_rank(_actor) == 0 && actor_progress_to_goal(_holder) > 0.45;
	}

	if (_actor.player_role == PLAYER_ROLE.ATTACKER) return true;
	return support_rank(_actor) < 3;
}

function find_support_space(_actor) {
	var _holder = global.with_poss;
	if (_holder == noone || !instance_exists(_holder)) {
		return { target_x: _actor.initial_x, target_y: _actor.initial_y, score: 0 };
	}

	var _goal_dir = (_holder.target != noone) ? point_direction(_holder.x, _holder.y, _holder.target.x, _holder.target.y) : 0;
	var _side_dir = _goal_dir + 90;
	var _lane_hint = sign(_actor.initial_y - _holder.initial_y);
	if (_lane_hint == 0) _lane_hint = choose(-1, 1);

	var _rank = support_rank(_actor);
	var _role_forward = 45;
	var _role_wide = 28;

	if (_actor.player_role == PLAYER_ROLE.ATTACKER) {
		_role_forward = 82;
		_role_wide = 44;
	} else if (_actor.player_role == PLAYER_ROLE.DEFENDER) {
		_role_forward = 24;
		_role_wide = 22;
	}

	var _best_x = _actor.x;
	var _best_y = _actor.y;
	var _best_score = -999999;

	for (var i = 0; i < 6; i++) {
		var _lane = (i mod 2 == 0) ? _lane_hint : -_lane_hint;
		var _forward_dist = _role_forward + floor(i / 2) * 28 + _rank * 7;
		var _wide_dist = _role_wide + _rank * 10;
		var _cx = _holder.x + lengthdir_x(_forward_dist, _goal_dir) + lengthdir_x(_wide_dist * _lane, _side_dir);
		var _cy = _holder.y + lengthdir_y(_forward_dist, _goal_dir) + lengthdir_y(_wide_dist * _lane, _side_dir);

		_cy = lerp(_cy, _actor.initial_y, 0.22);
		var _field_pos = clamp_to_field_point(_cx, _cy, 18, 18, 18);
		_cx = _field_pos.x;
		_cy = _field_pos.y;

		var _space = nearest_opponent_distance_at(_cx, _cy, _actor.opponent_team_obj);
		var _pass_dist = point_distance(_holder.x, _holder.y, _cx, _cy);
		var _blocked = collision_line(_holder.x, _holder.y, _cx, _cy, _actor.opponent_team_obj, false, true);
		var _score = _space - abs(_pass_dist - 115) * 0.35 - point_distance(_actor.x, _actor.y, _cx, _cy) * 0.12;

		if (_blocked == noone) _score += 70; else _score -= 90;
		if (_pass_dist < 45) _score -= 100;

		if (_score > _best_score) {
			_best_score = _score;
			_best_x = _cx;
			_best_y = _cy;
		}
	}

	return { target_x: _best_x, target_y: _best_y, score: _best_score };
}

function defense_press_rank(_actor, _holder) {
	var _rank = 0;
	var _my_dist = point_distance(_actor.x, _actor.y, _holder.x, _holder.y);

	with (_actor.teamplayer_obj) {
		if (id != _actor.id) {
			var _dist = point_distance(x, y, _holder.x, _holder.y);
			if (_dist < _my_dist) _rank++;
		}
	}

	return _rank;
}

function should_press_holder(_actor, _holder) {
	if (_holder == noone || !instance_exists(_holder)) return false;

	var _dist = point_distance(_actor.x, _actor.y, _holder.x, _holder.y);
	var _rank = defense_press_rank(_actor, _holder);
	var _danger = 1 - clamp(point_distance(_holder.x, _holder.y, _actor.my_goal.x, _actor.my_goal.y) / 260, 0, 1);

	if (_rank == 0 && _dist < 190) return true;
	if (_actor.player_role == PLAYER_ROLE.DEFENDER) return _rank < 2 && (_danger > 0.35 || _dist < 95);
	if (_actor.player_role == PLAYER_ROLE.MIDFIELDER) return _rank < 2 && _dist < 135;

	return _rank < 2 && _dist < 110;
}

function find_mark_target(_actor) {
	var _holder = global.with_poss;
	var _best_target = noone;
	var _best_score = -999999;

	with (_actor.opponent_team_obj) {
		if (id != _holder) {
			var _candidate = id;
			var _marks = 0;

			with (_actor.object_index) {
				if (id != _actor.id && mark_target == _candidate) {
					_marks++;
				}
			}

			var _dist_actor = point_distance(x, y, _actor.x, _actor.y);
			var _dist_goal = (_actor.my_goal != noone) ? point_distance(x, y, _actor.my_goal.x, _actor.my_goal.y) : 160;
			var _dist_ball = (_holder != noone && instance_exists(_holder)) ? point_distance(x, y, _holder.x, _holder.y) : 120;
			var _score = -_dist_actor * 0.75 - _dist_goal * 0.36 - _marks * 150 + _dist_ball * 0.18;

			if (id == _actor.mark_target) _score += 42;
			if (player_role == PLAYER_ROLE.ATTACKER) _score += 18;
			if (_dist_ball < 42) _score -= 45;

			if (_score > _best_score) {
				_best_score = _score;
				_best_target = id;
			}
		}
	}

	return _best_target;
}

function can_shoot(_goal) {
	var _dist = goal_distance(_goal);
	var _dir = sign(_goal.x - x);
	return (_dist.angle >= 14 && _dist.goal_dist <= 205 && (_dir == 0 || _dir == sign(image_xscale)));
}

function shot_score(_actor) {
	if (_actor.target == noone || !instance_exists(_actor.target)) {
		return { can: false, score: -9999, target_x: _actor.x, target_y: _actor.y };
	}

	var _goal = _actor.target;
	var _top_y = _goal.top_post.y + 8;
	var _bottom_y = _goal.bottom_post.y - 8;
	var _best_y = (_top_y + _bottom_y) * 0.5;
	var _best_score = -999999;
	var _dist = point_distance(_actor.x, _actor.y, _goal.x, _goal.y);
	var _goal_info = goal_distance(_goal);
	var _open = _goal_info.angle;

	for (var i = 0; i < 5; i++) {
		var _t = (i + 1) / 6;
		var _gy = lerp(_top_y, _bottom_y, _t);
		var _dir = point_direction(_actor.x, _actor.y, _goal.x, _gy);
		var _blocked = collision_line(_actor.x, _actor.y, _goal.x, _gy, _actor.opponent_team_obj, false, true);
		var _turn = abs(angle_delta(_actor.angle, _dir));
		var _score = 110 - _dist * 0.34 + _open * 1.25 - _turn * 0.45;

		if (_blocked == noone) _score += 42; else _score -= 48;
		if (_actor.player_role == PLAYER_ROLE.ATTACKER) _score += 18;
		if (_actor.player_role == PLAYER_ROLE.DEFENDER) _score -= 28;

		if (_score > _best_score) {
			_best_score = _score;
			_best_y = _gy;
		}
	}

	return {
		can: (_dist <= 215 && _open >= 10 && _best_score > 32),
		score: _best_score,
		target_x: _goal.x,
		target_y: _best_y
	};
}

function bot_should_tackle(_actor) {
	if (_actor.tackle_cooldown > 0 || _actor.is_tackling || _actor.has_ball) return false;
	if (ball_is_free()) return false;

	var _holder = global.with_poss;
	if (_holder == noone || !instance_exists(_holder) || _holder.my_team == _actor.my_team) return false;
	if (_holder.possession_grace_timer > 0) return false;

	var _dist = point_distance(_actor.x, _actor.y, _holder.x, _holder.y);
	var _dir = point_direction(_actor.x, _actor.y, _holder.x, _holder.y);
	var _turn = abs(angle_delta(_actor.angle, _dir));
	var _chance = (_actor.player_role == PLAYER_ROLE.DEFENDER) ? 0.7 : 0.42;

	if (_holder.my_team == global.team_home) _chance *= 0.72;

	return _dist <= 23 && _turn <= 84 && random(1) < _chance;
}

function ball_can_be_collected_by(_actor) {
	if (owner != noone) return false;
	if (_actor == noone || !instance_exists(_actor)) return false;
	if (pickup_lock_timer > 0 && _actor == last_owner) return false;
	if (_actor.is_tackling) return true;
	if (intended_receiver != noone && instance_exists(intended_receiver) && _actor == intended_receiver) return true;
	if (intended_receiver != noone && instance_exists(intended_receiver) && _actor.my_team != intended_receiver.my_team) return false;
	if (speed > 11) return false;

	return true;
}
