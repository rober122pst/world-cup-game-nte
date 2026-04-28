function player_move() {
	if (dx != 0 || dy != 0) {
		var _input_dist = point_distance(0, 0, dx, dy);
		angle = point_direction(0, 0, dx, dy);
		
		hspd += (dx / _input_dist) * acc;
		vspd += (dy / _input_dist) * acc;
		
		var _current_vel = point_distance(0, 0, hspd, vspd);
		if (_current_vel >= max_spd) {
			hspd = (hspd / _current_vel) * max_spd;
			vspd = (vspd / _current_vel) * max_spd;
		}
	} else {
		hspd = lerp(hspd, 0, fric);	
		vspd = lerp(vspd, 0, fric);	
	}
	
	y += vspd;
	x += hspd;
	
	if (abs(hspd) <= .1 && abs(vspd) <= .1) {
		sprite_index = sprPlayerIdleSide;
	} else {
		sprite_index = sprPlayerSide;	
	}
	
	if (dx != 0)
		image_xscale = dx;
}