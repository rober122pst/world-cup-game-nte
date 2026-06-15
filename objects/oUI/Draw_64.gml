draw_sprite_ext(sprScoreboard, 0, view_center, 16, scale, scale, 0, c_white, 1);

var _w_scoreboard = sprite_get_width(sprScoreboard)*scale;
var _xx = view_center - (_w_scoreboard / 2) + 1*scale;
var _yy = 16 + 1*scale;
draw_sprite_ext(sprTeamScoreLeft, oTeams.teams_selected[0]._id, _xx, _yy, scale, scale, 0, c_white, 1);
_xx = view_center + (_w_scoreboard / 2) - 1*scale;
draw_sprite_ext(sprTeamScoreRight, oTeams.teams_selected[1]._id, _xx, _yy, scale, scale, 0, c_white, 1);

draw_set_halign(fa_right);
draw_set_font(font_score);
draw_text_transformed(view_center - 4*scale, _yy + 2*scale, string(global.scores[0]), scale, scale, 0);
draw_set_halign(fa_left);
draw_text_transformed(view_center + 8*scale, _yy + 2*scale, string(global.scores[1]), scale, scale, 0);

var total_seconds = global.timer div game_get_speed(gamespeed_fps);

var minutes = total_seconds div game_get_speed(gamespeed_fps);
var seconds = total_seconds mod game_get_speed(gamespeed_fps);

draw_set_font(font_time);
draw_set_halign(fa_center);
draw_text_transformed(view_center + 6*scale, _yy + 22*scale, two_digits(minutes) + ":" + two_digits(seconds), scale, scale, 0);
draw_set_halign(fa_left);

draw_set_font(font);

array_map(
	global.current_syllable,
	function(_element, _index) {
		var container = (array_length(global.current_syllable))*48*scale;
		var _xx = view_center - container/2;
		
		if (array_contains(global.collected, _element)) {
			draw_set_colour(c_white);	
		} else {
			draw_set_colour(#2f3b3d);	
		}
		
		draw_text_transformed(_xx + _index*48*scale, view_height - 32*scale, _element, scale, scale, 0);
	}
);




if (global.match_state == MATCH_STATE.GOAL) {
	draw_set_colour(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(0, 0, view_width, view_height, 0);
	draw_sprite_ext(sprGoalText, anim_frame, view_center, view_middle, scale, scale, 0, c_white, 1);
}

if (global.match_state == MATCH_STATE.VAR) {
	draw_set_colour(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(0, 0, view_width, view_height, 0);
	draw_sprite_ext(sprVarScreen, 0, 0, 0, scale, scale, 0, c_white, 1);	
}

draw_set_alpha(1);
draw_set_colour(c_white);
