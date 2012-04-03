using Clutter;

class Marx.Scroller : Group {

	public Window master_window;

	enum State {
		STOPPED,
		EXPONENTIAL,
		ELASTIC,
		DAMPED
	}

	public State scroll_state;
	public Animator animator;
	private uint handler;

	// for exponential scrolling
	public float velocity;
	public float force;

	// for elastic scrolling

	// for damped scrolling

	public Scroller(Window window) {
		master_window = window;
		scroll_state = State.STOPPED;
		handler = 0;
	}

	public void scrolling(bool forward, bool state) {
		scroll_state = state ? EXPONENTIAL : STOPPED;
		force = state ? (forward ? 1 : -1) : 0;
		if(state) start();
	}

	private void start() {
		if(handler == 0)
			handler = Threads.FrameSource.add(50, scroll_frame);
	}

	private bool scroll_frame() {
		step += 1;
		stderr.printf("Continuing towards %d with step %d\n", (int)is_scrolling_forward, step);
		velocity += force;
		y += velocity;
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