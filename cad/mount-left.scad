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
// The bay sits OUTBOARD (against the rack ear) so the brick's weight is
// close to the mounting hardware; the keystone takes the joint side.

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

rack_slot_w = 14;       // oval slots for M6 cage-nut screws; wide like the
rack_slot_h = 7;        // UCG mount's 13 x 6.5 — horizontal play absorbs
                        // rack tolerance + ASA shrink over the panel width

// ---- joint: this piece carries the nuts ----
// M5 screws come through the right piece's 6-thick flange; hex pockets here
// hold the nuts, UCG-Fiber left-module style. Hole y/z MUST match mount.scad
// (y = panel_h/2, z = 20 and mate_z1 - 16 = 48).
mate_hole_d = 5.3;
mate_hole_z = [20, 48];
flange_t = 10;          // "more meat" than the right piece's 6
flange_z1 = 64;         // = mount.scad mate_z1
nut_af = 8.2;           // M5 nut is 8.0 across flats; the UCG mount's pockets
                        // measure ~8.1 and press-fit on this printer (in-plane
                        // holes print ~0.2 under) — tune here if loose/tight
nut_pocket_t = 6;       // pocket depth; the 4-thick web puts an M5x16 tip
                        // flush with the flange's inner face

// Joint ramps: UCG-style gussets bracing the flange to the panel, one near
// each panel edge, inset in y. Full flange depth at the flange; the free
// edge is a concave quarter-circle fillet running out to the panel — a
// little over half the plastic of the straight-hypotenuse triangle.
ramp_t = 6;
ramp_x1 = panel_u == 1 ? 44 : 70;  // shorter runout at 1U clears the
                                   // keystone boss (which shifts to x=60)
ramp_inset = 6;

// corner-rounding pass
panel_r = 4;            // panel's outer corners (small enough to keep the
                        // web at the ear slots' outer ends)
cage_r = 8;             // cage top-rear corner, across walls + eaves
cage_er = 2;            // cage outer edges: wall top-outer (along z) and
                        // rear vertical (along y)
flange_r = 6;           // flange rear corners (= ramp_inset, so the cuts
                        // land tangent to the ramps)
shelf_r = 6;            // shelf rear corners
boss_r = 3;             // keystone boss

// ---- cage ----
clr = 1.5;              // pocket clearance per side (matches right piece)
wall = 4;
// 1U: the brick (44) is taller than a 1U panel (43.65) — it fits only by
// poaching the inter-U slack. The brick rides 2 below the panel's bottom
// edge (the U below is empty) and tops out ~2.4 under the neighbor panel
// above; the UCG mount's rear structure starts 1.75 above its own panel
// edge, so real clearance there is ~4. Floor and walls start behind the
// panel (z >= panel_t) so nothing shows under the panel from the front.
shelf_y0 = panel_u == 1 ? -6 : 2;
shelf_t = 4;
shelf_top = shelf_y0 + shelf_t;
wall_y0 = panel_u == 1 ? shelf_top : shelf_y0;
struct_z0 = panel_u == 1 ? panel_t : 0;   // sub-panel structure stays hidden

// The cage sits just inboard of the rack ear: the UCG mount's structure
// stops 22.9 from the panel edge and clears the rack post in this rack, so
// 23 is the proven minimum — 30 buys a little extra room at the post.
ear_clear = 30;
bay_w = brick_w + 2 * clr;
cage_x1 = piece_w - ear_clear;
bay_x1 = cage_x1 - wall;
bay_x0 = bay_x1 - bay_w;

// depth chain: panel, front wall (tab seat), body, open rear. The tab tip
// rides to 2 from the panel FRONT face — its slot pockets into the panel's
// back, leaving a 2 web — which keeps the front wall thin.
tab_tip_z = 2;
body_z0 = tab_tip_z + tab_len;     // brick body front face
body_z1 = body_z0 + brick_l;
wall_z1 = body_z1;                 // walls + eaves stop at the body rear face
shelf_z1 = body_z1 + 12;           // shelf runs on under the shroud root

