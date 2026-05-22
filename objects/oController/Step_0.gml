var target_fps = 60;
global.dt = delta_time / (1000000 / target_fps);

if (global.with_poss == noone) {
	if (can_swap && global.player_controlling == noone) {
		global.player_controlling = closest_teamplayer_to_the_ball(oTeamPlayer);
		if (global.player_controlling != last_player_with_control || oBall.speed <= 0.1) {
			can_swap = false;
			last_player_with_control = global.player_controlling;
		}
	}
} else {
	if (global.with_poss.object_index == oTeamPlayer) {
		global.player_controlling = global.with_poss;
		last_player_with_control = global.player_controlling;
	} else {
		global.player_controlling = closest_teamplayer_to_the_ball(oTeamPlayer);	
	}
	can_swap = true;
}


with all {
	depth = -bbox_bottom;	
}