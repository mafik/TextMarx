import gobject, clutter
from clutter import cogl

class Cursor(clutter.Actor):
    row = gobject.property(type=int)
    column = gobject.property(type=int)

    def __init__(self, col, row):
        clutter.Actor.__init__(self)
        self.col, self.row = col, row

    	'''
    def _paint_cursor(self):
        char_width = self.font_metrics.get_approximate_digit_width() / pango.SCALE
        char_height = self.line_height

        y1 = (self.cursor.row - self.scroll_lines) * char_height
        y2 = y1 + self.line_height

        x1 = (self.cursor.col - 0) * char_width
        x2 = x1 - 1
        if self.cursor.col == 0: x2 += 2

        self._paint_rect(x1, y1, x2, y2, theme.system.bg)
    '''