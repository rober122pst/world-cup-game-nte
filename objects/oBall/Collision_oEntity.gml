if (owner == noone && z == other.z) {
	owner = other.id;
	state = ball_in_posse_state;
	other.has_ball = true;
	
	global.with_poss = other.id;
}