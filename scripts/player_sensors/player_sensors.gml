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

function enemies_around(_opponent) {
	var enemies = [];
	var number = collision_circle_list(x, y, 150, _opponent, false, true, enemies, true);	
	
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