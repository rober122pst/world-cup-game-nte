// By michael-mcmullen on github (modificações por Rober122)
// https://github.com/GamemakerCasts/behaviour-trees

function DecisionNode(_conditionFunc, _trueBranch, _falseBranch) constructor {
    condition = _conditionFunc;
    true_branch = _trueBranch;
    false_branch = _falseBranch;

    function evaluate(_actor) {
		
        if (condition(_actor)) {
            return true_branch.evaluate(_actor);
        } else {
            return false_branch.evaluate(_actor);
        }
    }
}

function ActionNode(_actionFunc, _cooldownMs = 0, _durationFrames = 0) constructor {
    action = _actionFunc;
	cooldown = _cooldownMs // em ms
	last_execution = -_cooldownMs;
	duration = _durationFrames;

    function evaluate(_actor) {
		if (current_time - last_execution >= cooldown) {
			last_execution = current_time;
			if (!_actor.is_busy) {
				_actor.is_busy = true;
				_actor.busy_timer = duration;
			}
			return self;
		}
    }
	
	function execute_logic(_actor) {
		action(_actor);	
	}
}