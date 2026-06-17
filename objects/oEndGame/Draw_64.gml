var _flag_w = sprite_get_width(sprFlags)*scale;
var gap = 8*scale;
var font_w = 16*scale;
var separator = 16*scale;
var container = _flag_w*2 + gap*4 + font_w*2 + separator; 

var _initial_xx = view_center - container/2;
var _yy = view_middle - (sprite_get_height(sprFlags)/2)*scale;

var team_h = oTeams.get_team_id(global.team_home);
var team_a = oTeams.get_team_id(global.team_away);


draw_sprite_ext(sprFlags, team_h, _initial_xx, _yy, scale, scale, 0, c_white, 1);

draw_set_valign(fa_middle);
draw_set_font(font_score);
draw_text_transformed(_initial_xx + _flag_w + gap, view_middle, global.scores[0], scale, scale, 0);
draw_set_font(font);
draw_text_transformed(_initial_xx + _flag_w + gap*2 + font_w, view_middle, "X", scale, scale, 0);
draw_set_font(font_score);
draw_text_transformed(_initial_xx + _flag_w + gap*3 + font_w*2, view_middle, global.scores[1], scale, scale, 0);
draw_set_valign(fa_top);

draw_sprite_ext(sprFlags, team_a, _initial_xx + _flag_w + gap*4 + font_w*3, _yy, scale, scale, 0, c_white, 1);

draw_set_font(font_panel);
draw_set_halign(fa_center);
draw_set_alpha((current_time div 500) mod 2);
draw_set_colour(c_white);
draw_text_transformed(view_center, 216*scale, "Pressione ENTER para voltar...", scale, scale, 0);
draw_set_halign(fa_left);
draw_set_alpha(1);