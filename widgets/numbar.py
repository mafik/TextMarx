import gobject, pango, clutter
from clutter import cogl

class NumBar(clutter.Actor):
	def __init__(self):
		clutter.Actor.__init__(self)

gobject.type_register(NumBar)