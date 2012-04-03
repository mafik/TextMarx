using Clutter;

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