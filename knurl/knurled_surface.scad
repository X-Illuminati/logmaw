/*
 * knurled surface library
 *
 * use <knurled_surface.scad>
 * knurled_surface();
 */

// generate a "knurler" that covers at least the given size rectangle
// depth of the knurl will be controlled by size.z
// angle controlls the obliqueness of the diamond pattern
// the "knurler" creates a knurling pattern made of long, thin
// rectangular prisms that are rotated 45°
// these are arranged in a hash pattern at the given angle
module knurl(size=[10,10,1], angle=30)
{
//	length=max(size.x,size.y)*sqrt(2);
	width=size.z*2;
	count=max(size.x, size.y)/width;
	angle=angle;

	module yhash()
	{
		disp=width;
		count=(size.y)/width;
		for (yy=[0:1:count])
			translate([-width/2,yy*disp,0])
				rotate([45,0,0])
					cube([(size.x+width),
					      width/sqrt(2),
					      width/sqrt(2)]);
	}

	module xhash()
	{
		disp=width/cos(angle);
		dx=size.y*tan(angle);
		count=size.x/width+1;
		precount=dx/width+1;
		module xhash_single(i)
			translate([i*disp,0,0])
				rotate([45,0,90-angle])
					translate([-width/2,0,0])
						cube([(size.y+width)/cos(angle),
							  width/sqrt(2),
							  width/sqrt(2)]);
		for (xx=[0:1:count])
			xhash_single(xx);
		for (xx=[1:1:precount])
			xhash_single(-xx);
	}

	union() {
		yhash();
		xhash();
	}
}

// create a rectangular knurled surface by subtracting a
// "knurler" from a cube
// the thickness of the cube is controlled by the thickness
// parameter rather than by size.z
module knurled_surface(size=[10,10,1], angle=30, thickness=2, scale=1)
{
	scale([scale,scale,1])
		difference() {
			cube([size.x/scale,size.y/scale,thickness]);
			translate([0,0,thickness-size.z])
				knurl([size.x/scale,size.y/scale,size.z], angle);
		}
}

// example knurled surface
knurled_surface(size=[35,35,1], angle=30, thickness=1.5, scale=2);
