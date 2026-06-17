if (can_restart) {
	if (global.scores[0] == 5 || global.scores[1] == 5) {
		room_goto(rmEndGame);
	} else {
		room_restart();	
	}
}