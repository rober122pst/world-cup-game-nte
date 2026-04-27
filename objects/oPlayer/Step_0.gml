_state();
get_player_sprites();

dx = KEY_RIGHT - KEY_LEFT;
dy = KEY_DOWN - KEY_UP;

if(KEY_SHOOT && state == posse) {
	if(stateShoot == 0) {
		stateShoot = chutando;
	}else if(stateShoot == chutando) {
		stateShoot = chutou;
	}
}else if(KEY_PASS && state == posse) {
	
}

if(place_meeting(x,y,oBall)) {
	state = posse;
}

if(state = posse) {
	if(KEY_RIGHT || KEY_LEFT) {
		oBall.x = x+15*dx;
		oBall.y = y+12;
	}else if(KEY_UP || KEY_DOWN) {
		oBall.x = x;
		oBall.y = y+12*dy;
	}
	
	if(stateShoot == chutando) {
		forca+=incrementForca;
		target = oBar;
		var angle = point_direction(x,y,target.x,target.y+random_range(-112,122));
		velx = cos(degtorad(angle));
		vely = -sin(degtorad(angle));
		if(forca >= maxForca) {
			forca = maxForca;
			stateShoot = chutou;
		}
	}
}

if(stateShoot == chutou) {
	state = noone;
	if(distance_to_object(oBar) < 192) {
		if(oBall.direction != 180) {
			oBall.direction = 0;
			oBall.x += forca*velx;
			oBall.y += forca*vely;
			oBall.speed = forca;
		}else {
			oBall.speed = forca;
		}
	}else {
		oBall.speed = forca;
	}
	forca -= 0.03;
	if(forca <= 0) {
		forca = 0;	
		stateShoot = 0;
	}
}else {
	oBall.speed = 0;	
}

if(!KEY_RIGHT && !KEY_LEFT && !KEY_UP && !KEY_DOWN) 
{
	if(dir = 1) {
		sprite_index = sprPlayerIdleSide;
		image_xscale = -1;
	}else if(dir = -1) {
		sprite_index = sprPlayerIdleSide;
		image_index = 1;
	}else if(dir = 2) {
		sprite_index = sprPlayerIdleUp;
		image_xscale = 1;
	}else if(dir = -2) {
		sprite_index = sprPlayerIdleDown;
		image_xscale = 1;
	}
}