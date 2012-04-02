
TextMarx
========

TextMarx is simply one great text editor. It is in very early stage of
development but the code is runnable and you could check it right now.

Running
-------

    git clone git://github.com/mafik/TextMarx.git
    cd TextMarx
    ./marx

Planned Features
----------------

* Fully programmable (configuration, plugins, macros).
* Wide range of programming languages (through GObject introspection).
* High performance & nice visual effects.
* Modal interface.
* Target platform: modern linux desktop.

Philosophy?
-----------

* Focus on text editing. Everything else should be done by plugins.
* Conform to modern desktop standards but provide standard mechanisms
  for hackers.
 
Requirements
------------

* Clutter-1.0+
* Python-2.7+

ToDo
----

 -  Split SourceView into separate widgets (numbar, textview, scrollview)
 -  Placing cursor by mouse-clicking.
 -  Navigating in text with keyboard arrows.
 -  Navigating in text with home/end/page up/down.
 -  Screen scrolling on cursor movement.
 -  Text insertion with keys.
 -  Text insertion from standard input.
 -  Parsing command line options.
 -  Reading file name from cmdline
 -  Modal interface basics (reading and writing modes)
 -  Lots more...

Reqs
----

* Basic User
  * Loading plugins
* Advanced User
  * Multiple cursors
  * Multiline cursors
  * Multiple selections
* Hacker
  * Embedded languages *TODO*
  * Writing plugins

Tech
----

* Event handling through GObject signals
* Vala core
  * Bindings in: cpython, v8, ruby

