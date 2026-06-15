var ball = instance_create_layer(global.field_middle, global.field_center_y, "Instances", oBall);

var home_1 = instance_create_layer(global.field_middle, global.field_center_y - 2, "Instances", oTeamPlayer);
var home_2 = instance_create_layer(global.field_middle - 32, global.field_center_y, "Instances", oTeamPlayer);

var away_1 = instance_create_layer(global.field_middle + 32, global.field_center_y - 32, "Instances", oOpponentPlayer );
var away_2 = instance_create_layer(global.field_middle + 32, global.field_center_y + 32, "Instances", oOpponentPlayer);

switch (global.match_state) {
	case MATCH_STATE.VAR:
		global.match_state = MATCH_STATE.STARTING;
		alarm[0] = game_get_speed(gamespeed_fps) * 3;
		
		home_1.x = global.field_middle + 32;
		home_1.y = global.field_center_y - 32;
			
		home_2.x = global.field_middle + 32;
		home_2.y = global.field_center_y + 32;
			
		away_1.x = global.field_right - 32;
		away_1.y = global.field_center_y + 16;
			
		away_2.x = global.field_middle + 48;
		away_2.y = global.field_center_y;
		away_2.image_xscale = 1;
		away_2.angle = 0;
		
		ball.x = global.field_right - 32;
		ball.y = global.field_center_y + 16;
		
		break;
	case MATCH_STATE.GOAL:
		global.match_state = MATCH_STATE.STARTING;
		alarm[0] = game_get_speed(gamespeed_fps) * 3;
		if (prev_goal_score[0] != global.scores[0]) {
			home_1.x = global.field_middle - 32;
			home_1.y = global.field_center_y - 32;
			
			home_2.x = global.field_middle - 32;
			home_2.y = global.field_center_y + 32;
			
			away_1.x = global.field_middle;
			away_1.y = global.field_center_y - 2;
			
			away_2.x = global.field_middle + 32;
			away_2.y = global.field_center_y;
		}
		array_copy(prev_goal_score, 0, global.scores, 0, 2);
		break;
}

global.current_syllable = syllables[irandom_range(0, array_length(syllables) - 1)];
global.collected = [];

array_map(
	global.current_syllable,
	function(_element) {
		instance_create_layer(irandom_range(global.field_left, global.field_right - 64), irandom_range(global.field_top, global.field_bottom - 64), "Instances", oItems, {
			text: _element
		});
	}
);
