
if (global.player_controlling.id == other.id) {
	array_push(global.collected, text);
	audio_play_sound(sndCollect, 1, 0);
	instance_destroy();	
}