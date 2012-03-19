# -*- coding: utf-8 -*-
import math, gobject, pango, clutter
from clutter import cogl

import theme
from settings import backend
from widgets import Text, VBox, HBox, SourceView

class Marx(clutter.Box):

  def __init__(self):
    clutter.Box.__init__(self, clutter.BinLayout(clutter.BIN_ALIGNMENT_FILL, clutter.BIN_ALIGNMENT_FILL))
    
    self.vbox = VBox()
    self.add(self.vbox)

    self.hbox = HBox()
    self.vbox.pack(self.hbox, 'expand', True, 'x-fill', True, 'y-fill', True)

    self.source_view = SourceView()
    self.hbox.pack(self.source_view, 'expand', True, 'x-fill', True, 'y-fill', True)
    
    self.status = HBox()
    self.status.set_color(theme.system.bg)
    self.vbox.pack(self.status, 'expand', False, 'x-fill', True)

    a = Text(u'TODO: Mnóstwo rzeczy...', theme.system)
    self.status.add(a)
    a = Text('ed.py', theme.system)
    self.status.add(a)

    self.set_reactive(True)
    self.connect('scroll-event', self.on_scroll) # TODO: scroll-event should point go sourceview first
    self.connect('key-press-event', self.on_key_press)


  def on_key_press(self, source, event):
    if event.keyval == clutter.keysyms.Escape:
      clutter.main_quit()


  def on_scroll(self, source, event):
    if event.modifier_state & clutter.CONTROL_MASK:
      font_name = backend.get_font_name()
      font_parts = font_name.split(' ')
      font_name = ' '.join(font_parts[:-1])
      font_size = int(font_parts[-1])
      if event.direction == clutter.SCROLL_UP:
          font_size += 1
      elif event.direction == clutter.SCROLL_DOWN:
          font_size -= 1
      font_size = max(font_size, 2)
      backend.set_font_name(font_name + ' ' + str(font_size))
      return True
    else:
      self.source_view.on_scroll(source, event)

