teams = [
    { _id: 0, name: "Brasil" },
    { _id: 1, name: "Argentina" },
    { _id: 2, name: "França" },
    { _id: 3, name: "Canadá" },
    { _id: 4, name: "EUA" },
    { _id: 5, name: "México" }
];
teams_selected = [];

set_teams = function (team_h, team_a) {
	teams_selected = [teams[team_h], teams[team_a]];
	return teams_selected;
}

get_team_name = function (team_id) {
	if (team_id >= array_length(teams)) return "Desconhecido";
	for (var i = 0; i < array_length(teams); i++) {
		if (i == team_id) return teams[i].name;	
	}
}