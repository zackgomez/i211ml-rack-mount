// Verizon I-211M-L ONT + inline power brick — reference solids
// All primary dims calipers, 2026-08-08.
// Axes: x = along the rack face, y = depth, z = up; devices lying flat.
// Origin: bottom-left-front corner of each body's bounding box.

// Octagonal profile: w x h rectangle with corners cut c.
// bottom=false leaves the two bottom corners sharp.
function _prof(w, h, c, bottom = true) = bottom
    ? [[c, 0], [w - c, 0], [w, c], [w, h - c], [w - c, h], [c, h], [0, h - c], [0, c]]
    : [[0, 0], [w, 0], [w, h - c], [w - c, h], [c, h], [0, h - c]];

// Box with 45-degree chamfer c on edges.
// bottom=false: edges of the bottom face stay sharp (vertical edges still cut).
module chamfered_box(x, y, z, c, bottom = true) {
    intersection() {
        linear_extrude(z)                            // vertical edges
            polygon(_prof(x, y, c));
        translate([0, y, 0]) rotate([90, 0, 0])      // edges running along y
            linear_extrude(y) polygon(_prof(x, z, c, bottom));
        rotate([90, 0, 90])                          // edges running along x
            linear_extrude(x) polygon(_prof(y, z, c, bottom));
    }
}

// ---------------- ONT ----------------
ont_l = 227;          // x, soft tape +-2
ont_w = 148;          // y, calipers
ont_h = 33;           // z, calipers
ont_chamfer_face = 10.5;              // calipers, width of the 45° chamfer FACE,
ont_chamfer = ont_chamfer_face / sqrt(2);  // -> ~7.4 leg; ALL edges incl. LED bevel

// Connector edge = one long (x) edge -> faces rack rear.
// LED bevel = opposite long edge -> faces rack front (model y = ont_w edge).

// Rubber feet on the bottom face (calipers except inset depth). There are
// also mounting bosses on the bottom, shorter than the feet — unmeasured;
// the ONT rides on its feet so bosses just need to hover.
foot_d = 11;
foot_h = 3;
// Foot gaps are measured from the CHAMFER edge (where the corner cut meets
// the side), and each pair's gap applies on BOTH axes from its corner.
foot_gap_led = 1.5;    // LED-side pair
foot_gap_port = 20;    // port-side pair
f_led  = ont_chamfer + foot_gap_led  + foot_d / 2;   // center from corner
f_port = ont_chamfer + foot_gap_port + foot_d / 2;

ont_feet = [
    [f_led,          ont_w - f_led],
    [ont_l - f_led,  ont_w - f_led],
    [f_port,         f_port],
    [ont_l - f_port, f_port],
];

// Rear-face ports, centered in z on the connector face (y=0). Positions
// calipers; stub sizes estimated. Modeled as protruding stubs so mount
// keep-outs and cable sweep are visible on the ghost.
coax_x = 36;                 // F-connector center to the -x face
coax_d = 9.5;
coax_len = 12;
fiber_edge_x = ont_l - 20;   // green SC/APC plug outer edge to the +x face
fiber_w = 9.4;
fiber_h = 9;
fiber_len = 30;              // connector body + start of boot

module ont() {
    chamfered_box(ont_l, ont_w, ont_h, ont_chamfer);
    for (p = ont_feet)
        translate([p[0], p[1], -foot_h])
            cylinder(h = foot_h + 0.5, d = foot_d, $fn = 24);
    // port stubs on the connector face
    translate([coax_x, 0.5, ont_h / 2]) rotate([90, 0, 0])
        cylinder(h = coax_len + 0.5, d = coax_d, $fn = 24);
    translate([fiber_edge_x - fiber_w, -fiber_len, (ont_h - fiber_h) / 2])
        cube([fiber_w, fiber_len + 0.5, fiber_h]);
}

