var _max_height = 70;
var _shadow_scale = 1 - (abs(z) / _max_height);

var xx = x - ceil((sprite_width*_shadow_scale) / 2);
var xx1 = x + floor((sprite_width*_shadow_scale) / 2);

draw_set_alpha(.8 - (abs(z) / _max_height));
draw_set_colour(#2f3b3d);
draw_ellipse(xx, y, xx1, y + 3, false);
draw_set_alpha(1);
draw_set_colour(c_white);

draw_sprite_ext(sprBall, 0, x, y + z, image_xscale, image_yscale, 0, c_white, 1);