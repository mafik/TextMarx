import clutter
from clutter import cogl

class Text(clutter.Text):
  __gtype_name__ = 'Text'
  def __init__(self, text, style):
    clutter.Text.__init__(self)
    self.set_text(text)
    self.style = style
  def do_paint(self):
    layout = self.get_layout()
    if self.style.shadow:
      cogl.pango_render_layout(layout, self.style.shadow[0], self.style.shadow[1], self.style.shadow[2], 0)
    cogl.pango_render_layout(layout, 0, 0, self.style.text, 0)