// ---------------- Power brick ----------------
// Calipers except where noted. Envelope quirk: sides bow out ("diamond") —
// widest ~1.2 mm proud of the chamfer edge at mid-height (rough measurement).
// 124 x 88 are max-envelope caliper numbers, so pockets sized off these are
// safe; the body is just a touch slimmer near top and bottom.
brick_l = 124;        // x
brick_w = 85;         // y, max envelope — at the mid-height shell seam
brick_w_bot = 83.4;   // y at the bottom face (calipers 2026-08-09)
brick_w_top = 83.4;   // y at the chamfer edge — symmetric draft (confirmed
                      // by eye 2026-08-09, not calipered)
brick_h = 44;         // z
brick_chamfer = 6;    // top-face perimeter only
brick_corner_r = 2.5; // vertical edges "lightly rounded" — eyeball value
byi = (brick_w - brick_w_bot) / 2;   // bottom inset per side
tyi = (brick_w - brick_w_top) / 2;   // chamfer-edge inset per side

// shell parting line: groove around the body at the z-center plane where the
// two plastic shell halves mate
seam_h = 1;           // z height of the groove
seam_d = 1;           // how deep it cuts into the x/y faces

// Mounting tabs on BOTH x ends: bottom-flush wedges, thick at the body,
// sloping down to a FLAT RUN at min height out to the tip. The two tabs
// differ in plan AND position (calipers 2026-08-09): the -x body tab is
// the big one, offset toward -y (24.4 off the bottom face's -y edge, and
// 24.4 + 20.3 + 38.7 closes the 83.4 bottom width exactly); the +x tab
// on the shroud tip is the small centered one.
tabm_len = 18.2;  tabm_w = 20.3;                       // -x tab plan
tabm_y = byi + 24.4;                                   // its -y edge, bbox frame
tabm_h_min = 3.8;  tabm_h_max = 8.2;  tabm_flat = 4;   // -x tab wedge
tab_len = 11;         // +x tab, x
tab_w = 12.5;         // +x tab, y
tab_r = 2.5;          // outer vertical edges "moderately rounded" — eyeball
tabp_h_min = 3.3;  tabp_h_max = 7.0;  tabp_flat = 3;   // +x tab wedge

// plan footprint of a tab, tip corners rounded; tip at x=0, or at x=len
// with tip_right=true (built directly, not mirror()ed — mirrored 2D reverses
// winding and CGAL rejects the extruded intersection as non-closed)
module _tab_plan(len, w, tip_right = false) {
    cx = tip_right ? len - tab_r : tab_r;
    hull() {
        translate([tip_right ? 0 : len - 1, 0]) square([1, w]);
        translate([cx, tab_r]) circle(tab_r, $fn = 32);
        translate([cx, w - tab_r]) circle(tab_r, $fn = 32);
    }
}

// Cord-exit protrusion on the +x end (soft tape). Modeled as its full
// envelope box — the taper is ignored on purpose, pockets must clear it anyway.
// ---- cord shroud (+x end) ----
// TWO cords exit the +x end (stub cylinders below — leave the whole +x face
// open in the mount):
//   1. body cord, toward the +y edge of the body's +x face
//   2. output cord, locked in by the cord shroud (strain relief), leaving the
//      shroud's tip face on the -y side of the +x tab
// The +x tab hangs off the FAR (+x) END of the shroud, bottom-flush, centered
// on the shroud's y span. A small cylindrical greeble sits on the +y side of
// the tab on the same face.
shroud_len = 38;      // x beyond the body
shroud_y0 = 6;        // margin from the -y edge (calipers)
shroud_w = 53;        // y
shroud_drop = 14;     // its flat top sits this far below the brick top
shroud_h_tip = 22.3;  // height of the tip face (calipers)
shroud_h_root = brick_h - shroud_drop;
shroud_r = 2.5;       // all edges moderately rounded EXCEPT the floor
tabp_y = shroud_y0 + (shroud_w - tab_w) / 2;   // +x tab centered on the shroud

// Cords Ø6 (calipers). y of the body cord still TODO calipers.
cord_d = 6;
cord_stub = 25;                      // how far bare-cord stubs poke out

