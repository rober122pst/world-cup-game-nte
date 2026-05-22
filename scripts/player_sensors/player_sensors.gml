function goal_distance(_goal){
	if (_goal == noone) return;
	
	var _goal_post_1 = _goal.top_post;
	var _goal_post_2 = _goal.bottom_post;
	
	var _dir_goal_1 = point_direction(x, y, _goal_post_1.x, _goal_post_1.y);
	var _dir_goal_2 = point_direction(x, y, _goal_post_2.x, _goal_post_2.y);
	
	var angle = abs(angle_difference(_dir_goal_1, _dir_goal_2));
	
	var goal_dist = point_distance(x, y, _goal.x, _goal.y);
	
	return { angle, goal_dist } 
}

function is_time_to_shoot(_actor) {
	increment_shoot_force(_actor);	
	var _goal_dist = goal_distance(target);
	var _max_force = (max_force * _goal_dist.goal_dist) / (max_force / oBall.fric); // Dist maxima
	var _range = clamp(round(random_range(_max_force - 5, _max_force + 5)), 0, max_force);
	
	if (force < _range) {
		if (current_shoot_state != SHOOT_STATE.SHOOTING) current_shoot_state = SHOOT_STATE.SHOOTING;
		force+=increment_force*global.dt;	
	} else {
		current_shoot_state = SHOOT_STATE.SHOT;
		return true;
	}
}

function is_freeze() {
	return current_shoot_state == SHOOT_STATE.FREEZE;	
}

function enemies_around(_opponent_obj, _radius) {
	var enemies = ds_list_create();
	var number = collision_circle_list(x, y, _radius, _opponent_obj, false, true, enemies, true);	
	
	return { enemies, number } 
}

function is_team_with_pos() {
	if (global.with_poss == noone) return false;
	return global.with_poss.my_team == my_team;
}

function ball_is_free() {
	return global.with_poss == noone;	
}

function ball_distance() {
	return point_distance(x, y, oBall.x, oBall.y);	
}

function can_shoot(_goal) {
	
	var dist = goal_distance(_goal);
	var dir = sign(_goal.x - x);
	return (dist.angle >= 24 && dist.goal_dist <= 135 && dir == image_xscale);
}

function is_surrounded(_opponent_obj, _radius) {
	return enemies_around(_opponent_obj, _radius).number > 2;	
}

function is_near_to_ball() {
	return ball_distance() < 160;	
}

function nearest_opponent(_opponent_obj) {
	var opponent =	noone;
	
	with (_opponent_obj) {
		if (opponent == noone) {
			opponent = id;
		} else {
			if (point_distance(x, y, other.x, other.y) > point_distance(opponent.x, opponent.y, other.x, other.y)) {
				opponent = id;
			}
		}
	}
	
	var distance = point_distance(x, y, opponent.x, opponent.y);
	return { opponent, distance };
}

function is_near_to_opponent(_opponent_obj) {
	return (nearest_opponent(_opponent_obj) < 90);
}

function is_near_to_opponent_w_ball() {
	if (global.with_poss.my_team != my_team) {
		return point_distance(x, y, _opponent_obj.x, _opponent_obj.y) < 90;
	}
	return false;
}

function nearest_teamplayer(_teamplayer_obj) {
	var teamplayer = noone;
	var distance = 9999;
	
	with (object_index) {
		if (id != other.id)
	    {
	        var d = point_distance(x, y, other.x, other.y);

	        if (d < distance)
	        {
	            distance = d;
	            teamplayer = id;
	        }
	    }
	}
	
	return { teamplayer, distance };
}

function closest_teamplayer_to_the_ball(_teamplayer_obj) {
	var _closest_player = noone;
	var _shortest_distance = 999999; // Um número bem alto para garantir
	
	// Garantir que a bola existe antes de medir a distância
	if (!instance_exists(oBall)) return noone;
	
	var _ball_x = oBall.x;
	var _ball_y = oBall.y;
	
	with (_teamplayer_obj) {
		if (global.with_poss != id) {
			var _d = point_distance(x, y, _ball_x, _ball_y);
			
			// No GM moderno, variáveis 'var' da função são acessadas direto
			if (_d < _shortest_distance) {
				_shortest_distance = _d;
				_closest_player = id;
			}
		}
	}
	
	return _closest_player;
}

function teamplayer_is_free(_teamplayer_obj, _opponent_player) {
	var teamplayer = nearest_teamplayer(_teamplayer_obj);
	if (teamplayer == noone) return false;
	
	if (teamplayer.distance <= 160) {
		var col = collision_line(x, y, teamplayer.teamplayer.x, teamplayer.teamplayer.y, _opponent_player, false, true);
		if (col) {
			return false;	
		} else {
			return true;	
		}
	}
}

function am_i_closest_to_ball(_actor) {
	var closest = closest_teamplayer_to_the_ball(_actor.object_index);
	return closest == _actor.id;
}

function is_free_to_press(_actor) {
	var dir_to_goal = point_direction(oBall.x, oBall.y, _actor.my_goal.x, _actor.my_goal.y);
		
	var pressing_index = 0;
		
	with (_actor.object_index) {
		if (id != _actor.id && decision == "Pressionando/Cercando") {			
			if (id < _actor.id) {
				pressing_index++;	
			}
				
			if (pressing_index >= 2) {
				break;
			}
		}
	}
		
	pressing_index = clamp(pressing_index, 0, 2);
		
	var angle_offset = 0;
	if (pressing_index == 1) angle_offset =  30; 
	if (pressing_index == 2) angle_offset = -30;
		
	var final_angle = dir_to_goal - angle_offset;
		
	var security_dist = 30;
	var target_x = oBall.x + lengthdir_x(security_dist, final_angle);
	var target_y = oBall.y + lengthdir_y(security_dist, final_angle);
	
	return {
		final_angle,
		target_x,
		target_y
	}
}

function can_i_press_too(_actor) {
	var total_pressing = 0;
	var dist_to_target = 0;
	var dist_to_initial_pos = 0;
	
	var press_infos = is_free_to_press(id);
		
	with (_actor) {	
		with (_actor.object_index) {
			if (id != _actor.id && decision == "Pressionando/Cercando") {
				total_pressing++;
			
				if (total_pressing >= 3) {
					break;
				}
			}
		}	
		
		dist_to_target = point_distance(x, y, press_infos.target_x, press_infos.target_y);
		dist_to_initial_pos = point_distance(press_infos.target_x, press_infos.target_y, initial_x, initial_y);
	}
	
	return total_pressing < 3 && dist_to_target < 80 && dist_to_initial_pos < 120;
}

function is_near_enemy_area(_actor) {
	// Avalia a distância até o gol adversário [cite: 25] para saber se já pode infiltrar
	var dist = goal_distance(_actor.target);
	return dist.goal_dist < 150; // Ajuste esse valor de acordo com o tamanho do seu campo e da área
}