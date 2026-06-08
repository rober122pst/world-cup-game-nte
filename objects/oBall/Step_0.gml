prev_x = x;
prev_y = y;

state();

global.team_player_nearest = instance_nearest(x, y, oTeamPlayer);
global.opponent_nearest = instance_nearest(x, y, oOpponentPlayer);

if (pickup_lock_timer > 0) {
	pickup_lock_timer = max(pickup_lock_timer - global.dt, 0);
}

if (pass_assist_timer > 0) {
	pass_assist_timer = max(pass_assist_timer - global.dt, 0);
}

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

x = clamp(x, global.field_left, global.field_right);
y = clamp(y, global.field_top, global.field_bottom);

goal_frame_collision();
