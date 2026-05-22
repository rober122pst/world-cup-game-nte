

z = 0;

dx = 0;
dy = 0;
angle = 0;

initial_x = x;
initial_y = y;

hspd = 0; vspd = 0;
max_spd = 2;

acc = 0.4; fric = 0.1;

timer_with_poss = 0;

state = noone;

target = noone;
my_goal = noone;

has_ball = false;

current_shoot_state = -1;

force = 0;
max_force = 30;
increment_force = .5;

set_alarm = false;

opponent_team_obj = oOpponentPlayer;
teamplayer_obj = oTeamPlayer;
my_team = global.team_home;

shirt = noone;

pause_state = function () {
	show_debug_message("To parado")
	exit; 
}

freeze_state = function () {
	sprite_index = sprPlayerIdleSide;
	x += .6 * -image_xscale;
	if (!set_alarm) {
		alarm[0] = ((game_get_speed(gamespeed_fps) * .75) * force) / max_force;
		force = 0;
		set_alarm = true;
	}
}

free_state = function () {
	player_move();
	
	if (current_shoot_state == SHOOT_STATE.FREEZE) {
		state = freeze_state;	
	}
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

pos_target_x = 0;
pos_target_y = 0;

//actions = player_functions();


var go_to_ball_node = new ActionNode(go_to_ball);
var shoot_node = new ActionNode(
	function (_action) {
		shot();	
	}
);
var pass_node = new ActionNode(pass);
var get_back_node = new ActionNode(get_back);
var go_to_goal_node = new ActionNode(go_to_goal);
var freeze_node = new ActionNode(freeze);

var go_to_pos_node = new ActionNode(go_to_position, 0, game_get_speed(gamespeed_fps) * 0.5);
var press_node = new ActionNode(press_opponent);

var esperando = new ActionNode(function(_actor) { _actor.decision = "Esperando" })

#region Com bola

var increment_force_node = new DecisionNode(
	function (_actor) {
		return is_time_to_shoot(_actor);	
	},
	shoot_node,
	esperando
);

var check_goal_distance = new DecisionNode(
	function (_actor) {
		return can_shoot(_actor.target);	
	}, 
	increment_force_node, 
	go_to_goal_node
);

var teamplayer_free_node = new DecisionNode(
	function(_actor) {
		return teamplayer_is_free(_actor.teamplayer_obj, _actor.opponent_team_obj);
	},
	pass_node,
	get_back_node
);
	
var sunrrounded_node = new DecisionNode(
	function(_actor) { 
		return is_surrounded(_actor.opponent_team_obj, 16);
	}, 
	teamplayer_free_node,
	check_goal_distance
);	
	
#endregion Com bola

#region Sem bola, time com bola


var am_i_closest_node = new DecisionNode(
	function(_actor) { return can_i_press_too(_actor); },
	press_node,     // SIM -> Vai pressionar/cercar
	go_to_pos_node  // NÃO -> Mantém o 1-2-2 fechando espaço
);

// A bola tá livre no campo?
var ball_free_node = new DecisionNode(
	function(_actor) { return ball_is_free(); }, // [cite: 31]
	new DecisionNode( // SIM, tá solta
		function(_actor) { return am_i_closest_to_ball(_actor); },
		go_to_ball_node, // Sou o mais perto -> Correr atrás da bola
		go_to_pos_node   // Não sou -> Ir para minha posição
	),
	am_i_closest_node // NÃO, adversário tá com ela -> Check de pressão
);

#endregion

var near_enemy_area_node = new DecisionNode(
	function(_actor) { return is_near_enemy_area(_actor); },
	go_to_pos_node, // SIM (No futuro vc pode mudar pra "run_to_space")
	go_to_pos_node  // NÃO (No futuro vc pode mudar pra "advance_slowly")
);

var team_with_pos_node = new DecisionNode(
	function(_actor) {
		return is_team_with_pos();
	},
	near_enemy_area_node,
	am_i_closest_node
)

var ball_check_node = new DecisionNode(
	function(_actor) {
		return ball_is_free();
	}, 
	ball_free_node, 
	team_with_pos_node
);

var with_ball_node = new DecisionNode(
	function(_actor) {
		return is_with_ball();
	}, 
	sunrrounded_node, 
	ball_check_node
);


ai_tree = new DecisionNode(
	function(_actor) {
		return is_freeze();
	}, 
	freeze_node, 
	with_ball_node
);



