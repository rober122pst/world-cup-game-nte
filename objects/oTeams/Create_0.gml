teams = [
    { 
		_id: 0, 
		name: "Brasil",
		curiosities: [
			"Dono da Amazônia! O Brasil tem mais de 20% da variedade de vida do planeta e a maior reserva de água doce do mundo.",
			"O nome Brasil vem de uma árvore! O Pau-Brasil tem a madeira vermelha brilhante, parecida com uma brasa de fogueira.",
			"O Brasil é o único país que jogou todas as Copas do Mundo e o único que já ganhou cinco troféus, o último em 2002.",
			"No Amapá, a linha do meio-campo de um estádio fica bem em cima do Equador! Cada time joga em um lado do planeta.",
			"Muita gente! Com mais de 217 milhões de pessoas, o nosso país é o sétimo mais populoso de todo o mundo.",
		],	
	},
    { 
		_id: 1,
		name: "Argentina",
		curiosities: [
			"Lá se fala espanhol! A vizinha Argentina é o maior país que fala essa língua em toda a América do Sul.",
			"O Aconcágua é a montanha mais alta da América do Sul! Ela fica nos Andes argentinos e tem gigantescos 6.962 metros.",
			"O esporte nacional deles se chama 'pato'! É um jogo parecido com o polo, mas eles também amam futebol e basquete.",
			"A Argentina já ganhou a Copa do Mundo 3 vezes! De lá saíram craques incríveis e famosos como Maradona e Messi.",
			"O TANGO é uma dança super famosa e tradicional da Argentina. Ela nasceu na cidade de Buenos Aires faz muito tempo!",
		],
	},
    { 
		_id: 2,
		name: "França",
		curiosities: [
			"Os franceses comem cerca de 30.000 toneladas de caracóis por ano! Isso pesa o mesmo que 200 baleias azuis juntas.",
			"A França é o país que mais recebe turistas no mundo inteirinho! Eles seguram esse recorde há mais de 30 anos.",
			"A Torre Eiffel fica em Paris e é chamada de 'Dama de Ferro'. Ela é incrivelmente alta, com 324 metros de altura!",
			"Quanta vida! A França tem mais de 140 espécies de mamíferos, 600 de aves e milhares de tipos de insetos diferentes.",
			"Os franceses adoram praticar esportes! O futebol e as corridas de bicicleta são os favoritos de quem mora lá.",
		],
	},
    { 
		_id: 3, 
		name: "Canadá",
		curiosities: [
			"O Canadá e os EUA compartilham a fronteira internacional mais longa do mundo.",
			"O Canadá está entre os países com o maior número de ilhas, ficando logo atrás da Suécia, Noruega e Finlândia.",
			"A taxa de alfabetização do Canadá é de 99%.",
			"O Canadá foi fundamental para a ciência: em 1922, cientistas de Toronto descobriram a insulina, um remédio que salva milhões de vidas até hoje.",
			"É o país com mais lagos do mundo! São mais de 2 milhões, o que faz dele o dono de uma enorme parte da água doce do planeta.",
		],
	},
    {
		_id: 4, 
		name: "EUA",
		curiosities: [
			"Pegadas na Lua! Sabia que os 12 astronautas que andaram na Lua eram americanos? Eles foram enviados pela NASA até 1972.",
			"Os EUA são gigantes! Eles são o segundo maior país do continente norte-americano, ficando atrás apenas do Canadá.",
			"A bandeira de lá tem 13 listras (das primeiras colônias) e 50 estrelas brilhantes, que representam os 50 estados dos EUA.",
			"Os EUA são o 3º país mais populoso do mundo, atrás da China e da Índia. Lá moram cerca de 346 milhões de pessoas.",
			"Nova Iorque é a maior cidade dos EUA! É um lugar super movimentado onde moram quase 8,4 milhões de habitantes.",
		],
	},
    {
		_id: 5,
		name: "México",
		curiosities: [
			"O México é tão grande de lado que tem quatro fusos horários diferentes: Noroeste, Pacífico, Montanha e Centro.",
			"O cacto cardon é o maior do mundo! Ele chega a 21 metros de altura no deserto, é super gigante e vive até 300 anos!",
			"O México é o país com mais pessoas falando espanhol no MUNDO! Tem mais gente falando espanhol lá do que na própria Espanha.",
			"Nos dias 1 e 2 de novembro tem o Dia de los Muertos! É uma festa super colorida para lembrar com carinho da família.",
			"Ideia genial! Você sabia que o chocolate quente era considerado uma bebida sagrada pelos antigos povos astecas?",
		],
	}
];
teams_selected = [];

set_teams = function (team_h, team_a) {
	teams_selected = [teams[team_h], teams[team_a]];
	return teams_selected;
}

get_team_name = function (_team_id) {
	return teams[_team_id].name;
}

get_team_curiosity = function (_team_name) {
	team_name = _team_name;
	var team = array_filter(teams, function(element) { return element.name == team_name })[0];
	var _index = irandom_range(0, array_length(team.curiosities) - 1);
	var curiosity = team.curiosities[_index];
	array_delete(teams[team._id].curiosities, _index, 1);
	return { _id: team._id, curiosity };
}

get_team_id = function (_team_name) {
	team_name = _team_name;
	var _f = function (_element, _index) {
		return _element.name == team_name;	
	}
	return array_find_index(teams, _f);	
}