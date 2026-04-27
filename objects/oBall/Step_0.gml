

if(oPlayer.forca >= 5 && oPlayer.stateShoot == oPlayer.chutou && jumpSize > 0) {
	jump = true;
	jumpSize--;
}



if (jump) {
	if(!isJumping) {
		jump = false;
		isJumping = true;
	}
	vspd = -8;
}

if (isJumping) {
	vspd += grvt;
	if(vspd >= 8) {
		vspd = 0;
		isJumping = false;
	}
}

y+=vspd

if(oPlayer.stateShoot = 0) {
	jumpSize = 1;	
}

x = clamp(x, 0, room_width);