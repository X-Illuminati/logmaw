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
	width=size.z*2;
	angle=(90-angle)/2;

	module hash(mirror=false)
	{
		disp=width/cos(angle);
		dy=size.x*tan(angle);
		cstart=mirror?floor(-dy/width-.5)-1:0;
		count=floor((size.y+dy)/width+.5)+1;
		cend=mirror?(count+cstart+1):count;
		for (yy=[cstart:1:cend])
			translate([0,yy*disp,0])
				mirror([0,mirror?1:0,0])
				rotate([45,0,-angle])
					translate([-width/2,0,0])
						cube([(size.x+width)/cos(angle),
							width/sqrt(2),
							width/sqrt(2)]);
	}

	union() {
		hash();
		hash(mirror=true);
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
knurled_surface(size=[35,15,1], angle=35, thickness=1.5, scale=2);
