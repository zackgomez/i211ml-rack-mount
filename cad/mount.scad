// mount.scad — 19" rack mount, RIGHT piece: the ONT cage.
// Style follows the UCG-Fiber modular mount: front panel printed flat on the
// bed, ventilated shelf + corner posts growing in +z, mating flange on the
// inner edge, rack ear on the outer edge. No supports.
//
// Model axes == print axes:
//   x = rack width, 0 at the joint (mating) edge, +x toward the rack ear
//   y = rack vertical, 0 at the panel bottom edge
//   z = rack depth, 0 at the panel front face (the build plate)

include <devices.scad>
show_devices = false;

show_ont = true;        // ghost ONT in preview (F5) only; absent from render/STL

// ---- rack geometry ----
panel_u = 1;            // 1 for cheap test prints; final target is 2
u_pitch = 44.45;
panel_h = panel_u * u_pitch - 0.8;
panel_t = 4;
rack_total_w = 482.6;   // full 19" panel width
hole_span = 465.1;      // rack hole centers
edge_to_hole = (rack_total_w - hole_span) / 2;   // 8.75

// Width split is ASYMMETRIC: a centered half offers only ~225 mm inside the
// rails and the ONT is 227 wide. This piece takes piece_w; the left piece
// gets rack_total_w - piece_w (~218 — brick chain is 184, fits).
piece_w = 265;
slot_x = piece_w - edge_to_hole;     // rack slot center, from the joint edge

// ---- hardware (specifics later) ----
rack_slot_w = 10;       // oval slots for M6 cage-nut screws
rack_slot_h = 7;
mate_hole_d = 5.3;      // M5 joint screws through the mating flange

// ---- cage ----
clr = 1.5;              // pocket clearance per side — pre-gauge estimate
wall = 4;
mate_wall_t = 6;                     // joint flange doubles as inner cage wall
bay_x0 = mate_wall_t;
bay_w = ont_l + 2 * clr;
bay_x1 = bay_x0 + bay_w;
cage_x1 = bay_x1 + wall;             // outer cage wall ends here
shelf_y0 = 2;
shelf_t = 4;
ont_y0 = shelf_y0 + shelf_t;         // ONT bottom
bay_d = ont_w + 2 * clr;
cage_z1 = panel_t + bay_d + wall;    // rear face of the rear posts
wall_top = ont_y0 + ont_h + 3;       // side walls end just above the ONT
mate_z1 = 64;                        // mating flange depth — needs more meat
                                     // once joint hardware is chosen
side_wall_z1 = 95;                   // outer wall stops here: the rear gap is
                                     // the fiber exit (SC/APC cover is on the
                                     // ONT's outer end face)

// Top eaves: narrow vaulted ledges along both side walls whose 45° underside
// lies parallel to (and just interferes with) the ONT's top-edge chamfers —
// slight friction fit hugging the chamfered edges, self-centering. The ONT
// slides in from the rear. Pure wall cross-section in print orientation.
eave_depth = 3;                      // how far the eave reaches over the bay
eave_squeeze = 0.2;                  // interference against the chamfer face
ont_top = ont_y0 + ont_h;
// contact height of the 45° underside at each wall face (same both sides,
// and at the panel rear face — front clearance is also clr)
eave_y = ont_top - ont_chamfer - clr - eave_squeeze;

// Front brow: extra meat on the panel's +y edge reaching +z past the ONT's
// front-top chamfer, grabbing it with the same 45°-parallel underside. Only
// OUTSIDE the LED window's x span — a full-width brow would sit behind the
// window and block the lights. Engages over the last ~7 mm of insertion.
brow_z1 = 14;                        // rear extent; chamfer face ends at 12.9

// LED window: the bevel is the ONT's top-front edge (chamfer face ~7.4)
win_y0 = ont_y0 + ont_h - 9;
win_y1 = ont_y0 + ont_h + 1.5;
win_x0 = bay_x0 + 12;
win_x1 = bay_x1 - 12;

