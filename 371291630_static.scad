/*
 * includes
 */
include <vice_jaws.scad>

/*
 * custom settings for vice_jaws.scad
 */
generate_example=0;
bolt_x_offset=-1;   /// x/y offsets account for bolt hole locations

/*
 * main construction geometry
 */
vice_jaw();
