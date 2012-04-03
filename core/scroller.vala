using Clutter;

class Marx.Scroller : Group {

	public Window master_window;

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
	}

	public void scrolling(bool forward, bool state) {
		if(scroll_state != State.STOPPED && state) return;

		if(state) {
			scroll_state = State.EXPONENTIAL;
			force = state ? (forward ? -1 : 1) : 0;
			velocity += force * 10;
			start();
		} else if(scroll_state == State.EXPONENTIAL) {
			scroll_state = State.STOPPED;
			velocity = 0;
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
		stderr.printf("Velocity: %f  Force: %f  State: %s\n", velocity, force, scroll_state.to_string());

		if(scroll_state == State.EXPONENTIAL) {
			velocity += force;
			velocity *= 1.01f;
			y += (float)(int)velocity;
			if(y > 0) {
				destination = 0;
				scroll_state = State.ELASTIC;
			} else if(y < -height + 50) {
				destination = -height + 50;
				scroll_state = State.ELASTIC;
			}
			return true;
		} else if(scroll_state == State.ELASTIC) {
			force = (destination - y)/2;
			velocity += force;
			velocity *= 0.7f;
			y += (float)(int)velocity;
			if(force * force + velocity * velocity > 1) {
				return true;
			} else {
				stderr.printf("Elastic ended!\n");
				y = (float)(int)destination;
				return end();
			}
		} else {
			return end();
		}
	}
	
	public void show_debug() {
		stderr.puts("Scroller state:\n");
		stderr.printf("    x: %.1f \t y: %.1f\n", x, y);
		stderr.printf("    w: %.1f \t h: %.1f\n", width, height);
		
	}

	//public void scroll_to_row(int row) {
	//}

	//public enum StepSize {
	//LINE,
	//A_FEW_LINES,
	//PAGE
	//}

	//public void scroll_step() {	
	//}
}