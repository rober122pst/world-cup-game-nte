// Reduz o timer principal
timer_troca--;

// Se for a hora de mudar de áudio
if (timer_troca <= 0) {
    
    // SÓ atualiza o som_antigo se o som_atual realmente existir
    if (audio_exists(som_atual)) {
        som_antigo = som_atual;
        audio_sound_gain(som_antigo, 0, 3000); 
        timer_fade_out = game_get_speed(gamespeed_fps) * 3; 
    }

    // Escolhe um novo áudio, garantindo que NÃO seja o mesmo
    var novo_indice;
    do {
        novo_indice = irandom(array_length(torcidas) - 1);
    } until (novo_indice != indice_atual);
    
    indice_atual = novo_indice;

    // Garante que o asset do áudio sorteado existe antes de dar o play
    if (audio_exists(torcidas[indice_atual])) {
        som_atual = audio_play_sound(torcidas[indice_atual], 1, true);
        audio_sound_gain(som_atual, 0, 0);
        audio_sound_gain(som_atual, 1, 3000);
    }

    // Reseta o timer principal para a próxima troca (entre 15 e 30 seg)
    timer_troca = game_get_speed(gamespeed_fps) * irandom_range(15, 25);
}

// Limpeza de Memória: Para o áudio antigo com segurança
if (timer_fade_out > 0) {
    timer_fade_out--;
    
    if (timer_fade_out <= 0) {
        // Verifica se o som ainda está ativo na memória antes de parar
        if (audio_exists(som_antigo) && audio_is_playing(som_antigo)) {
            audio_stop_sound(som_antigo);
        }
        som_antigo = -1; // Reseta a variável por segurança
    }
}