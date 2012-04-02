import gobject, clutter
from clutter import cogl

class BigText(clutter.Text):
	def __init__(self):
		clutter.Text.__init__(self)
        '''

        self.layout = self.create_pango_layout(open('marx.py').read())
        self.line_count = self.layout.get_line_count()
        self.temp_layout = self.create_pango_layout('')

        backend.connect('font-changed', self.on_context_changed )
        backend.connect('resolution-changed', self.on_context_changed )

        self.recalculate_font_metrics()


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

        cogl.push_matrix()
        cogl.translate(space_left, 0,0)
        if first_line <= self.cursor.row <= last_line:
            self._paint_cursor()
        cogl.pop_matrix()

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
    '''  

gobject.type_register(BigText)
