draw_self();

if(current_shoot_state == SHOOT_STATE.SHOOTING) {
	draw_healthbar(x-16,y-36,x+16,y-32,(force/max_force)*100,c_black,c_red,c_green,0,1,1);	
}


#region DEBUG

if (target) {
	var distance = goal_distance(target);

	draw_triangle(x, y, target.top_post.x, target.top_post.y, target.bottom_post.x, target.bottom_post.y, 1);
	draw_set_colour(c_red);
	draw_set_alpha(.2);
	draw_triangle(x, y, target.top_post.x, target.top_post.y, target.bottom_post.x, target.bottom_post.y, 0);
	draw_set_colour(c_white);
	draw_set_alpha(1);

	draw_text((x + target.x) / 2, (y + target.y) / 2, string(distance.goal_dist) + "m");
	draw_text((x + target.x) / 2, ((y + target.y) / 2) + 16, string(distance.angle) + "°");
}

#endregion DEBUG