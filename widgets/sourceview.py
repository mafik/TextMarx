import math, gobject, pango, clutter
from clutter import cogl

import theme, settings
from settings import backend
from scrollview import ScrollView

class SourceView(clutter.Actor):
    scroll_lines = gobject.property(type=float)

    def __init__(self):
        clutter.Actor.__init__(self)

        self._scroll_lines = self.scroll_lines = 0
        self.connect('notify::scroll-lines', lambda *x: self.queue_redraw())

        self.layout = self.create_pango_layout(open('marx.py').read())
        self.line_count = self.layout.get_line_count()
        self.temp_layout = self.create_pango_layout('')

        backend.connect('font-changed', self.on_context_changed )
        backend.connect('resolution-changed', self.on_context_changed )

        self.connect('allocation-changed', self.on_allocation_changed)

        self.recalculate_font_metrics()


    def _paint_rect(self, x1, y1, x2, y2, color):
        cogl.path_rectangle(x1, y1, x2, y2)
        cogl.path_close()

        cogl.set_source_color(color)
        cogl.path_fill()


    def _paint_background(self, width, height):
        self._paint_rect(0,0,width,height, theme.text.bg)
           

    def _paint_text(self, width, height): 
        line_count = self.line_count
        scroll_lines = self.scroll_lines

        first_line = int(math.floor(scroll_lines))
        last_line = int(math.ceil(scroll_lines + height / self.line_height) ) + 1
        last_line = min(last_line, line_count)

        if settings.editor['show_line_numbers']:
            places_left = len(str(last_line))
            space_left =  places_left + 2 # for margin
            space_left -= 0.5 # Half-character gap between body & numbers.
            space_left *= self.font_metrics.get_approximate_digit_width()
            space_left /= pango.SCALE

            self._paint_rect(0,0,space_left, height, theme.static.bg)
            
        # x & y are in pango units.
        y = (first_line - scroll_lines) * self.line_height * pango.SCALE
        for i in range(first_line, last_line):

            y += self.font_metrics.get_ascent()
            x = 0

            if settings.editor['show_line_numbers']:
                x += self.font_metrics.get_approximate_digit_width()
                x += (places_left - len(str(i))) * self.font_metrics.get_approximate_digit_width()

                self.temp_layout.set_text(str(i))
                num_line = self.temp_layout.get_line_readonly(0)
                cogl.pango_render_layout_line(num_line, int(x), int(y + pango.SCALE), theme.static.shadow)
                cogl.pango_render_layout_line(num_line, int(x), int(y), theme.static.text)
            
                x += ( len(str(i)) + 1 ) * self.font_metrics.get_approximate_digit_width()
            
            line = self.layout.get_line_readonly(i)
            cogl.pango_render_layout_line(line, int(x), int(y), theme.text.text)
            y += self.font_metrics.get_descent()

        # rysowanie miniaturki :)    
        context = self.layout.get_context()
        normal_font = context.get_font_description()
        small_font = normal_font.copy_static()
        small_font.set_size(pango.SCALE)

        self.layout.set_font_description(small_font)

        #tiny_width, tiny_height = (i/pango.SCALE for i in self.layout.get_extents()[1][2:])
        tiny_height = self.line_count

        shadow_x1 = width*7/8
        shadow_x2 = width
        gap_start = (scroll_lines-1) / line_count * tiny_height
        gap_end   = float(height) / self.line_height / line_count * tiny_height + gap_start

        self._paint_rect(shadow_x1, 0, shadow_x2, gap_start, theme.static.bg)
        self._paint_rect(shadow_x1, gap_end, shadow_x2, height, theme.static.bg)

        cogl.pango_render_layout(self.layout, shadow_x1+1,0, theme.text.text, 0)

        self.layout.set_font_description(normal_font)
        

    def do_paint (self):
        (x, y, w, h) = self.get_allocation_geometry()

        self._paint_background(w, h)
        self._paint_text(w, h)

    def on_allocation_changed(self, source, allocation, flags):
        print 'on_allocation_changed', allocation


    def do_pick (self, pick_color):
        if self.should_pick_paint() == False:
            return

        (x1, y1, x2, y2) = self.get_allocation_box()
        self.__paint_triangle(x2 - x1, y2 - y1, pick_color)


    def on_scroll(self, source, event):
        if event.direction == clutter.SCROLL_UP:
            self._scroll_lines -= 5
        elif event.direction == clutter.SCROLL_DOWN:
            self._scroll_lines += 5
        self._scroll_lines = max(self._scroll_lines, 0)
        self._scroll_lines = min(self._scroll_lines, self.line_count - 1)
        self.animate(clutter.EASE_OUT_EXPO, 300, "scroll-lines", self._scroll_lines)


    def on_context_changed(self, backend):
        self.layout.context_changed()
        self.temp_layout.context_changed()
        self.recalculate_font_metrics()
        self.queue_redraw()


    def recalculate_font_metrics(self):
        context = self.layout.get_context()
        font_description = context.get_font_description()
        font_metrics = context.get_metrics(font_description)
        self.font_metrics = font_metrics
        self.line_height = (font_metrics.get_ascent() + font_metrics.get_descent()) / pango.SCALE
