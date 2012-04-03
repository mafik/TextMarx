using Clutter;
using Gee;

class Marx.Theme : Object {
	public Color background {
		get; set; default = Color.from_pixel( (uint32) 0xedecebff );
	}

	public Color background_light {
		get; set; default = Color.from_hls( 0, 0.9f, 1 );
	}

	public Color text {
		get; set; default = Color.from_pixel( (uint32) 0x3f3f3fff );
	}

	public Color cursor {
		get; set; default = Color.from_hls( 0, 0.5f, 1 );
	}

	public Color selection {
		get; set; default = Color.from_hls( 180, 0.5f, 1 );
	}

	public Color fix_alpha(Color c) {
		c.alpha = 255;
		return c;
	}

	public Theme() {
		text = fix_alpha(text);
		background = fix_alpha(background);
		background_light = fix_alpha(background_light);

		var c = cursor;
		c.alpha = 0xc0;
		cursor = c;

		c = selection;
		c.alpha = 0x80;
		selection = c;
	}
}

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

class Marx.Window : Object {

    public static int main(string[] args) {
		if(Clutter.init(ref args) != InitError.SUCCESS) {
			stderr.printf("Clutter initialization failed!\n");
			return 1;
		}
        var window = new Window();
		window.stage.destroy.connect(Clutter.main_quit);
		Clutter.main();
        return 0;
    }

	private void init_basic() {
		theme = new Theme();

		stage = new Stage();
		stage.set_color(theme.background);
		stage.set_user_resizable(true);
		stage.title = "Te✯tMarx";
		stage.show_all();

		scroller = new Group();
		stage.add_actor(scroller);

		text = new Text.full ("Droid Sans Mono 10",
							  "",
							  theme.text);
		text.x = 0;
		text.y = 0;
		scroller.add_actor(text);

		cursors = new LinkedList<Cursor>();

		stage.key_press_event.connect(handle_key_press);
	}

	private void init_debug() {
		open_file("marx.vala");

		Cursor c = new Cursor(this);
		c.offset = 100;
	}

	public Window() {
		init_basic();
		init_debug();
	}

	public void open_file(string path) {
		var file = File.new_for_path(path);
		DataInputStream dis;
		size_t length;
		string data;
		try {
			dis = new DataInputStream (file.read ());
			data = dis.read_until("\0", out length);
		} catch(Error e) {
			data = e.message;
		}
		text.text = data;
	}

	public bool handle_key_press(KeyEvent event) {
		//stderr.printf("%ud\n", (uint)event.modifier_state);
		if(event.keyval == Key.Escape) {
			main_quit();
		} /*else if(event.keyval == Key.Right) {
			foreach(Cursor c in cursors) {
				c.offset++;
			}
		} else if(event.keyval == Key.Left) {
			foreach(Cursor c in cursors) {
				c.offset--;
			}
			}*/
		return true;
	}

	public Stage stage;
	public Theme theme;
	public Group scroller;
	public Text text;
	public LinkedList<Cursor> cursors;
	
}