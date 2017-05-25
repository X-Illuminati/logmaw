/*
 * global defines
 */
$fa=2;
$fs=0.5;
quadrant=0; /// xy grid quadrant to place the
           /// main construction geometry in
           /// 0 = centered

// jaw: basic jaw slab
jaw_length=80;
jaw_width=20;
jaw_thickness=5;

// bolt: bolt hole carvout
bolt_radius=4;
bolt_x_offset=2;  /// x/y offsets account for bolt hole locations
bolt_y_offset=-2; /// being slightly out in manufacturing
bolt_sink=2;      // sink the bolt head deeper into the jaw
bolt_distance=40; // distance between bolt centers
bolt_chamfer=1.5; // 45° chamfer will be applied

// slot: slot/groove to be made in the jaw
slot_inner_width=0.8;   // slot width at deepest point
slot_chamfer_width=1.2; // extra width from chamfer
slot_depth=2;
slot_ratio=1.0;   // location of slot as a proportion of jaw
slot_y_offset=-6; // offset applied on top of slot_ratio


/*
 * module and function definitions
 */
// bolt object composed of main cylinder, chamfer cone,
// and optional extra cylinder to sink the bolt down
module bolt(h,r) {
	translate([0,0,-1]) cylinder(h=h+1,r=r);
	translate([0,0,h-bolt_chamfer-bolt_sink])
		cylinder(h=bolt_chamfer,r1=r,r2=r+bolt_chamfer);
	translate([0,0,h-bolt_sink-.001])
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
function slot_position(raio=0.5,offset=0) =
	[
		0,
		jaw_width*ratio+slot_inner_width+offset,
		jaw_thickness
	];


/*
 * main construction geometry
 */
difference() {
	cube([jaw_length, jaw_width, jaw_thickness]);
	translate(bolt_center()) {
		bolt(h=jaw_thickness, r=bolt_radius);
		translate([bolt_distance,0,0])
			bolt(h=jaw_thickness, r=bolt_radius);
	}
	translate(slot_position(ratio=slot_ratio,offset=slot_y_offset))
		slot(jaw_length);
}