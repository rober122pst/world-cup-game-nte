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
if (speed <= 0) {
	show_debug_message(point_distance(x_init, y_init, x, y));
}
z += zspd;