dx = 0; dy = 0;
dir = 0;

hspd = 0; vspd = 0;
max_vel = 4;

acc = 0.5; fric = 0.15;

posse = 1;
marcando = 2;
atacando = 3;

state = noone;

target = oBar;

chutando = 1;
tocando = 2;
chutou = 3;
tocou = 4;

stateShoot = 0;

forca = 0;
maxForca = 6;
incrementForca = 0.07;

_state = noone;

free_state = function () {
	if (dx != 0 || dy != 0) {
		var _dist = point_distance(0, 0, dx, dy);
		var _dir = { xx: dx / _dist, yy: dy / _dist };
		
		hspd += _dir.xx * acc;
		vspd += _dir.yy * acc;
		
		var _current_vel = point_distance(0, 0, hspd, vspd);
		if (_current_vel > max_vel) {
			hspd = (hspd / _current_vel) * max_vel;
			vspd = (vspd / _current_vel) * max_vel;
		}
	} else {
		hspd = lerp(hspd, 0, fric);
		vspd = lerp(vspd, 0, fric);
	}
	
	y += vspd;
	x += hspd;
}

_state = free_state;