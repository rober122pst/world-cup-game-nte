var _max_height = 70;
var _shadow_scale = 1 - (abs(z) / _max_height);

draw_set_alpha(.8 - (abs(z) / _max_height));
draw_set_colour(#2f3b3d);
draw_ellipse(x - 8, y - 3, x + 7, y + 1, false);
draw_set_alpha(1);
draw_set_colour(c_white);

draw_self();

if(current_shoot_state == SHOOT_STATE.SHOOTING) {
	draw_healthbar(x-8,y-20,x+8,y-19,(force/max_force)*100,c_black,c_red,c_green,0,1,1);	
}

var u_numColors = shader_get_uniform(shd_palette_swap, "u_numColors");
var u_orig = shader_get_uniform(shd_palette_swap, "u_colorOrig");
var u_new = shader_get_uniform(shd_palette_swap, "u_colorNew");

shader_set(shd_palette_swap);
    shader_set_uniform_i(u_numColors, array_length(shirt.origin_colors) / 4);
    shader_set_uniform_f_array(u_orig, shirt.origin_colors);
    shader_set_uniform_f_array(u_new, shirt.new_colors);
        
    draw_sprite_ext(sprite_index == sprPlayerIdleSide ? shirt.sprite_idle : shirt.sprite_walk, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
shader_reset();
#region DEBUG

if (global.debug) {
	if (target != noone && instance_exists(target)) {
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

	var _radius = 16;
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
	
	draw_text(x, y-5, decision);
}
#endregion DEBUG
