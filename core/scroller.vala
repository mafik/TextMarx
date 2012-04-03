using Clutter;

class Marx.Scroller : Group {

	public Window master_window;

	private bool scrolling_up;
	private bool scrolling_down;

	public enum State {
		STOPPED,
		EXPONENTIAL,
		ELASTIC,
		DAMPED
	}

	public State scroll_state;
	//public Animator animator;
	private uint handler;

	// for exponential scrolling
	public float velocity;
	public float force;

	// for elastic scrolling
	public float destination;

	// for damped scrolling

	public Scroller(Window window) {
		master_window = window;
		scroll_state = State.STOPPED;
		handler = 0;
		scrolling_up = scrolling_down = false;
	}

	public float get_max_scroll() {
		return height - master_window.line_height;
	}

	public void scrolling(bool forward, bool state) {
		if(state) {
			if(forward && scrolling_up) return;
			if(!forward && scrolling_down) return;

			if(forward) scrolling_up = true;
			else scrolling_down = true;

			scroll_state = State.EXPONENTIAL;
			force = state ? (forward ? -1 : 1) : 0;
			velocity += force * 10;
			start();
		} else {

			if(forward) scrolling_up = false;
			else scrolling_down = false;

			if(scroll_state == State.EXPONENTIAL) {
				scroll_state = State.STOPPED;
				velocity = 0;
			}
		}
	}

	private void start() {
		if(handler == 0)
			handler = Threads.FrameSource.add(50, scroll_frame);
	}

	// Invoke only as a return value from scroll_frame!
	private bool end() {
		scroll_state = State.STOPPED;
		force = 0;
		velocity = 0;
		handler = 0;
		return false;
	}

	private bool scroll_frame() {
		//stderr.printf("Velocity: %f  Force: %f  State: %s\n", velocity, force, scroll_state.to_string());

		switch(scroll_state) {
		case State.EXPONENTIAL:
			velocity += force;
			velocity *= 1.01f;
			y += (float)(int)velocity;
			if(y > 0) {
				destination = 0;
				scroll_state = State.ELASTIC;
			} else if(y < -get_max_scroll()) {
				destination = -get_max_scroll();
				scroll_state = State.ELASTIC;
			}
			return true;
		case State.ELASTIC:
			force = (destination - y)/4;
			velocity += force;
			velocity *= 0.6f;
			y += (float)(int)velocity;
			if(force * force + velocity * velocity > 1) {
				return true;
			} else {
				y = (float)(int)destination;
			}
			break;
		case State.DAMPED:
			float distance = (destination - y) / 4;

			y += (float)(int) distance;

			if(distance*distance >= 1) {
				return true;
			} else {
				y = (float)(int)destination;
			}
			break;
		}
		return end();
	}
	
	public void show_debug() {
		stderr.puts("Scroller state:\n");
		stderr.printf("    x: %.1f \t y: %.1f\n", x, y);
		stderr.printf("    w: %.1f \t h: %.1f\n", width, height);
		
	}

	//public void scroll_to_row(int row) {
	//}

	public void scroll_home() {
		scroll_state = State.ELASTIC;
		destination = 0;
		start();
	}

	public void scroll_end() {
		scroll_state = State.ELASTIC;
		destination = -get_max_scroll();
		start();
	}

	public enum StepSize {
		LINE,
		A_FEW_LINES,
		PAGE
	}

	public void scroll_step(bool forward, StepSize step_size) {
		if((scroll_state != State.DAMPED) &&
		   (scroll_state != State.ELASTIC)) {
			destination = y;
		}
		scroll_state = State.DAMPED;
		switch(step_size) {
		case StepSize.LINE:
			destination += master_window.line_height * (forward ? -1 : 1);
			break;
		case StepSize.A_FEW_LINES:
			destination += master_window.line_height * 5 * (forward ? -1 : 1);
			break;
		case StepSize.PAGE:
			destination += master_window.stage.height * (forward ? -1 : 1);
			break;
		}
		destination = destination.clamp(-get_max_scroll(), 0);
		start();
	}
}