randomise();

audio_group_load(sound_effects);

global.with_poss = noone;

global.team_home = oTeams.teams_selected[0].name;
global.team_away = oTeams.teams_selected[1].name;
global.team_goal = "";

global.scores = [0, 0];

global.debug = false;

global.field_left = 0;
global.field_top = 0;
global.field_right = room_width;
global.field_bottom = room_height;
global.field_tl_x = global.field_left;
global.field_tl_y = global.field_top;
global.field_tr_x = global.field_right;
global.field_tr_y = global.field_top;
global.field_bl_x = global.field_left;
global.field_bl_y = global.field_bottom;
global.field_br_x = global.field_right;
global.field_br_y = global.field_bottom;
global.field_m_l = 0;
global.field_m_r = 0;
global.field_b_l = global.field_top;
global.field_b_r = global.field_top;
global.field_middle = global.field_right * 0.5;
global.field_center_y = global.field_bottom * 0.5;

global.pass_assist_strength = 0.72;
global.shoot_assist_strength = 0.46;

global.player_controlling = noone;

global.timer = 0;

enum MATCH_STATE {
	STARTING,
	PLAYING,
	GOAL,
	CURIOSITY,
	VAR,
}

global.match_state = MATCH_STATE.STARTING;

alarm[0] = game_get_speed(gamespeed_fps) * 3;

can_swap = true;
control_switch_timer = 0;
last_player_with_control = noone;

has_seted = false;
set_alarm = false;

can_restart = false;

syllables = [
	["BO", "LA"],
	["CAM", "PO"],
	["FU", "TE", "BOL"],
	["BAR", "RA"],
	["RE", "DE"],
	["ÁR", "BI", "TRO"],
	["JO", "GA", "DOR"],
	["TI", "ME"],
	["GOL"],
	["CHU", "TE"],
	["GO", "LEI", "RO"],
	["CA", "MI", "SA"],
	["COR", "RER"],
	["CHU", "TAR"],
	["TA", "ÇA"],
	["TOR", "CI", "DA"],
	["CHU", "TEI", "RA"],
];

global.collected = [];
global.current_syllable = syllables[irandom_range(0, array_length(syllables) - 1)];