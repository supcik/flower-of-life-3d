/*-----------------------------------------------------------------------------
 * Flower Of Life 3D model
 * Author : Jacques Supcik <jacques@supcik.net>
 * Cate   : 30. Kanuary 2023
 *-----------------------------------------------------------------------------
 * Copyright (c) 2023 Jacques Supcik
 * SPDX-License-Identifier: MIT OR Apache-2.0
 *-----------------------------------------------------------------------------
 */

// ----- parameters -----

// outer diameter [in mm]
outer_diameter = 200.0;  // .1

// height [in mm] (0.0 = automatic)
height = 0.0;  // .1

// arc width [in mm] (0.0 = automatic)
arc_width = 0.0;  // .1

// Draft (simplify circles for faster rendering)
draft = true;  // [true, false]

// main color
main_color = "white";  // [white, black, red, yellow, aqua, blue, lime]

// ----- code -----

// Draw a 2C ring with radius `r` and width `width`
module ring(r, width) {
    difference() {
        circle(r + width / 2);
        circle(r - width / 2);
    }
}

// Draw an arc with radius `r` and width `width`. `n` is the size of the arc
// (1 = 60°, 2 = 120°, 3 = 180°, 4 = 240°, 5 = 300°, 6 = 360°)
module arc(r, width, n) {
    if (n == 1) {
        union() {
            intersection() {
                ring(r, width);
                translate([ 2 * r, 0 ])
                {
                    rotate([ 0, 0, 180 ])
                    { circle(r = r * 2, $fn = 3); }
                }
            };
        }
    } else if (n == 2) {
        union() {
            intersection() {
                ring(r, width);
                translate([ 2 * r, 0 ])
                { circle(r = r * 2, $fn = 6); }
            };
        };
    } else if (n == 3) {
        union() {
            intersection() {
                ring(r, width);
                translate([ 2 * r, 0 ])
                { square([ 4 * r, 4 * r ], center = true); }
            };
        }
    } else if (n == 4) {
        union() {
            difference() {
                ring(r, width);
                translate([ -2 * r, 0 ])
                { circle(r = r * 2, $fn = 6); }
            };
        }
    } else if (n == 5) {
        union() {
            difference() {
                ring(r, width);
                translate([ -2 * r, 0 ])
                { circle(r = r * 2, $fn = 3); }
            };
        }
    } else if (n == 6) {
        ring(r, width);
    }
}

module part(r, width, n, angle, height) {
    linear_extrude(height) {
        rotate([ 0, 0, angle ])
        { arc(r, width, n); }
    };
}

module flower(r, width, height) {
    circle_width = round(r * 0.0461 / 0.4) * 0.4;
    rin = r - circle_width;
    r_small_circle = rin / 3.0;

    flower_height = height == 0 ? max(0.4, round(r * 0.02 / 0.4) * 0.4) : height;
    arc_width = width == 0 ? max(0.4, round(r * 0.0133 / 0.4) * 0.4) : width;

    part(r - circle_width / 2, circle_width, 6, 0, flower_height);

    part(r_small_circle, arc_width, 6, 0, flower_height);
    for (a = [30:60:360]) {
        rotate([ 0, 0, a ])
        {
            translate([ r_small_circle, 0, 0 ])
            { part(r_small_circle, arc_width, 6, 0, flower_height); }
        }
    }

    for (a = [30:60:360]) {
        rotate([ 0, 0, a ])
        {
            translate([ 2 * r_small_circle, 0, 0 ])
            { part(r_small_circle, arc_width, 6, 0, flower_height); }
        }
    }

    for (a = [30:60:360]) {
        rotate([ 0, 0, a ])
        {
            translate([ 3 * r_small_circle, 0, 0 ])
            { part(r_small_circle, arc_width, 2, 180, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 2 * r_small_circle * cos(30), 0, 0 ])
            { part(r_small_circle, arc_width, 6, 0, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 4 * r_small_circle * cos(30), 0, 0 ])
            { part(r_small_circle, arc_width, 1, 180, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 3 * r_small_circle * cos(30), r_small_circle * sin(30), 0 ])
            { part(r_small_circle, arc_width, 3, 180, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 3 * r_small_circle * cos(30), -r_small_circle * sin(30), 0 ])
            { part(r_small_circle, arc_width, 3, 180, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 4 * r_small_circle * cos(30), r_small_circle, 0 ])
            { part(r_small_circle, arc_width, 1, 180, flower_height); }
        }
    }

    for (a = [0:60:300]) {
        rotate([ 0, 0, a ])
        {
            translate([ 4 * r_small_circle * cos(30), -r_small_circle, 0 ])
            { part(r_small_circle, arc_width, 1, 180, flower_height); }
        }
    }
}

// ----- main -----

$fn = draft ? 32 : 128;
color(main_color) {
    union() { flower(outer_diameter / 2, arc_width, height); }
}
