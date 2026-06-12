
if (global.match_state == MATCH_STATE.PLAYING) {
	refresh_player_targets(id);
	update_player_timers(id);

	if (is_tackling) {
		update_tackle_motion(id);
	} else if (global.player_controlling == id) {
		player_control_update(id);
	} else {
		ai_update(id);
	}
}
