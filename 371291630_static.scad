/*
 * includes
 */
include <vice_jaws.scad>

/*
 * custom settings for vice_jaws.scad
 */
generate_example=false;
bolt_x_offset=-.5;
bolt_y_offset=-1.6;
bolt_distance=60.75;

/*
 * global defines
 */
label_text="371291630 static jaw";
label_size=3;
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
			font="Liberation Mono:style=Regular");
}