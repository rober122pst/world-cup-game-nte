if (owner == noone) {
	owner = other.id;
	other.has_ball = true;
	
	global.with_poss = other.id;
}