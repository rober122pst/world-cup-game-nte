randomise();

global.with_poss = noone;

global.team_home = "Brasil";
global.team_away = "Argentina";

global.debug = false;

global.field_left = 0;
global.field_top = 0;
global.field_right = sprite_get_width(sprField);
global.field_bottom = sprite_get_height(sprField);
global.field_middle = global.field_right * 0.5;

global.pass_assist_strength = 0.72;
global.shoot_assist_strength = 0.46;

global.player_controlling = noone;

can_swap = true;
control_switch_timer = 0;
last_player_with_control = noone;