// Body cord strain relief: stacked in +x off the body face — rect slab, then
// cylinder, then the cord. Max z extent of the relief = brick_h/2 (calipers).
srA_rect_x = 2.5;                    // slab thickness in x
srA_wh = 15;                         // slab is 15 x 15 in y/z; cylinder Ø15
srA_cyl_len = 12.5;
srA_top = brick_h / 2;               // top of the whole relief stack
cordA_y = brick_w - 10 - cord_d / 2; // TODO calipers — "a bit more -y" than 6
cordA_z = srA_top - srA_wh / 2;      // relief + cord centerline (14.5)

// Shroud cord: top of cord 4.8 (calipers) below the tip face's max z
cordB_y = (shroud_y0 + tabp_y) / 2;  // -y side of the tab
cordB_z = shroud_h_tip - 4.8 - cord_d / 2;

// greeble on the +y side of the tab: an unpopulated cord exit ("cord hat").
// Half-spool, its y and z mirroring the shroud cord across the tab: shaft
// then lip stacked in +x, center drilled out Ø6 (cord-sized), then cut at
// the axis z-plane — flat below, half-round above. All calipers.
greeble_shaft_len = 6.7;  greeble_shaft_d = 8;
greeble_lip_len = 2;      greeble_lip_d = 10;
greeble_y = (tabp_y + tab_w + shroud_y0 + shroud_w) / 2;  // cordB_y mirrored
greeble_z = shroud_h_tip - 4.8 - cord_d / 2;              // = cordB_z

