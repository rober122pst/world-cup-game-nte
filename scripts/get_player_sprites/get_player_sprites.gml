
function get_player_sprites() {
	if(KEY_RIGHT) {
		sprite_index = sprPlayerSide;
		image_xscale = -1;
	}else if(KEY_LEFT) {
		sprite_index = sprPlayerSide;
		image_xscale = 1;
	}else if(KEY_UP) {
		sprite_index = sprPlayerUp;
		image_xscale = 1;
	}else if(KEY_DOWN) {
		sprite_index = sprPlayerDown;
		image_xscale = 1;
	}
}