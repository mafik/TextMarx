using Clutter;

class Marx.Cursor : Rectangle {
	public int offset { get; set; default = 0; }

	private Marx.Window window;

	public Cursor(Marx.Window _window) {
		window = _window;
		color = window.theme.cursor;
		width = 2;
		notify["offset"].connect(reposition);
		window.scroller.add_actor(this);
		window.cursors.add(this);
	}

	public void reposition() {
		float line_height, _x, _y;
		
		if(window.text.position_to_coords(offset, out _x, out _y, out line_height)) {
			x = _x; y = _y; height = line_height;
		}
	}
}
