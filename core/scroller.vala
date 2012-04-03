using Clutter;

class Marx.Scroller : Group {
	public Window master_window;

	enum State {
		EXPONENTIAL,
		ELASTIC,
		DAMPED
	}

	public bool is_scrolling_forward;
	public bool is_scrolling;

	public int step;

	public Animator animator;

	public Scroller(Window window) {
		master_window = window;
	}

	public void scrolling(bool forward, bool state) {
		if((is_scrolling == state) &&
		   (is_scrolling_forward == forward)) return;
		is_scrolling = state;
		is_scrolling_forward = forward;
		if(state) {
			step = 0;
			continue_scrolling();
		} else {
			stderr.printf("Ending!\n");
			animator.timeline.stop();
			
		}
	}

	private float get_step_size() {
		return (float)(Math.pow(step, 2) + 10);
	}

	private bool scroll_frame() {
		step += 1;
		stderr.printf("Continuing towards %d with step %d\n", (int)is_scrolling_forward, step);
		float new_y = y + (is_scrolling_forward ? -get_step_size() : get_step_size());
		AnimationMode mode = (step == 1 ? AnimationMode.EASE_IN_QUAD : AnimationMode.LINEAR);

		animator = new Animator();
		
		if(new_y > 0) {
			animator.set_key(this, "y", mode, 0, y);
			animator.set_key(this, "y", AnimationMode.EASE_OUT_ELASTIC, 1, (float)0);
			animator.set_duration(500);
		} else {
			animator.set_key(this, "y", mode, 0, y);
			animator.set_key(this, "y", mode, 1, (float)(int)new_y);
			animator.set_duration(100);
		}

		
		animator.timeline.completed.connect(continue_scrolling);
		animator.start();
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