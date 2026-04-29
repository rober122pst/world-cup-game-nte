var _max_height = 70;
var _shadow_scale = 1 - (abs(z) / _max_height);

draw_set_alpha(.8 - (abs(z) / _max_height));
draw_set_colour(#2f3b3d);
draw_ellipse(x - 8, y - 3, x + 7, y + 1, false);
draw_set_alpha(1);
draw_set_colour(c_white);

draw_self();

if(current_shoot_state == SHOOT_STATE.SHOOTING) {
	draw_healthbar(x-16,y-36,x+16,y-32,(force/max_force)*100,c_black,c_red,c_green,0,1,1);	
}


#region DEBUG

if (global.debug) {
	if (target) {
		var distance = goal_distance(target);

		draw_triangle(x, y, target.top_post.x, target.top_post.y, target.bottom_post.x, target.bottom_post.y, 1);
		if (can_shoot(target)) draw_set_colour(c_green); else draw_set_colour(c_red);
		draw_set_alpha(.2);
		draw_triangle(x, y, target.top_post.x, target.top_post.y, target.bottom_post.x, target.bottom_post.y, 0);
		draw_set_colour(c_white);
		draw_set_alpha(1);
	
		draw_line(x, y, target.x, target.y);

		draw_text((x + target.x) / 2, (y + target.y) / 2, string(distance.goal_dist) + "m");
		draw_text((x + target.x) / 2, ((y + target.y) / 2) + 16, string(distance.angle) + "°");
	}

	var _radius = 32;
	var _is_surrounded = is_surrounded(opponent_team_obj, _radius);

	draw_circle(x, y, _radius, 1);
	if (_is_surrounded) {
		draw_set_colour(c_red); 
		draw_set_alpha(.2);
	} else {
		draw_set_alpha(0);
	}
	draw_circle(x, y, _radius, 0);

	draw_set_alpha(1);
	draw_set_colour(c_white)

	var _ball_dist = ball_distance();
	draw_set_colour(c_blue);
	draw_line(x, y, oBall.x, oBall.y);
	
	draw_text((x + oBall.x) / 2, (y + oBall.y) / 2, string(_ball_dist) + "m");
	draw_set_colour(c_white);
	
	draw_circle(x, y, 90, 1);
	draw_circle(x, y, 160, 1);
}
#endregion DEBUG