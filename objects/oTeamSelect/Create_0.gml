randomise();

team_lenght = sprite_get_number(sprFlags);
flags = [];

var flag_width = sprite_get_width(sprFlags);
var flag_height = sprite_get_height(sprFlags);

var container_width = flag_width*team_lenght;
var xx = (camera_get_view_width(view_camera[0])/2) - (container_width/2)
var yy = (camera_get_view_height(view_camera[0])/2) - (flag_height/2);

for (var i = 0; i < team_lenght; i++) {
	var flag = instance_create_layer(xx + i*flag_width, yy, "Instances", oFlag, {
		image_index: i
	});
	
	array_push(flags, flag);
}

font = font_add_sprite_ext(sprBitmap, " !\"#$%&'()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_{|}~ÇÉÂÁÊÈÔÒÛÙ", true, 0);

select = 0;