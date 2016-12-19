use <ecobee.scad>;

plate_width = 300;
plate_height = 200;
plate_thickness = 11;
corner_radius = 30;

difference() {
    translate([0, 0, -plate_thickness/2]) cube( [plate_width, plate_height, plate_thickness], true );
    ecobee3(mode="cutout");
    
    // Round the corners.
    translate([-plate_width/2,-plate_height/2, -plate_thickness/2]) fillet(corner_radius, plate_thickness);
    translate([plate_width/2,-plate_height/2, -plate_thickness/2]) rotate([0,0,90]) fillet(corner_radius, plate_thickness);
    translate([plate_width/2,plate_height/2, -plate_thickness/2]) rotate([0,0,180]) fillet(corner_radius, plate_thickness);
    translate([-plate_width/2,plate_height/2, -plate_thickness/2]) rotate([0,0,270]) fillet(corner_radius, plate_thickness);


}

module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}