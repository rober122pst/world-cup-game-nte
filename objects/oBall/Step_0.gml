x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

if (jump) {
	zspd = -6;
	jump = false;
}

zspd += grvt;

if ((z + zspd) > 0) {
	z = 0;
	zspd = 0;
}


speed = lerp(speed, 0, fric);
z += zspd;