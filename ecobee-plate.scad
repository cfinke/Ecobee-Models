use <ecobee.scad>;

corner_radius = 30;
plate_height = 170 + ( 2 * corner_radius );
plate_width = 220 + ( 2 * corner_radius );

plate_thickness_min = 2;
plate_shape = "rectangle";

$fs = 1;
$fa = 1;

module plate( plate_shape = "rectangle", plate_thickness_min = 3, plate_height = 130, plate_width = 130, corner_radius = 30, ) {
    difference() {
        hull() {
            plate_base(plate_shape = plate_shape, plate_height = plate_height, plate_thickness_min = plate_thickness_min, plate_width = plate_width);
            plate_lip();
        }
        
        translate([0, 0, 11]) scale([1.01, 1.01, 1]) ecobee3(mode="convex");
    }
}

module plate_lip() {
    translate([0, 0, 11]) intersection() {
        scale([1.04, 1.04, 1]) ecobee3(mode="cutout");
        translate([0, 0, -11]) cube([1000, 1000, 22], true); 
    }
}

module plate_base( plate_shape = "rectangle", plate_thickness_min = 3, plate_height = 130, plate_width = 130, corner_radius = 30, ) {
    translate([0, 0, plate_thickness_min]) {
            
        if ( "rectangle" == plate_shape ) {
            difference() {
                translate([0, 0, -plate_thickness_min/2]) cube( [plate_width, plate_height, plate_thickness_min], true );
    
                union() {
                    // Round the corners.
                    translate([-plate_width/2,-plate_height/2, -plate_thickness_min/2]) fillet(corner_radius, plate_thickness_min*2);
                    translate([plate_width/2,-plate_height/2, -plate_thickness_min/2]) rotate([0,0,90]) fillet(corner_radius, plate_thickness_min*2);
                    translate([plate_width/2,plate_height/2, -plate_thickness_min/2]) rotate([0,0,180]) fillet(corner_radius, plate_thickness_min*2);
                    translate([-plate_width/2,plate_height/2, -plate_thickness_min/2]) rotate([0,0,270]) fillet(corner_radius, plate_thickness_min*2);
                }
            }
        }
        else if ( "circle" == plate_shape ) {
            translate([0, 0, -plate_thickness_min]) linear_extrude( plate_thickness_min ) circle( d=plate_width );
        }
   }
}

/**
 * @author nophead http://forum.openscad.org/template/NamlServlet.jtp?macro=user_nodes&user=92nop
 * @see http://forum.openscad.org/rounded-corners-td3843.html
 */
module fillet(r, h) {
    translate([r / 2, r / 2, 0]) {
        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);
            translate([r/2, r/2, 0]) {
                cylinder(r = r, h = h + 1, center = true);
            }
        }
    }
}

plate( plate_shape = plate_shape, plate_height = plate_height, plate_thickness_min = plate_thickness_min, plate_width = plate_width );

