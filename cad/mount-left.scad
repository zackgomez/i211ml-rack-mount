// mount-left.scad — 19" rack mount, LEFT piece: power-brick enclosure.
// Same family as mount.scad (right piece / ONT cage): front panel printed
// flat on the bed, shelf + walls growing in +z, mating flange on the inner
// edge, rack ear on the outer edge. No supports. Authored directly as a
// left — no top-level mirror.
//
// Model axes == print axes (same as mount.scad):
//   x = rack width, 0 at the joint (mating) edge, +x toward the rack ear
//   y = rack vertical, 0 at the panel bottom edge
//   z = rack depth, 0 at the panel front face (the build plate)
//
// Brick orientation: devices.scad -x end (body tab) faces the rack FRONT,
// the cord/shroud end faces the rack REAR — both cords and the strain
// relief hang out the open rear. devices y spans rack width with the
// shroud side toward the joint, so the output cord exits next to the ONT
// half; devices z is rack-vertical. The brick slides in from the rear.

include <devices.scad>
show_devices = false;

show_brick = true;      // ghost brick in preview (F5) only; not in render/STL

// ---- rack geometry (keep in sync with mount.scad) ----
panel_u = 2;            // the brick is 44 tall — 2U only
u_pitch = 44.45;
panel_h = panel_u * u_pitch - 0.8;
panel_t = 4;
rack_total_w = 482.6;
hole_span = 465.1;
edge_to_hole = (rack_total_w - hole_span) / 2;   // 8.75
right_piece_w = 265;                     // = mount.scad piece_w
piece_w = rack_total_w - right_piece_w;  // 217.6
slot_x = piece_w - edge_to_hole;         // rack slot center, from the joint edge

rack_slot_w = 10;       // oval slots for M6 cage-nut screws
rack_slot_h = 7;

// ---- joint: this piece carries the nuts ----
// M5 screws come through the right piece's 6-thick flange; hex pockets here
// hold the nuts, UCG-Fiber left-module style. Hole y/z MUST match mount.scad
// (y = panel_h/2, z = 20 and mate_z1 - 16 = 48).
mate_hole_d = 5.3;
mate_hole_z = [20, 48];
flange_t = 10;          // "more meat" than the right piece's 6
flange_z1 = 64;         // = mount.scad mate_z1
nut_af = 8.4;           // M5 nut is 8.0 across flats — tune for press fit
nut_pocket_t = 6;       // pocket depth; the 4-thick web puts an M5x16 tip
                        // flush with the flange's corridor-side face

// Nut-access corridor: open gap between the flange and the inner cage wall
// so nuts drop into their pockets from above/rear even with the brick
// installed and the halves joined.
corridor_w = 14;

// ---- cage ----
clr = 1.5;              // pocket clearance per side (matches right piece)
wall = 4;
shelf_y0 = 2;
shelf_t = 4;
shelf_top = shelf_y0 + shelf_t;

bay_x0 = flange_t + corridor_w + wall;   // inner wall's bay face
bay_w = brick_w + 2 * clr;
bay_x1 = bay_x0 + bay_w;
cage_x1 = bay_x1 + wall;

// depth chain: panel, front wall (tab seat), body, open rear
tab_clr = 1;                       // gap from panel rear face to the tab tip
front_t = tab_len + tab_clr;       // front wall thickness in z
body_z0 = panel_t + front_t;       // brick body front face
body_z1 = body_z0 + brick_l;
wall_z1 = body_z1;                 // walls + eaves stop at the body rear face
shelf_z1 = body_z1 + 12;           // shelf runs on under the shroud root

brick_top = shelf_top + brick_h;
wall_top = brick_top + 8;          // low walls — 2U leaves ~30 open above

// ---- retention ----
// Side eaves over the brick's 6 mm top-perimeter chamfer: same 45°-parallel
// underside and tuning knob as the right piece.
eave_depth = 3;
eave_squeeze = -0.1;    // +interference / -clearance against the chamfer face
eave_y = brick_top - brick_chamfer - clr - eave_squeeze;

// The front wall doubles as the tab seat: the -x wall-box tab passes through
// a slot to 1 mm short of the panel, and a bar over the tab's 4 mm flat tip
// holds the nose down (redundant with the eaves, but free).
slot_fit = 0.5;                        // per side around the tab
tab_slot_x0 = bay_x0 + clr + (brick_w - tab_w) / 2 - slot_fit;
tab_slot_w = tab_w + 2 * slot_fit;
bar_z1 = panel_t + 4;                  // bar depth = the flat run at the tip
bar_y = shelf_top + tabm_h_min + 0.5;  // bar underside just over the flat tip
slot_y1 = shelf_top + tabm_h_max + 1.5;

// Front brow over the brick's front-top chamfer (right piece's brow trick).
// Full bay width — nothing to see on the brick's front face.
brow_z1 = body_z0 + brick_chamfer + 1;

