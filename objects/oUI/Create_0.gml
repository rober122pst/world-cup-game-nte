view_width = view_get_wport(0);
view_height = view_get_hport(0);

view_center = view_width / 2;
view_middle = view_height / 2;

scale = round(view_height / camera_get_view_height(view_camera[0]));

font_score = font_add_sprite_ext(sprScoreFont, "1234567890", true, 4);
font_time = font_add_sprite_ext(sprTimeFont, "0123456789:", true, 1);
font = font_add_sprite_ext(sprBitmap, " !\"#$%&'()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_{|}~ÇÉÂÁÊÈÔÒÛÙ", true, 0);

anim_time = 0;
anim_frame = 0;
anim_fps = 14;

function two_digits(n)
{
    return (n < 10 ? "0" : "") + string(n);
}