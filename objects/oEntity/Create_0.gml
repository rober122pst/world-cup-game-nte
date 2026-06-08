z = 0;

dx = 0;
dy = 0;
angle = 0;

initial_x = x;
initial_y = y;

hspd = 0;
vspd = 0;
max_spd = 2;

acc = 0.4;
fric = 0.1;

timer_with_poss = 0;
ball_hold_timer = 0;
receive_lock_timer = 0;
possession_grace_timer = 0;

state = noone;

target = noone;
my_goal = noone;
field_side = 1;

has_ball = false;

current_shoot_state = -1;

force = 0;
max_force = 30;
increment_force = .55;

set_alarm = false;

opponent_team_obj = oOpponentPlayer;
teamplayer_obj = oTeamPlayer;
my_team = global.team_home;

shirt = noone;

player_role = PLAYER_ROLE.MIDFIELDER;
role_label = "Meio";

decision = "";
pos_target_x = x;
pos_target_y = y;
mark_target = noone;
last_pass_target = noone;

ai_context = "";
ai_intent = AI_INTENT.HOLD;
ai_intent_timer = 0;
ai_decision_noise = random(1);

pass_cooldown = 0;
ai_pass_patience = 0;

is_tackling = false;
tackle_timer = 0;
tackle_cooldown = 0;
tackle_dir = 0;
tackle_hit_done = false;

is_busy = false;
busy_timer = 0;
current_action_node = -1;
ai_tree = noone;

pause_state = function () {
	show_debug_message("To parado");
	exit;
}

freeze_state = function () {
	freeze(id);
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