module brick() {
    // body: rounded vertical edges, 45° chamfer around the top face only,
    // shell parting-line groove at the z-center plane
    difference() {
        intersection() {
            linear_extrude(brick_h)
                offset(r = brick_corner_r) offset(delta = -brick_corner_r)
                    square([brick_l, brick_w]);
            translate([0, brick_w, 0]) rotate([90, 0, 0])
                linear_extrude(brick_w) polygon(_prof(brick_l, brick_h, brick_chamfer, false));
            // width profile: drafted sides — 83.4 at the bottom, widest (85)
            // at the mid-height seam, back in at the chamfer edge, 45° top
            // chamfer from there
            rotate([90, 0, 90]) linear_extrude(brick_l) polygon([
                [byi, 0], [brick_w - byi, 0], [brick_w, brick_h / 2],
                [brick_w - tyi, brick_h - brick_chamfer],
                [brick_w - tyi - brick_chamfer, brick_h],
                [tyi + brick_chamfer, brick_h],
                [tyi, brick_h - brick_chamfer], [0, brick_h / 2]]);
        }
        // convexity hint stops the F5 see-through artifact on this groove
        translate([0, 0, brick_h / 2 - seam_h / 2])
            linear_extrude(seam_h, convexity = 10) difference() {
                offset(delta = 1)  // overshoot outward to dodge coplanar faces
                    offset(r = brick_corner_r) offset(delta = -brick_corner_r)
                        square([brick_l, brick_w]);
                offset(delta = -seam_d)
                    offset(r = brick_corner_r) offset(delta = -brick_corner_r)
                        square([brick_l, brick_w]);
            }
    }
    // Tab profiles overshoot the plan footprint by 0.5 on both x ends so the
    // rounded _tab_plan governs the tip cleanly (avoids coincident-face CGAL
    // errors); the body-side overshoot is swallowed by the union.
    // -x tab: x=0 at tip; flat run at h_min from the tip, then slope up to
    // h_max at the body. Offset toward -y, not centered.
    translate([-tabm_len, tabm_y, 0]) intersection() {
        translate([0, tabm_w, 0]) rotate([90, 0, 0]) linear_extrude(tabm_w)
            polygon([[-0.5, 0], [tabm_len + 0.5, 0], [tabm_len + 0.5, tabm_h_max],
                     [tabm_flat, tabm_h_min], [-0.5, tabm_h_min]]);
        translate([0, 0, -0.5]) linear_extrude(tabm_h_max + 1.5)
            _tab_plan(tabm_len, tabm_w);
    }
    // +x tab: hangs off the far end of the cord shroud. x=0 at the tip face;
    // slope down from h_max to a flat run at h_min ending at the tip
    translate([brick_l + shroud_len, tabp_y, 0]) intersection() {
        translate([0, tab_w, 0]) rotate([90, 0, 0]) linear_extrude(tab_w)
            polygon([[-0.5, 0], [tab_len + 0.5, 0], [tab_len + 0.5, tabp_h_min],
                     [tab_len - tabp_flat, tabp_h_min], [-0.5, tabp_h_max]]);
        translate([0, 0, -0.5]) linear_extrude(tabp_h_max + 1.5)
            _tab_plan(tab_len, tab_w, tip_right = true);
    }
    // cord shroud: flush with the bottom, 6 mm off the -y edge. Side profile
    // traced 2026-08-08: flat top at root height, knee curving down to the
    // 22.3-tall tip face (knee polyline is a conservative estimate).
    // Rounding: minkowski with a TOP-half sphere rounds every edge r2.5
    // except the floor perimeter, and keeps the floor itself flat. The
    // operand profile is shrunk by r on each affected side; the root end
    // overshoots into the body, which the union swallows.
    minkowski() {
        translate([brick_l, shroud_y0 + shroud_w - shroud_r, 0]) rotate([90, 0, 0])
            linear_extrude(shroud_w - 2 * shroud_r) polygon([
                [0, 0], [shroud_len - shroud_r, 0],
                [shroud_len - shroud_r, shroud_h_tip - shroud_r],
                [shroud_len - 14, shroud_h_root - 2 - shroud_r],
                [8, shroud_h_root - shroud_r], [0, shroud_h_root - shroud_r],
            ]);
        intersection() {
            sphere(shroud_r, $fn = 24);
            translate([-shroud_r, -shroud_r, 0])
                cube([2 * shroud_r, 2 * shroud_r, shroud_r]);
        }
    }
    // body cord strain relief stack: slab -> cylinder -> cord
    translate([brick_l - 0.5, cordA_y - srA_wh / 2, srA_top - srA_wh])
        cube([srA_rect_x + 0.5, srA_wh, srA_wh]);
    translate([brick_l + srA_rect_x - 0.5, cordA_y, cordA_z]) rotate([0, 90, 0])
        cylinder(h = srA_cyl_len + 0.5, d = srA_wh, $fn = 32);
    translate([brick_l + srA_rect_x + srA_cyl_len - 0.5, cordA_y, cordA_z])
        rotate([0, 90, 0]) cylinder(h = cord_stub, d = cord_d, $fn = 24);
    // shroud (output) cord
    translate([brick_l + shroud_len - 1, cordB_y, cordB_z]) rotate([0, 90, 0])
        cylinder(h = cord_stub + 1, d = cord_d, $fn = 24);
    // greeble on the tip face, +y of the tab: hollow cord hat, flat below
    // the axis plane
    translate([brick_l + shroud_len - 0.5, greeble_y, greeble_z]) difference() {
        intersection() {
            rotate([0, 90, 0]) {
                cylinder(h = greeble_shaft_len + 0.5, d = greeble_shaft_d, $fn = 32);
                translate([0, 0, greeble_shaft_len + 0.5])
                    cylinder(h = greeble_lip_len, d = greeble_lip_d, $fn = 32);
            }
            translate([-1, -greeble_lip_d, 0])
                cube([greeble_shaft_len + greeble_lip_len + 2, greeble_lip_d * 2, greeble_lip_d]);
        }
        rotate([0, 90, 0]) translate([0, 0, -1])
            cylinder(h = greeble_shaft_len + greeble_lip_len + 2.5, d = cord_d, $fn = 24);
    }
}

// ---------------- preview ----------------
// Included files render this too unless they set show_devices = false.
show_devices = true;
if (show_devices) {
    ont();
    translate([0, ont_w + 30, 0]) brick();
}
