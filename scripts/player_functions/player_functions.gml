function player_move() {
	if (dx != 0 || dy != 0) {
		var _input_dist = point_distance(0, 0, dx, dy);
		angle = point_direction(0, 0, dx, dy);

		hspd += (dx / _input_dist) * acc;
		vspd += (dy / _input_dist) * acc;

		var _current_vel = point_distance(0, 0, hspd, vspd);
		if (_current_vel >= max_spd) {
			hspd = (hspd / _current_vel) * max_spd;
			vspd = (vspd / _current_vel) * max_spd;
		}
	} else {
		hspd = lerp(hspd, 0, fric);
		vspd = lerp(vspd, 0, fric);
	}

	y += vspd * global.dt;
	x += hspd * global.dt;

	if (abs(hspd) <= .1 && abs(vspd) <= .1) {
		sprite_index = sprPlayerIdleSide;
	} else {
		sprite_index = sprPlayerSide;
	}

	if (dx != 0)
		image_xscale = dx;
} 

function go_to_ball (_actor) {
	with (_actor) {
		decision = "Indo atras da bola";
		dx = sign(oBall.x - x);
		dy = sign(oBall.y - y);
		
		player_move();
	}
}

function increment_shoot_force(_actor) {
	if(_actor.current_shoot_state == SHOOT_STATE.SHOOTING) {
		_actor.force += _actor.increment_force*global.dt;

		if(_actor.force >= _actor.max_force) {
			_actor.force = _actor.max_force;
			_actor.current_shoot_state = SHOOT_STATE.SHOT;
			shot();
		}
	}
}

function shot(_actor = self) {
	with (_actor) {
		has_ball = false;
		global.with_poss = noone;
	
		with (oBall) {
			owner = noone;
			speed = other.force;
			direction = other.angle;
			other.x_init = x;
			other.y_init = y;
		}
	
		if (force >= max_force*.75)
			oBall.jump = true;
	
		current_shoot_state = SHOOT_STATE.FREEZE;
	
		state = free_state;
	}
}

function pass(_actor) {
	with (_actor) {	
		decision = "Passando";
		
		var nearest = nearest_teamplayer(teamplayer_obj);
		
		force = ( nearest.distance*max_force ) / 375 // 375 é a distancia maxima que a bola vai
		show_debug_message(nearest);
		angle = point_direction(x, y, nearest.teamplayer.x, nearest.teamplayer.y);
		
		shot();	
	}
}

function get_back(_actor) {
	with (_actor) {
		decision = "Voltando";
	
		var _margin = 2; // Margem de erro

		if (abs(x - target.x) > _margin) {
		    dx = sign(target.x - x);
		} else {
		    dx = sign(target.x); // Snap para a posição final
		}

		if (abs(y - target.y) > _margin) {
		    dy = sign(target.y - y);
		} else {
		    dy = sign(target.y);
		}
	
		player_move();
	}
}

function go_to_goal(_actor) {
	with (_actor) {
		decision = "Indo pro gol";
		
		player_move();
		
		var _threshold = 5; // Margem de tolerância (1 pixel costuma bastar)

		// Lógica para o Eixo X
		if (abs(target.x - x) > _threshold) {
		    dx = sign(target.x - x);
		} else {
		    dx = 0;
		    x = target.x; // "Snap" para o valor exato para limpar o resto
		}

		// Lógica para o Eixo Y (Onde está o seu problema)
		if (abs(target.y - y) > _threshold) {
		    dy = sign(target.y - y);
		} else {
		    dy = 0;
		    y = target.y; // Garante que ele fique cravado no 100
		}
	
		
	}
}

function press_opponent(_actor) {
	with (_actor) {
		decision = "Pressionando/Cercando";
		
		var press_infos = is_free_to_press(id);
		
		var dist_to_target = point_distance(x, y, press_infos.target_x, press_infos.target_y);
		
		// Se estiver um pouco longe, vai na direção da bola.
		if (dist_to_target > 5) { 
			dx = sign(press_infos.target_x - x); // [cite: 7]
			dy = sign(press_infos.target_y - y); // [cite: 8]
		} else {
			dx = 0; 
			dy = 0; 
		}
		
		player_move();
	}
}
function go_to_position(_actor) {
	with (_actor) {
		decision = "Mantendo Posição";
		
		// Usamos a posição inicial de spawn como "âncora" para manter o esquema 1-2-2 
		var target_x = initial_x;
		var target_y = initial_y;
		
		// Dinâmica básica de linha: se o time tá com a bola, a linha sobe. Se não, recua.
		if (is_team_with_pos()) { // [cite: 31]
			target_x += 100 * sign(global.field_middle - target_x); // time avança em bloco
		}
		
		// Movimenta até o target_x e target_y (usando a mesma lógica de "snap" do seu go_to_goal) [cite: 17, 18, 19, 20, 21]
		var _margin = 5;
		if (abs(target_x - x) > _margin) dx = sign(target_x - x); else dx = 0;
		if (abs(target_y - y) > _margin) dy = sign(target_y - y); else dy = 0;
		
		player_move(); // [cite: 1]
	}
}

function freeze(_actor) {
	with (_actor) {
		sprite_index = sprPlayerIdleSide;
		x += .6 * -image_xscale;
		if (!set_alarm) {
			alarm[1] = max(((game_get_speed(gamespeed_fps) * .75) * force) / max_force, 1);
			force = 0;
			set_alarm = true;
		}	
	}
}

