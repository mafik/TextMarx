SOURCES=\
  core/marx.vala\
  core/theme.vala\
  core/cursor.vala\
  core/scroller.vala

all : marx

marx : ${SOURCES}
	valac $^ --pkg clutter-1.0 --pkg gee-1.0 -o $@

clean :
	rm marx