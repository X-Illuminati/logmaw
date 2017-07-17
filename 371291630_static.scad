/*
 * includes
 */
include <vice_jaws.scad>

/*
 * custom settings for vice_jaws.scad
 */
generate_example=false;
bolt_x_offset=-0.85;
bolt_y_offset=-1.35;
bolt_distance=60.25;

/*
 * global defines
 */
label_text1="371291630";
label_text2="static jaw";
label_size=5.5;
label_depth=0.3;

/*
 * main construction geometry
 */
difference() {
vice_jaw();
translate([jaw_length/2,jaw_width/2,0])
	rotate([0,180,0])
		linear_extrude(height=(label_depth*2), center=true) {
			translate([0,jaw_width/5,0])
				text(text=label_text1, size=label_size,
				halign="center", valign="center",
				font="Liberation Mono:style=Regular");
			translate([0,-jaw_width/5,0])
				text(text=label_text2, size=label_size,
					halign="center", valign="center",
					font="Liberation Mono:style=Regular");
		}
}