// ---- keystone ----
// RJ45 handoff: patch cable from the ONT's rear GigE port to a keystone
// jack in this panel's free area. Jack snaps in from the rear onto the
// 1.6 web; the rear pocket clears the latch arms either way up.
key_x = 158;                     // center; free zone runs ~123..196
key_y = panel_h / 2;
key_w = 15.0;                    // through-opening
key_h = 16.5;
key_web = 1.6;                   // front web the keystone clips onto
key_pocket_w = 22;               // rear relief around the clip arms
key_pocket_h = 30;

// ---- shelf venting + zip anchors ----
hex_af = 13;            // hexagon across-flats
hex_web = 3;            // material between hexes
// Two slots just behind the body: a tie bridges them over the AC cord
// (which exits at x ~104) and closes under the shelf — cord strain lands
// on the mount, not on the brick.
zip_slot = [6, 3];      // x, z
zip_x = [96, 110];
zip_z0 = body_z1 + 3.5;

echo(str("piece_w=", piece_w, " panel_h=", panel_h, " bay_x0=", bay_x0,
         " cage_x1=", cage_x1, " body_z1=", body_z1, " shelf_z1=", shelf_z1,
         " eave_y=", eave_y, " slot_x=", slot_x, " key_x=", key_x));

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

module mount_left() {
    difference() {
        union() {
            cube([piece_w, panel_h, panel_t]);                   // panel
            cube([flange_t, panel_h, flange_z1]);                // joint flange
            translate([0, shelf_y0, 0])                          // shelf
                cube([cage_x1, shelf_t, shelf_z1]);
            translate([bay_x0 - wall, shelf_y0, 0])              // inner wall
                cube([wall, wall_top - shelf_y0, wall_z1]);
            translate([bay_x1, shelf_y0, 0])                     // outer wall
                cube([wall, wall_top - shelf_y0, wall_z1]);
            // front wall + brow: tab seat, forward stop, chamfer grab
            translate([bay_x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(bay_w)
                polygon([[shelf_y0, 0], [shelf_y0, body_z0],
                         [eave_y, body_z0], [eave_y + brow_z1 - body_z0, brow_z1],
                         [wall_top, brow_z1], [wall_top, 0]]);
        }
        // tab slot through the front wall: tip channel under the bar, then
        // full-height clearance for the wedge
        translate([tab_slot_x0, shelf_top, panel_t])
            cube([tab_slot_w, bar_y - shelf_top, bar_z1 - panel_t]);
        translate([tab_slot_x0, shelf_top, bar_z1])
            cube([tab_slot_w, slot_y1 - shelf_top, body_z0 - bar_z1 + 1]);
        // keystone: opening through the front web, relief pocket behind
        translate([key_x - key_w / 2, key_y - key_h / 2, -1])
            cube([key_w, key_h, key_web + 1]);
        translate([key_x - key_pocket_w / 2, key_y - key_pocket_h / 2, key_web])
            cube([key_pocket_w, key_pocket_h, panel_t - key_web + 1]);
        // rack slots
        for (y = [6.35, panel_h - 6.35])
            translate([slot_x, y, 0]) rack_slot();
        // M5 holes + hex nut pockets (point-up hexes print clean)
        for (z = mate_hole_z) {
            translate([-1, panel_h / 2, z]) rotate([0, 90, 0])
                cylinder(h = flange_t + 2, d = mate_hole_d, $fn = 24);
            translate([flange_t - nut_pocket_t, panel_h / 2, z]) rotate([0, 90, 0])
                cylinder(h = nut_pocket_t + 0.01, d = nut_af / cos(30), $fn = 6);
        }
        // shelf vents
        hex_holes(bay_x0 + 8, bay_x1 - 8, body_z0 + 8, body_z1 - 8);
        // zip-tie slots
        for (x = zip_x)
            translate([x - zip_slot[0] / 2, shelf_y0 - 1, zip_z0])
                cube([zip_slot[0], shelf_t + 2, zip_slot[1]]);
    }
    // side eaves (added after the cuts — they intentionally reach into the bay)
    translate([0, 0, panel_t]) linear_extrude(wall_z1 - panel_t)
        polygon([[bay_x0, eave_y], [bay_x0 + eave_depth, eave_y + eave_depth],
                 [bay_x0 + eave_depth, wall_top], [bay_x0, wall_top]]);
    translate([0, 0, panel_t]) linear_extrude(wall_z1 - panel_t)
        polygon([[bay_x1, eave_y], [bay_x1 - eave_depth, eave_y + eave_depth],
                 [bay_x1 - eave_depth, wall_top], [bay_x1, wall_top]]);
}

module assembly() {
    mount_left();
    // ghost brick in its pocket: devices x -> mount z, y -> x, z -> y
    if (show_brick && $preview)
        %translate([bay_x0 + clr, shelf_top, body_z0])
            rotate([0, -90, -90]) brick();
}

assembly();
