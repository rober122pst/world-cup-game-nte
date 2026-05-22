function get_shirt(_team){
	var _origin_black = [
		0, 0, 0, 1.0,
	]
	
	var _origin_base = [
		255/255, 0, 0, 1.0, // Vermelho base
		219/255, 0, 0, 1.0, // Vermelho médio
		178/255, 0, 0, 1.0, // Vermelho escuro
	];
	
	var _origin_second = [
		4/255, 0, 255/255, 1.0, // Azul base
		3/255, 0, 210/255, 1.0, // Azul médio
		3/255, 0, 181/255, 1.0, // Azul escuro 
	];
	
	var _origin_third = [
		255/255, 0, 238/255, 1.0, // Roxo
	];
	
	var _origin_fourth = [
		255/255, 238,255, 0, 1.0, // Amarelo	
	];
	
	var _origin_badge = [
		13/255, 255/255, 0, 1.0, // Verde
	];
	
	//////////////////////////////////////////
	
	var _yellow = [
		227/255, 209/255, 118/255, 1.0, // Amarelo base
		204/255, 180/255, 92/255, 1.0, // Amarelo médio
		186/255, 151/255, 69/255, 1.0, // Amarelo Escuro
	];
	
	var _green = [
		109/255, 135/255, 64/255, 1.0, // Verde base
		75/255, 108/255, 46/255, 1.0, // Verde médio
		50/255, 87/255, 29/255, 1.0, // Verde escuro
	]
	
	var _white = [
		235/255, 240/255, 238/255, 1.0, // Branco base
		212/255, 208/255, 205/255, 1.0, // Branco médio
		181/255, 178/255, 172/255, 1.0, // Branco escuro
	]
	
	var _sky_blue = [
		140/255, 186/255, 222/255, 1.0,
		112/255, 159/255, 207/255, 1.0,
		87/255, 130/255, 186/255, 1.0,
	];
	
	var _black = [
		47/255, 59/255, 61/255, 1.0, // Contorno
	]
	
	new_colors = [];
	origin_colors = [];
	sprite_idle = noone;
	sprite_walk = noone;

	switch (_team) {
		case "Brazil":
			new_colors = array_concat(_yellow, _green, [109/255, 135/255, 64/255, 1.0, /* Verde base*/], _black);
			origin_colors = array_concat(_origin_base, _origin_second, _origin_badge, _origin_black);
			sprite_idle = sprShirtPatternDefault;
			sprite_walk = sprShirtPatternDefaultWalk;
			
			break;
		case "Argentina":
			var badge = [];
			array_copy(badge, 0, _yellow, 0, 4);
			new_colors = array_concat(_white, _sky_blue, badge, _black);
			origin_colors = array_concat(_origin_base, _origin_second, _origin_badge, _origin_black);
			sprite_idle = sprShirtPatternVerticalThin;
			sprite_walk = sprShirtPatternVerticalThinWalk;
			
			break;
	}
	
	return { new_colors, origin_colors, sprite_idle, sprite_walk };
}