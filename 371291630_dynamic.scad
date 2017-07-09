/*
 * includes
 */
include <vice_jaws.scad>

/*
 * custom settings for vice_jaws.scad
 */
generate_example=false;
bolt_x_offset=0.25; /// x/y offsets account for bolt hole locations
bolt_y_offset=-1.1; /// being slightly out in manufacturing
bolt_distance=60.6; // distance between bolt centers

/*
 * global defines
 */
label_text="371291630 dynamic jaw";
label_size=2.5;
label_depth=0.5;

/*
 * main construction geometry
 */
difference() {
vice_jaw();
translate([jaw_length/2,jaw_width,jaw_thickness/2])
	rotate([90,0,180])
		linear_extrude(height=(label_depth*2), center=true)
		text(text=label_text, size=label_size,
			halign="center", valign="center",
			font="Liberation Sans:style=Regular");
}