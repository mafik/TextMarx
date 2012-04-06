using Clutter;

abstract class Marx.Action {
	public abstract bool make(Text text, Cursor cursor);
	public abstract bool undo(Text text, Cursor cursor);
}

class Marx.Actions.Unicode : Action {
	public unichar c;

	public Unicode(unichar character) {
		c = character;
	}

	public override bool make(Text text, Cursor cursor) {
		text.set_cursor_position(cursor.offset);
		text.insert_unichar(c);
		cursor.offset++;
		return true;
	}

	public override bool undo(Text text, Cursor cursor) {
		cursor.offset--;
		text.set_cursor_position(cursor.offset);
		text.delete_chars(1);
		return true;
	}
}

class Marx.Actions.Delete : Action {
	public unichar c;

	public override bool make(Text text, Cursor cursor) {
		c = text.get_chars(cursor.offset, cursor.offset + 1).get_char();
		text.set_cursor_position(cursor.offset + 1);
		text.delete_chars(1);
		return true;
	}

	public override bool undo(Text text, Cursor cursor) {
		text.set_cursor_position(cursor.offset);
		text.insert_unichar(c);
		return true;
	}
}

class Marx.Actions.Backspace : Action {
	public unichar c;

	public override bool make(Text text, Cursor cursor) {
		c = text.get_chars(cursor.offset, cursor.offset + 1).get_char();
		text.set_cursor_position(cursor.offset);
		text.delete_chars(1);
		--cursor.offset;
		text.set_cursor_position(cursor.offset);
		return true;
	}

	public override bool undo(Text text, Cursor cursor) {
		text.set_cursor_position(cursor.offset);
		text.insert_unichar(c);
		return true;
	}
}

class Marx.History {
	public Action[] actions;
	public int[] previous;
	public int last;

	public History() {
		last = -1;
		previous = {};
		actions = {};
	}

	public void add(Action action) {
		previous += last;
		last = actions.length;
		actions += action;
	}
}