brick_top = shelf_top + brick_h;
wall_top = min(brick_top + 4, panel_h);   // low walls; capped at the panel
                                          // top for the 1U squeeze

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
bar_z1 = tab_tip_z + tabm_flat;        // bar covers the flat run at the tip
bar_y = shelf_top + tabm_h_min + 0.5;  // bar underside just over the flat tip
slot_y1 = shelf_top + tabm_h_max + 1.5;

// Front brow over the brick's front-top chamfer (right piece's brow trick).
// Full bay width — nothing to see on the brick's front face.
brow_z1 = body_z0 + brick_chamfer + 1;

// ---- keystone ----
// RJ45 handoff: patch cable from the ONT's rear GigE port to a keystone
// jack, joint side of the panel, face to the rack front, latch side DOWN.
// Slot geometry is measured off the UCG-Fiber "Shelf Keystone x6" left
// module (rack-proven on this printer, and nicer than a flat-lip slot):
// no tuned lip — the jack's teeth wedge against tapered clamp faces, so
// the fit self-tightens — plus a rear plate whose 19.8 x 15 window guides
// the jack in from behind. Cut into a 9.5-thick boss on the panel rear.
key_x = panel_u == 1 ? 60 : 52;  // center; free zone runs ~10..95 (at 1U,
                                 // past the shortened ramps)
key_y = panel_h / 2;
key_W = 15.0;                    // opening width (constant, full depth)
key_d = 9.5;                     // boss depth = slot depth
key_boss = [30, 34];             // boss footprint (x, y)

// ---- shelf venting + zip anchors ----
hex_af = 13;            // hexagon across-flats
hex_web = 3;            // material between hexes
// Two slots just behind the body: a tie bridges them over the AC cord
// and closes under the shelf — cord strain lands on the mount, not on
// the brick.
zip_slot = [6, 3];      // x, z
zip_x = [bay_x0 + clr + cordA_y - 8, bay_x0 + clr + cordA_y + 8];
zip_z0 = body_z1 + 3.5;

echo(str("piece_w=", piece_w, " panel_h=", panel_h, " bay_x0=", bay_x0,
         " cage_x1=", cage_x1, " body_z1=", body_z1, " shelf_z1=", shelf_z1,
         " eave_y=", eave_y, " slot_x=", slot_x, " key_x=", key_x,
         " zip_x=", zip_x));

module hex_holes(x0, x1, z0, z1) {
    px = hex_af + hex_web;
    pz = px * 0.866;
    for (row = [0 : floor((z1 - z0 - hex_af) / pz)])
        for (col = [0 : floor((x1 - x0 - hex_af) / px)]) {
            x = x0 + hex_af / 2 + col * px + (row % 2 == 0 ? 0 : px / 2);
            z = z0 + hex_af / 2 + row * pz;
            if (x + hex_af / 2 <= x1)
                translate([x, shelf_y0 - 1, z]) rotate([-90, 0, 0]) rotate([0, 0, 30])
                    cylinder(h = shelf_t + 2, d = hex_af / cos(30), $fn = 6);
        }
}

