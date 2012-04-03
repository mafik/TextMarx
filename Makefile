all : marx

marx : marx.vala
	valac $< --pkg clutter-1.0 --pkg gee-1.0