// shelf venting
hex_af = 13;            // hexagon across-flats
hex_web = 3;            // material between hexes

echo(str("piece_w=", piece_w, " panel_h=", panel_h, " cage_z1=", cage_z1,
         " slot_x=", slot_x, " left piece width=", rack_total_w - piece_w));

module hex_holes(x0, x1, z0, z1) {
    px = hex_af + hex_web;
    pz = px * 0.866;
    for (row = [0 : floor((z1 - z0 - hex_af) / pz)])
        for (col = [0 : floor((x1 - x0 - hex_af) / px)]) {
            x = x0 + hex_af / 2 + col * px + (row % 2 == 0 ? 0 : px / 2);
            z = z0 + hex_af / 2 + row * pz;
            if (x + hex_af / 2 <= x1)
                translate([x, -1, z]) rotate([-90, 0, 0]) rotate([0, 0, 30])
                    cylinder(h = shelf_t + 4, d = hex_af / cos(30), $fn = 6);
        }
}

module rack_slot() {
    hull() {
        translate([-(rack_slot_w - rack_slot_h) / 2, 0, -1])
            cylinder(h = panel_t + 2, d = rack_slot_h, $fn = 24);
        translate([(rack_slot_w - rack_slot_h) / 2, 0, -1])
            cylinder(h = panel_t + 2, d = rack_slot_h, $fn = 24);
    }
}

module mount_right() {
    difference() {
        union() {
            cube([piece_w, panel_h, panel_t]);                       // panel
            cube([mate_wall_t, panel_h, mate_z1]);                   // joint flange / inner wall
            translate([0, shelf_y0, 0])                              // shelf
                cube([cage_x1, shelf_t, cage_z1]);
            translate([bay_x1, 0, 0])                                // outer cage wall,
                cube([wall, wall_top, side_wall_z1]);                // rear gap = fiber exit
        }
        // ONT bay (also trims lip overhang back to the bay)
        translate([bay_x0, ont_y0, panel_t])
            cube([bay_w, ont_h + clr, bay_d]);
        // LED window
        translate([win_x0, win_y0, -1])
            cube([win_x1 - win_x0, win_y1 - win_y0, panel_t + 2]);
        // rack slots
        for (y = [6.35, panel_h - 6.35])
            translate([slot_x, y, 0]) rack_slot();
        // M5 joint holes through the flange
        for (z = [20, mate_z1 - 16])
            translate([-1, panel_h / 2, z]) rotate([0, 90, 0])
                cylinder(h = mate_wall_t + 2, d = mate_hole_d, $fn = 24);
        // shelf vents
        hex_holes(bay_x0 + 8, cage_x1 - 8, panel_t + 8, cage_z1 - 8);
    }
    // top eaves (added after the bay cut — they intentionally reach into it)
    translate([0, 0, panel_t]) linear_extrude(side_wall_z1 - panel_t)
        polygon([[bay_x1, eave_y], [bay_x1 - eave_depth, eave_y + eave_depth],
                 [bay_x1 - eave_depth, wall_top], [bay_x1, wall_top]]);
    translate([0, 0, panel_t]) linear_extrude(mate_z1 - panel_t)
        polygon([[mate_wall_t, eave_y], [mate_wall_t + eave_depth, eave_y + eave_depth],
                 [mate_wall_t + eave_depth, wall_top], [mate_wall_t, wall_top]]);
    // front brow segments flanking the LED window
    for (xr = [[0, win_x0], [win_x1, cage_x1]])
        translate([xr[0], 0, 0]) rotate([90, 0, 90]) linear_extrude(xr[1] - xr[0])
            polygon([[eave_y, panel_t], [eave_y + brow_z1 - panel_t, brow_z1],
                     [panel_h, brow_z1], [panel_h, panel_t]]);
}

mount_right();

// ghost ONT in its pocket: model z (33) -> mount y, model y (148) -> mount z
if (show_ont && $preview)
    %translate([bay_x0 + clr, ont_y0, panel_t + clr + ont_w])
        rotate([-90, 0, 0]) ont();
