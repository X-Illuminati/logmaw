/*
 * includes
 */
include <vice_jaws.scad>

/*
 * custom settings for vice_jaws.scad
 */
generate_example=0;
bolt_x_offset=0.25; /// x/y offsets account for bolt hole locations
bolt_y_offset=-1.1; /// being slightly out in manufacturing
bolt_distance=60.6; // distance between bolt centers

/*
 * main construction geometry
 */
vice_jaw();
