# system libraries
import math, gobject, pango, clutter
from clutter import cogl

# textmarx libraries
import theme, settings, paint
from settings import backend

# widgets
from scrollview import ScrollView
from cursor import Cursor
from bigtext import BigText

class SourceView(clutter.Group):
    scroll_rows = gobject.property(type=float)

    def __init__(self):
        clutter.Group.__init__(self)

        self.text = t = BigText()
        t.set_color(theme.text.text)
        t.set_text(open('marx.py').read())
        self.add(t)

        self._scroll_rows = self.scroll_rows = 0
        self.connect('notify::scroll-rows', self.do_layout)

        self.do_layout()

    def do_paint (self):
        (x, y, w, h) = self.get_allocation_geometry()

        paint.rect(0, 0, w, h, theme.text.bg) # Background

        clutter.Group.do_paint(self)

        
    def do_get_preferred_width(self, for_height):
        return 0

    def do_get_preferred_height(self, for_width):
        # should return height of horizontal scroll
        return 0

    def do_layout(self, *args):
        self.text.set_position(0, -self.scroll_rows * 10)


    def on_scroll(self, source, event):
        if event.direction == clutter.SCROLL_UP:
            self._scroll_rows -= 5
        elif event.direction == clutter.SCROLL_DOWN:
            self._scroll_rows += 5
        self._scroll_rows = max(self._scroll_rows, 0)
        self._scroll_rows = min(self._scroll_rows, self.text.get_layout().get_line_count() - 1)
        self.animate(clutter.EASE_OUT_EXPO, 300, "scroll-rows", self._scroll_rows)
