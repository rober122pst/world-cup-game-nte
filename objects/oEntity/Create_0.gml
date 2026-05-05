

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

has_ball = false;

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
}

shoot_state = function () {
	if (KEY_SHOOT) {
		current_shoot_state = SHOOT_STATE.SHOT;	
	}
	
	shoot(id);
}

state = free_state;

is_with_ball = function() {
	return global.with_poss == id;
}

timer_to_shoot = 0;

decision = "";

is_busy = false;
busy_timer = 0;
current_action_node = -1;

//actions = player_functions();


var go_to_ball_node = new ActionNode(go_to_ball);
var shoot_node = new ActionNode(shooting);
var pass_node = new ActionNode(pass, 500);
var get_back_node = new ActionNode(get_back);
var go_to_goal_node = new ActionNode(go_to_goal);
var marcando = new ActionNode(function(_actor) { _actor.decision = "Marcando" }, 0, 5)
var esperando = new ActionNode(function(_actor) { _actor.decision = "Esperando" })

var check_goal_distance = new DecisionNode(
	function (_actor) {
		return can_shoot(_actor.target);	
	}, 
	shoot_node, 
	go_to_goal_node
);

var is_shot_node = new DecisionNode(
	function (_actor) {
		if (current_shoot_state == SHOOT_STATE.SHOT) {
			shot(_actor);
			return true;	
		}
		return false;
	},
	esperando,
	check_goal_distance
)

var teamplayer_free_node = new DecisionNode(
	function(_actor) {
		return teamplayer_is_free(_actor.teamplayer_obj, _actor.opponent_team_obj);
	},
	pass_node,
	get_back_node
);
	
var sunrrounded_node = new DecisionNode(
	function(_actor) { 
		return is_surrounded(_actor.opponent_team_obj, 32);
	}, 
	teamplayer_free_node,
	is_shot_node
);	

var team_with_pos_node = new DecisionNode(
	function(_actor) {
		return is_team_with_pos();
	},
	esperando,
	marcando
)
	
var ball_check_node = new DecisionNode(
	function(_actor) {
		return ball_is_free();
	}, 
	go_to_ball_node, 
	team_with_pos_node
); 

ai_tree = new DecisionNode(
	function(_actor) {
		return is_with_ball();
	}, 
	sunrrounded_node, 
	ball_check_node
);



