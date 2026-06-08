if (other.top_post != noone && other.bottom_post != noone) {
	var _goal_height_z = -24;
	var _top_y = min(other.top_post.y, other.bottom_post.y) + 6;
	var _bottom_y = max(other.top_post.y, other.bottom_post.y) - 6;
	var _inside_mouth = y >= _top_y && y <= _bottom_y;
	var _under_crossbar = z > _goal_height_z + 3;
	var _near_goal_line = abs(x - other.x) <= 10;

	if (_inside_mouth && _under_crossbar && _near_goal_line) {
		show_debug_message("Gol!");
		room_restart();
	}
}
