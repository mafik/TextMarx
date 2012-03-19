from clutter import color_from_hls, Color

def from_hls(hue, lightness, saturation):
	c = color_from_hls(hue, lightness, saturation)
	c.alpha = 255
	return c

def from_rgb(*args):
	return Color(*args)
