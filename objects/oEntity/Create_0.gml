posse = 1;
marcando = 2;
atacando = 3;

z = 0;

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
increment_force = .5;

set_alarm = false;

opponent_team_obj = oOpponentPlayer;
teamplayer_obj = oTeamPlayer;
my_team = global.team_home;

pause_state = function () {
	show_debug_message("To parado")
	exit; 
}

freeze_state = function () {
	if (!set_alarm) {
		alarm[0] = game_get_speed(gamespeed_fps) / 2;
		set_alarm = true;
	}
}

free_state = function () {
	player_move();
	
	if (place_meeting(x, y, oBall) && global.with_poss == noone) {
		//state = poss_state;
		global.with_poss = id;
	}
	
	current_shoot_state = -1;
}

shoot_state = function () {
	if (KEY_SHOOT) {
		current_shoot_state = SHOOT_STATE.SHOT;	
	}
	
	shoot();
}

state = free_state;

is_with_ball = function() {
	return global.with_poss == id;
}

ai_tree = noone;

if (object_index != oPlayer) {
	var go_to_ball_node = new ActionNode(go_to_ball);
	var shoot_node = new ActionNode(shoot);
	
	var ball_check_node = new DecisionNode(ball_is_free, go_to_ball_node, free_node); 
	var teamplayer_free_node = new DecisionNode(
		function() {
			teamplayer_is_free(teamplayer_obj, opponent_team_obj)	
		},
		
		)
	var sunrrounded_node = new DecisionNode(
		function() { 
			is_surrounded(opponent_team_obj, 32) 
		}, 
		
		);	
	var check_goal_distance = new DecisionNode(can_shoot, shoot_node, ); 
	
	
	ai_tree = new DecisionNode(is_with_ball, sunrrounded_node, ball_check_node);
}


