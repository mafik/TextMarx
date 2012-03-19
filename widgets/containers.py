import clutter

class VerticalBox(clutter.Box):
	def __init__(self):
		self.layout = clutter.BoxLayout()
		self.layout.set_vertical(True)
		clutter.Box.__init__(self, self.layout)

class HorizontalBox(clutter.Box):
	def __init__(self):
		self.layout = clutter.BoxLayout()
		self.layout.set_vertical(False)
		clutter.Box.__init__(self, self.layout)

