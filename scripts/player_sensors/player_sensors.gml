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

function enemies_around(_opponent_obj, _radius) {
	var enemies = ds_list_create();
	var number = collision_circle_list(x, y, _radius, _opponent_obj, false, true, enemies, true);	
	
	return { enemies, number } 
}

function is_team_with_pos() {
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
	
	with (_teamplayer_obj) {
		if (teamplayer == noone) {
			teamplayer = id;
		} else {
			if (point_distance(x, y, other.x, other.y) > point_distance(teamplayer.x, teamplayer.y, other.x, other.y)) {
				teamplayer = id;
			}
		}
	}
	
	var distance = point_distance(x, y, teamplayer.x, teamplayer.y);
	return { teamplayer, distance };
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