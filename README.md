# logmaw
3D printable vice jaws to convert a "4 in." drill press vice into a makeshift stickvice for electronics workholding.

This is basically an exercise in learning OpenSCAD for me.

The part I've modeled is a set of vice jaws for a relatively generic 4 inch drill press vice.
In this case, I got the vice from [Harbor Freight](https://www.harborfreight.com/4-inch-jaw-capacity-drill-press-vise-30999.html).

In order to use the vice for electronics workholding (soldering, etc.), I have added a simple slot to the design.
Additionally, I have made most of the design parametric, which turned out to be useful since the screw-holes
in the existing vice jaws were clearly drilled with no regard for symmetric placement.

The main STL is [vice_jaws.stl](vice_jaws.stl), but anyone seeking to print these will
probably want to modify the .scad files to match their own vice.
