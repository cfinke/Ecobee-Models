module ecobee_corner() {
    // The ecobee3 shape is a rounded(ish) square. It can be split up
    // into four quadrants. To generate the outline of the upper right
    // quadrant, start at [0, 50], and connect to the top edge of a 24mm
    // radius circle centered at [25, 25]. Follow the outline of that
    // circle until its y-value hits 25, and then connect to [50, 0]. 
    // Because OpenSCAD can't generate an array of points like this by
    // executing a function for each x-value, these points were generated
    // by a separate PHP script:
    // <?php
    // 
    // function y( $x ) {
    //     return ( 1/$x ) + 50;
    // }
    // 
    // $r = 24;
    // $h = 25;
    // $k = 25;
    // $a = 1;
    // $b = -2 * $k;
    // $points = array();
    // $points[] = '[0, 0]';
    // $points[] = '[0, 50]';
    // 
    // for ( $x = 25; $x <= 49; $x++ ) {
    //     $c = -($r * $r) + ($k * $k) + (($x - $h) * ($x - $h));
    // 
    //     $d = ($b*$b) - (4*$a*$c);
    // 
    //     $y = ( ( -$b + sqrt( $d ) ) / ( 2 * $a ) );
    // 
    //     $points[] = '[' . $x . ', ' . round( $y, 2 ) . ']';
    // }
    // 
    // $points[] = '[50, 0]';
    // 
    // echo '[ ' . join( ", ", $points ) . ' ]';
    points = [ [0, 0], [0, 50], [25, 49], [26, 48.98], [27, 48.92], [28, 48.81], [29, 48.66], [30, 48.47], [31, 48.24], [32, 47.96], [33, 47.63], [34, 47.25], [35, 46.82], [36, 46.33], [37, 45.78], [38, 45.17], [39, 44.49], [40, 43.73], [41, 42.89], [42, 41.94], [43, 40.87], [44, 39.66], [45, 38.27], [46, 36.62], [47, 34.59], [48, 31.86], [49, 25], [50, 0] ];
    
    polygon( points );
}

ecobee_height = 22;

/**
 * @param string mode "model", "convex", and "cutout".  "model" is the semi-realistic model. "convex" does not make any concave cuts out of the model. "cutout" does not make any curves along the faces.
 */
module ecobee3(mode="model") {
    // The top is very slightly rounded. Use the top sliver of a sphere to show this.
    // r=1252 was chosen because it creates a sphere with a 1mm vertical drop from the
    // center top to the edge of the ecobee unit.
    // Find the sphere that has a 1mm drop from the top center to 50mm from center.
    drop = 1;
    distance = 50;
    r = ((distance * distance) + (drop * drop)) / (2 * drop); // Extrapolated from x^2+y^2=r^2.
    intersection() {
        if ( mode != "cutout" ) {
            translate([0, 0, -r + (ecobee_height/2)]) sphere(r=r, $fa = 4);
        }
        linear_extrude(ecobee_height / 2) {
            union() {
                for ( i = [0:3] ) {
                    rotate([0, 0, 90 * i]) {
                        ecobee_corner();
                    }
                }
            }
        }
    }

    intersection() {
        // Expanding a r=200 shphere 3.25mm beyond the bottom of the plate is just about right to
        // make the middle 78mm flat, but have a curve along the edges that loses 2mm on the
        // outer 9mm of each side.
        if ( mode != "cutout" ) {
            translate([0, 0, 200 - (ecobee_height/2) - 3.25]) sphere(r=200, $fa=4);
        }
        // The bottom half is inset 2mm on each side, but with the same general shape as the top.
        scale([.96, .96, 1]) {
            translate([0, 0, -ecobee_height / 2]) {
                difference() {
                    linear_extrude(ecobee_height / 2) {
                        union() {
                            for ( i = [0:3] ) {
                                rotate([0, 0, 90 * i]) {
                                    ecobee_corner();
                                }
                            }
                        }
                    }
                    
                    // There's a cutout in the back with all of the pins and things in it that's about 68x36.
                    if ( mode == "model" ) {
                        cube([68,36,ecobee_height / 2], true);
                    }
                }
            }
        }
    }
}

/*
68x36 cutout in back
*/
ecobee3(mode="model");