x = lerp(x, oBall.x, .05);

camera_set_view_pos(cam, clamp(x - cam_width / 2, 0, room_width - cam_width), y);