// Keystone slot void, measured off the UCG "Shelf Keystone x6" module:
// opening centered at the origin, panel front face at z=0, +z into the
// panel, latch side at -y (rack DOWN), hook side at +y. The cavity is
// 24.3 tall; the front web tapers from the face opening out to the cavity
// walls (hook side 6.35 -> 12.15 over z 0..4.88, latch side 10.15 ->
// 12.15 over z 0..2), and the teeth clamp those tapers. A rear plate
// (z 8..9.5) leaves a 19.8-tall insertion window. Subtract from a wall
// key_d thick; the rear plate's 2ish overhang over the cavity bridges
// fine, as on the UCG print.
module keystone_void() {
    translate([-key_W / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(key_W)
        polygon([
            [-10.15, -1], [-10.15, 0], [-12.15, 2.0], [-12.15, 8.1],
            [-9.65, 8.1], [-9.65, key_d + 1],
            [10.15, key_d + 1], [10.15, 8.0],
            [12.15, 8.0], [12.15, 4.88], [6.35, 0], [6.35, -1],
        ]);
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
            linear_extrude(panel_t) hull() {                     // panel, outer
                square([piece_w - panel_r, panel_h]);            // corners round
                for (y = [panel_r, panel_h - panel_r])
                    translate([piece_w - panel_r, y]) circle(panel_r, $fn = 48);
            }
            cube([flange_t, panel_h, flange_z1]);                // joint flange
            for (y1 = [ramp_inset + ramp_t, panel_h - ramp_inset])  // joint ramps
                translate([0, y1, 0]) rotate([90, 0, 0])
                    linear_extrude(ramp_t) polygon(concat(
                        [[0, 0], [0, flange_z1]],
                        [for (a = [0 : 5 : 90])                  // concave fillet
                            [ramp_x1 - (ramp_x1 - flange_t) * cos(a),
                             flange_z1 - (flange_z1 - panel_t) * sin(a)]],
                        [[ramp_x1, 0]]));
            translate([key_x - key_boss[0] / 2, key_y - key_boss[1] / 2, 0])
                linear_extrude(key_d)                            // keystone boss
                    offset(r = boss_r) offset(delta = -boss_r) square(key_boss);
            translate([bay_x0 - wall, shelf_top, 0])             // shelf, cage
                rotate([90, 0, 0]) linear_extrude(shelf_t) hull() {  // only, rear
                    sw = cage_x1 - bay_x0 + wall;                // corners round
                    translate([0, struct_z0])
                        square([sw, shelf_z1 - shelf_r - struct_z0]);
                    for (x = [shelf_r, sw - shelf_r])
                        translate([x, shelf_z1 - shelf_r]) circle(shelf_r, $fn = 32);
                }
            translate([bay_x0 - wall, wall_y0, struct_z0])       // inner wall
                cube([wall, wall_top - wall_y0, wall_z1 - struct_z0]);
            translate([bay_x1, wall_y0, struct_z0])              // outer wall
                cube([wall, wall_top - wall_y0, wall_z1 - struct_z0]);
            // front wall + brow: tab seat, forward stop, chamfer grab (at 1U
            // its below-panel portion steps back behind the panel face)
            translate([bay_x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(bay_w)
                polygon(panel_u == 1
                    ? [[0, 0], [0, panel_t], [shelf_top, panel_t],
                       [shelf_top, body_z0], [eave_y, body_z0],
                       [eave_y + brow_z1 - body_z0, brow_z1],
                       [wall_top, brow_z1], [wall_top, 0]]
                    : [[shelf_y0, 0], [shelf_y0, body_z0],
                       [eave_y, body_z0], [eave_y + brow_z1 - body_z0, brow_z1],
                       [wall_top, brow_z1], [wall_top, 0]]);
            // side eaves (they intentionally reach into the bay)
            translate([0, 0, panel_t]) linear_extrude(wall_z1 - panel_t)
                polygon([[bay_x0, eave_y], [bay_x0 + eave_depth, eave_y + eave_depth],
                         [bay_x0 + eave_depth, wall_top], [bay_x0, wall_top]]);
            translate([0, 0, panel_t]) linear_extrude(wall_z1 - panel_t)
                polygon([[bay_x1, eave_y], [bay_x1 - eave_depth, eave_y + eave_depth],
                         [bay_x1 - eave_depth, wall_top], [bay_x1, wall_top]]);
        }
        // tab slot through the front wall: tip channel under the bar (its
        // first 2 pocketing into the panel back), then full-height
        // clearance for the wedge
        translate([tab_slot_x0, shelf_top, tab_tip_z])
            cube([tab_slot_w, bar_y - shelf_top, bar_z1 - tab_tip_z]);
        translate([tab_slot_x0, shelf_top, bar_z1])
            cube([tab_slot_w, slot_y1 - shelf_top, body_z0 - bar_z1 + 1]);
        // keystone slot
        translate([key_x, key_y, 0]) keystone_void();
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
        // shelf vents (6 side margin squeezes in a fifth hex column)
        hex_holes(bay_x0 + 6, bay_x1 - 6, body_z0 + 8, body_z1 - 8);
        // zip-tie slots
        for (x = zip_x)
            translate([x - zip_slot[0] / 2, shelf_y0 - 1, zip_z0])
                cube([zip_slot[0], shelf_t + 2, zip_slot[1]]);
        // round the cage's top-rear corner, across walls + eaves in one cut
        difference() {
            translate([bay_x0 - wall - 1, wall_top - cage_r, wall_z1 - cage_r])
                cube([cage_x1 - bay_x0 + wall + 2, cage_r + 1, cage_r + 1]);
            translate([bay_x0 - wall - 2, wall_top - cage_r, wall_z1 - cage_r])
                rotate([0, 90, 0])
                    cylinder(h = cage_x1 - bay_x0 + wall + 4, r = cage_r, $fn = 48);
        }
        // round the cage's outer edges: the walls' top-outer edges (along z,
        // starting behind the panel) and rear vertical edges (above the
        // shelf). The straight runs stop where the big r8 corner round
        // begins; a quarter-torus section sweeps the same edge round along
        // the r8 arc so the small round follows the big one seamlessly.
        for (p = [[bay_x0 - wall, 1], [cage_x1, -1]]) {
            xc = p[0] + p[1] * cage_er;         // cylinder center x
            xb = p[1] > 0 ? p[0] - 1 : p[0] - cage_er;   // cutter block x0
            difference() {
                translate([xb, wall_top - cage_er, panel_t])
                    cube([cage_er + 1, cage_er + 1,
                          wall_z1 - cage_r - panel_t + 0.01]);
                translate([xc, wall_top - cage_er, panel_t - 0.5])
                    cylinder(h = wall_z1 - cage_r - panel_t + 1, r = cage_er,
                             $fn = 24);
            }
            difference() {
                translate([xb, shelf_top, wall_z1 - cage_er])
                    cube([cage_er + 1, wall_top - cage_r - shelf_top + 0.01,
                          cage_er + 1]);
                translate([xc, shelf_top - 0.5, wall_z1 - cage_er]) rotate([-90, 0, 0])
                    cylinder(h = wall_top - cage_r - shelf_top + 1, r = cage_er,
                             $fn = 24);
            }
            translate([0, wall_top - cage_r, wall_z1 - cage_r]) rotate([90, 0, 90])
                rotate_extrude(angle = 90, $fn = 48) difference() {
                    translate([cage_r - cage_er, min(xb, xc)])
                        square([cage_er + 1, cage_er + 1]);
                    translate([cage_r - cage_er, xc]) circle(cage_er, $fn = 24);
                }
        }
        // round the flange's rear corners (tangent to the inset ramps)
        difference() {
            translate([-1, panel_h - flange_r, flange_z1 - flange_r])
                cube([flange_t + 2, flange_r + 1, flange_r + 1]);
            translate([-2, panel_h - flange_r, flange_z1 - flange_r])
                rotate([0, 90, 0]) cylinder(h = flange_t + 4, r = flange_r, $fn = 48);
        }
        difference() {
            translate([-1, -1, flange_z1 - flange_r])
                cube([flange_t + 2, flange_r + 1, flange_r + 1]);
            translate([-2, flange_r, flange_z1 - flange_r])
                rotate([0, 90, 0]) cylinder(h = flange_t + 4, r = flange_r, $fn = 48);
        }
    }
}

module assembly() {
    mount_left();
    // ghost brick in its pocket: devices x -> mount z, y -> x, z -> y
    if (show_brick && $preview)
        %translate([bay_x0 + clr, shelf_top, body_z0])
            rotate([0, -90, -90]) brick();
}

assembly();
