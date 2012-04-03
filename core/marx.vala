using Clutter;
using Gee;

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

		scroller = new Scroller(this);
		stage.add_actor(scroller);

		text = new Text.full ("Droid Sans Mono 10",
							  "",
							  theme.text);
		text.x = 0;
		text.y = 0;
		scroller.add_actor(text);

		cursors = new LinkedList<Cursor>();

		stage.key_press_event.connect(handle_key_press);
		stage.key_release_event.connect(handle_key_release);
	}

	private void init_debug() {
		open_file("README.md");

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
		if(event.keyval == Key.Escape) {
			main_quit();
		} else if(event.keyval == Key.Page_Up) {
			scroller.scrolling(false, true);
		} else if(event.keyval == Key.Page_Down) {
			scroller.scrolling(true, true);
		} else if(event.keyval == Key.space) {
			scroller.show_debug();
		} else {
			debug_key_event(event);
		}
		return true;
	}

	public bool handle_key_release(KeyEvent event) {
		if(event.keyval == Key.Page_Up) {
			scroller.scrolling(false, false);
		} else if(event.keyval == Key.Page_Down) {
			scroller.scrolling(true, false);
		}
		return true;
	}

	public void debug_key_event(KeyEvent event) {
		stderr.printf("Got key event:\n modifiers %ux\n", (uint)event.modifier_state);
	}

	public Stage stage;
	public Theme theme;
	public Scroller scroller;
	public Text text;
	public LinkedList<Cursor> cursors;
	
}