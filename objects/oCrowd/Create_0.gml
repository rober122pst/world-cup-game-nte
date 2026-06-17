// Garante que a aleatoriedade seja diferente a cada vez que o jogo abrir
randomize();

// Coloque aqui o nome exato dos seus arquivos de áudio
torcidas = [sndStadiumCrowd, sndStadiumCrowd2, sndStadiumCrowd3];

// Sorteia o primeiro áudio
indice_atual = irandom(array_length(torcidas) - 1);

// Toca o som inicial em loop (true)
som_atual = audio_play_sound(torcidas[indice_atual], 1, true);

// Força o som a começar no volume 0, e depois subir para 1 em 3000ms (3 segundos)
audio_sound_gain(som_atual, 0, 0);
audio_sound_gain(som_atual, 1, 3000); 

som_antigo = -1;
timer_fade_out = 0;

// Define o tempo para a próxima troca de áudio (Ex: entre 15 e 30 segundos)
timer_troca = game_get_speed(gamespeed_fps) * irandom_range(15, 25);