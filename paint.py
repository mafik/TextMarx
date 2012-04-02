from clutter import cogl

def rect(x1, y1, x2, y2, color):
    cogl.path_rectangle(x1, y1, x2, y2)
    cogl.path_close()

    cogl.set_source_color(color)
    cogl.path_fill()