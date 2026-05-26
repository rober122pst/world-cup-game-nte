refresh_player_targets(id);
update_player_timers(id);

if (is_tackling) {
	update_tackle_motion(id);
} else {
	player_control_update(id);
}
