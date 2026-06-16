anim_time += delta_time / 1000000;

var frame_delay = 1 / anim_fps;

while (anim_time >= frame_delay) {
    anim_time -= frame_delay;
    anim_frame = (anim_frame + 1) mod sprite_get_number(sprGoalText);
}
