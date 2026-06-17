// Inherit the parent event
event_inherited();

var whistle = audio_play_sound(sndWhistleRefree, 10, 0, 1, 3.75);
audio_sound_gain(whistle, 0, 1500);