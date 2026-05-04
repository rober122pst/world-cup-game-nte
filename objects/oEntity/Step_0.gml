if (object_index != oPlayer) ai_tree.evaluate(id);

with (oBar) {
	if (team != other.my_team) {
		other.target = id;
		break;
	}
}