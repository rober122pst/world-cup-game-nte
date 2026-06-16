musicas = [
    sndStadiumCrowd,
    sndStadiumCrowd2,
];

musica_index = 0;

canal_musica = audio_play_sound(
    musicas[musica_index],
    1,
    false
);

volume = 1;
estado = "tocando";