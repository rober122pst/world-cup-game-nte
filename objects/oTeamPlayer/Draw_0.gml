// Inherit the parent event
event_inherited();

if (global.player_controlling == id) {
	draw_sprite(sprPlayerIndicator, (current_time div 500) % 2, x, y - 16)	
}