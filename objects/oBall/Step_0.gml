var _from_x = prev_x;
var _from_y = prev_y;

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

goal_frame_collision();
ball_hit_field_wall(_from_x, _from_y);


prev_x = x;
prev_y = y;

