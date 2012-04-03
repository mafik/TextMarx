SOURCES=core/marx.vala

all : marx

marx : ${SOURCES}
	valac $< --pkg clutter-1.0 --pkg gee-1.0 -o $@

clean :
	rm marx