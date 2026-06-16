if (!audio_is_playing(canal_musica) && estado == "tocando")
{
    // passa para a próxima
    musica_index++;

    // se chegou no final, volta para a primeira
    if (musica_index >= array_length(musicas))
    {
        musica_index = 0;
    }

    var proxima = audio_play_sound(
        musicas[musica_index],
        1,
        false
    );

    audio_sound_gain(proxima, 0, 0);

    musica_antiga = canal_musica;
    canal_musica = proxima;

    estado = "transicao";
}

if (estado == "transicao")
{
    var vol_nova = audio_sound_get_gain(canal_musica);
    var vol_velha = audio_sound_get_gain(musica_antiga);

    vol_nova += 0.01;
    vol_velha -= 0.01;
	show_debug_message("Velha {0}, Nova {1}", vol_velha, vol_nova)

    audio_sound_gain(canal_musica, vol_nova, 0);
    audio_sound_gain(musica_antiga, vol_velha, 0);


    if (vol_velha <= 0)
    {
        audio_stop_sound(musica_antiga);
        estado = "tocando";
    }
}

show_debug_message(estado)