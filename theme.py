from utils import color, Style
from settings import backend
from random import randint

hue = randint(0,360)
backend.set_font_name('Droid Sans Mono 8')

# Used to merge with system theme seamlessly.
system = Style( 
	text = color.from_rgb(65,70,72),
	bg = color.from_rgb(237,237,237),
	shadow = ( 0, 1, color.from_rgb(255,255,255) ) 
)

# Static elements of the interface.
static = Style(
	bg = color.from_hls(hue, 0.3, 0.2),
	text = color.from_hls(hue, 0.1, 0.2),
	shadow = color.from_hls(hue, 0.4, 0.2)
) 

# Main editing area.
text = Style(
	bg = static.bg.darken(), # cross-references allowed
	text = color.from_hls(hue, 1, 0)
)
