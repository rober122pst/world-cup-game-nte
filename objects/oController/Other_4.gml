var ball = instance_create_layer(global.field_middle, global.field_center_y, "Instances", oBall);

var home_1 = instance_create_layer(global.field_middle, global.field_center_y - 2, "Instances", oTeamPlayer);
var home_2 = instance_create_layer(global.field_middle - 32, global.field_center_y, "Instances", oTeamPlayer);

var away_1 = instance_create_layer(global.field_middle + 32, global.field_center_y - 32, "Instances", oOpponentPlayer);
var away_2 = instance_create_layer(global.field_middle + 32, global.field_center_y + 32, "Instances", oOpponentPlayer);

switch (global.match_state) {
	case MATCH_STATE.STARTING:
		break;
	case MATCH_STATE.GOAL:
		global.match_state = MATCH_STATE.PLAYING;
		
		break;
}

