if (keyboard_check_pressed(vk_right)) {
	select++;
	if (select >= team_lenght) select = 0;
} else if (keyboard_check_pressed(vk_left)) {
	select--;
	if (select < 0) select = team_lenght - 1;
}

for (var i = 0; i < team_lenght; i++) {
	flags[i].selected = i == select;
}

if (keyboard_check_pressed(vk_enter)) {
	var team_a = irandom_range(0, team_lenght - 1);
	while (team_a == select) {
		team_a = irandom_range(0, team_lenght - 1);
	}
	
	team_selected = oTeams.set_teams(select, team_a)[0];
	room_goto(rmCampo);
}