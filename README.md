# GraphViews
Subclasses of UIViews that draws graph in itself after receiving a set of values.

This repo is newly created, the three files contained are prone to crashing.

Use ONLY the setup func of each class.

BarView supports only 2 bars

PieView supports only 3 slices



Planned improvement:

BarView:  Allow setting of value per step instead of predefined values.

PieView:  Allow more than 3 slices.

ArcView:  Add labels to show where fix perc(20%,40%,60%,80% marks) are.

BarView:  Support multi section bars - will either be an improvement or a new class(Undecided).

LineView: A new subclass that draws a linegraph after recieving an array of values.



Known Bugs:

Passing in 0 will crash in some situations.
