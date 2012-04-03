using Clutter;

class Marx.Cursor : Rectangle {
	public int offset { get; set; default = 0; }

	public Marx.Window master_window;
	public Clutter.Rectangle bar;

	public Cursor(Marx.Window window) {
		master_window = window;

		bar = new Rectangle();
		bar.color = master_window.theme.cursor;
		bar.width = 2;

		notify["offset"].connect(reposition);

		master_window.scroller.add_actor(bar);
		master_window.cursors.add(this);
	}

	public void reposition() {
		float line_height, x, y;
		
		if(master_window
		   .text
		   .position_to_coords(offset, out x, out y, out line_height)) {
			bar.x = x; 
			bar.y = y; 
			bar.height = line_height;
		}
	}
}
