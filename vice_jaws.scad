/*
 * includes
 */
use <knurl/knurled_surface.scad>

/*
 * global defines
 * dimensions represent mm
 */
$fa=2;
$fs=0.5;

/// grid plane in which to place the main
/// construction geometry
/// 0 = xy
/// 1 = xz
/// 2 = yz
global_geometry_plane=0;

/// grid quadrant in which to place the main
/// construction geometry
/// 0 = centered
global_geometry_quadrant=1;

// jaw: basic jaw slab
jaw_length=100;
jaw_width=19;
jaw_thickness=4;

// bolt: bolt hole carvout
bolt_radius=3.5;
bolt_x_offset=0;    /// x/y offsets account for bolt hole locations
bolt_y_offset=-1.5; /// being slightly out in manufacturing
bolt_sink=1;        // sink the bolt head deeper into the jaw
bolt_distance=60;   // distance between bolt centers
bolt_chamfer=2;     // 45° chamfer will be applied

// slot: slot/groove to be made in the jaw
slot_inner_width=0.8;    // slot width at deepest point
slot_chamfer_width=1.85; // extra width from chamfer
slot_depth=1.85;
slot_ratio=1.0;   // location of slot as a proportion of jaw
slot_y_offset=-4; // offset applied on top of slot_ratio

//knurl: knurl the face of the jaw
knurl_face=true;   // set to false to disable the knurl
// knurl up to the bottom of the slot
knurl_width=jaw_width*slot_ratio+slot_y_offset;
knurl_thickness=1; // depth of the knurl
knurl_angle=30;
knurl_y_shrink=1;  // amount to shrink the knurl back from the vertical edge
knurl_x_shrink=1;  // amount to shrink the knurl back from the horizontal edge
knurl_scale=2.5;   // amount to scale the knurling
// a more pleasing knurl can result by tweaking
// the above 2 params
knurl_scale=(knurl_width+knurl_y_shrink*-2)*cos(knurl_angle)/(10*sin(45-knurl_angle/2));
knurl_x_shrink=50-11*(knurl_width+knurl_y_shrink*-2)/(5*tan(45-knurl_angle/2));

/*
 * module and function definitions
 */
// bolt object composed of main cylinder, chamfer cone,
// and optional extra cylinder to sink the bolt down
module bolt(h,r) {
	translate([0,0,-1]) cylinder(h=h+1,r=r);
	translate([0,0,h-bolt_chamfer-bolt_sink])
		cylinder(h=bolt_chamfer,r1=r,r2=r+bolt_chamfer);
	translate([0,0,h-bolt_sink-.025])
		cylinder(h=bolt_sink+1,r=r+bolt_chamfer);
}

// return the center point between the two bolts
function bolt_center() =
	[
		jaw_length/2-bolt_distance/2+bolt_x_offset,
		jaw_width/2+bolt_y_offset,
		0
	];

// slot object which is narrow at the deepest part and then
// widens in a chamfer to a maximum as it reaches the surface
module slot(length) {
//	translate([-1,0,0])
//		cube([length+2, slot_inner_width, slot_depth+1]);
	translate([length+1,0,0])
		rotate([90,0,-90])
		linear_extrude(height=length+2)
			polygon([
				[0,-slot_depth],
				[slot_inner_width,-slot_depth],
				[slot_inner_width,1],
				[-slot_chamfer_width,1],
				[-slot_chamfer_width,0],
				[0,-slot_depth]		
			]);
};

// return the position of the slot (bottom of y)
function slot_position(ratio=0.5,offset=0) =
	[
		0,
		jaw_width*ratio+slot_inner_width+offset,
		jaw_thickness
	];

/// rotate the geometry globally
/// plane - the plane to use as the surface for
///         the main construction geometry
///         0 = xy
///         1 = xz
///         2 = yz
module global_rotate(plane=0) {
	if (plane == 1)
		rotate([90,0,0]) children();
	else if (plane == 2)
		rotate([90,0,90]) children();
	else
		children();
}

/// translate the geometry globally
/// quadrant - the grid quadrant to use as the
///         surface for the main construction
///         geometry
///         0 = center on origin
module global_translate(quadrant=1) {
	if (quadrant == 0)
		translate([-jaw_length/2,-jaw_width/2,0]) children();
	else if (quadrant == 2)
		translate([-jaw_length,0,0]) children();
	else if (quadrant == 3)
		translate([-jaw_length,-jaw_width,0]) children();
	else if (quadrant == 4)
		translate([0,-jaw_width,0]) children();
	else
		children();
}

// return the position of the knurl region
function knurl_position() =
	[
		knurl_x_shrink,
		knurl_y_shrink,
		jaw_thickness-knurl_thickness
	];

// return the dimensions for the knurl region
function knurl_dimension() =
	[
		jaw_length+knurl_x_shrink*-2,
		knurl_width+knurl_y_shrink*-2,
		knurl_thickness
	];

/*
 * main construction geometry
 */
module vice_jaw() {
	global_rotate(global_geometry_plane)
		global_translate(global_geometry_quadrant) {
			difference() {
				if (knurl_face)
					union() {
						difference() {
							cube([jaw_length, jaw_width, jaw_thickness]);
							translate(knurl_position())
									cube(knurl_dimension());
						}
						translate(knurl_position())
							knurled_surface(size=knurl_dimension(),
								scale=knurl_scale,
								angle=knurl_angle,
								thickness=knurl_thickness);
					}
				else
					cube([jaw_length, jaw_width, jaw_thickness]);
				translate(bolt_center()) {
					bolt(h=jaw_thickness, r=bolt_radius);
					translate([bolt_distance,0,0])
						bolt(h=jaw_thickness, r=bolt_radius);
				}
				translate(slot_position(ratio=slot_ratio,offset=slot_y_offset))
					slot(jaw_length);
			}
		}
}

/*
 * create example construction
 * add "generate_example=false;" to any files that include this one
 */
generate_example=true;
if (generate_example)
	vice_jaw();