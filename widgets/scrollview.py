import math, gobject, pango, clutter
from clutter import cogl

import theme, settings
from settings import backend

class ScrollView(clutter.Actor):
	scroll_position = gobject.property(type=float, minimum=0, maximum=1)
