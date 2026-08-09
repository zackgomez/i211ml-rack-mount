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
right_half = true;      // mirror so the cage lands on the RACK-RIGHT side as
                        // seen from the front (unmirrored geometry is a left)

// ---- rack geometry ----
panel_u = 1;            // 1U primary — the final target (2 still renders)
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
rack_slot_w = 14;       // oval slots for M6 cage-nut screws — widened for
                        // horizontal play, UCG-style (Zack-general policy;
                        // matches mount-left). Outer web to panel edge is
                        // ~1.75 — same on both pieces, watch on test prints
rack_slot_h = 7;
mate_hole_d = 5.3;      // M5 joint screws through the mating flange
cbore_d = 10.8;         // button-head inset in the flange's bay-side face:
cbore_t = 3;            // ISO 7380 head is 9.5 x 2.75 and the bay clearance
                        // is only 1.5, so the head must sit sub-flush; +0.2
                        // on the bore for in-plane print shrink. M5x16 still
                        // works — the tip ends ~1 proud of the left flange's
                        // inner face, in open air

// ---- cage ----
clr = 1.5;              // pocket clearance per side — confirmed by test print
wall = 4;
mate_wall_t = 8;                     // joint flange doubles as inner cage wall.
                                     // Mates mount-left's 10-thick flange
                                     // (4 web + 6 hex pocket, M5 nut AF 8.4):
                                     // M5x16 through 8+10 ends at the nut's
                                     // far face. Holes y=panel_h/2, z 20/48
                                     // on both pieces — aligns once both run
                                     // panel_u=2
bay_x0 = mate_wall_t;
bay_w = ont_l + 2 * clr;
bay_x1 = bay_x0 + bay_w;
cage_x1 = bay_x1 + wall;             // outer cage wall ends here
shelf_y0 = 2;
shelf_t = 4;
ont_y0 = shelf_y0 + shelf_t + foot_h;   // ONT body bottom — it rides on its
                                        // feet; bottom bosses hover
bay_d = ont_w + 2 * clr;
cage_z1 = panel_t + bay_d + wall;
mate_z1 = 64;                        // mating flange depth. Joint hardware:
                                     // M5x16 button head inset here, nut in
                                     // the left flange's hex pocket
side_wall_z1 = panel_t + clr + ont_w;   // walls + eaves run the full bay
                                     // depth and stop at the ONT's rear
                                     // face, brick-cage style; the rear is
                                     // fully open (fiber, coax, and cords
                                     // all dress off the back)

// Top eaves: narrow vaulted ledges along both side walls whose 45° underside
// lies parallel to (and just interferes with) the ONT's top-edge chamfers —
// slight friction fit hugging the chamfered edges, self-centering. The ONT
// slides in from the rear. Pure wall cross-section in print orientation.
eave_depth = 3;                      // how far the eave reaches over the bay
eave_squeeze = -0.1;                 // interference against the chamfer face.
                                     // +0.2 printed OVERLY tight (v1 test);
                                     // slight clearance now — tune here
ont_top = ont_y0 + ont_h;
// contact height of the 45° underside at each wall face (same both sides,
// and at the panel rear face — front clearance is also clr)
eave_y = ont_top - ont_chamfer - clr - eave_squeeze;
// Low ceiling: walls/eaves stop 3 past the eave slope — all the capture is
// in the chamfer grab. The ONT's chamfered top stands ~2.8 proud of the
// walls. (The flange stays full panel height for the joint; the brow is
// panel-face material and keeps the panel's full height.)
wall_top = eave_y + eave_depth + 3;

// Front brow: extra meat on the panel's +y edge reaching +z past the ONT's
// front-top chamfer, grabbing it with the same 45°-parallel underside. Only
// OUTSIDE the LED window's x span — a full-width brow would sit behind the
// window and block the lights. Engages over the last ~7 mm of insertion.
brow_z1 = 14;                        // rear extent; chamfer face ends at 12.9

// LED window: the bevel is the ONT's top-front edge (chamfer face ~7.4).
// Cap below the panel top so no fragile sliver strip remains above it.
win_y0 = ont_y0 + ont_h - 9;
win_y1 = min(ont_y0 + ont_h + 1.5, panel_h - 2);
win_x0 = bay_x0 + 12;
win_x1 = bay_x1 - 12;

// ---- wall hollowing ----
// Brick-cage treatment: elongated-hex windows through the side walls' free
// spans — the 45° pointed ends grow and close printably in the per-layer
// cross-section (no flat bridges, just a ~6 chord at each rounded tip) —
// with rails tied to the shelf, eave, and rear-round lines. The outer wall
// carries two windows; the inner wall carries one behind the flange (the
// joint stays solid), z-aligned with the outer rear window so the cutouts
// read straight through the cage.
win_r = 4;              // corner rounding, all cutout edges
wwin_y0 = shelf_y0 + shelf_t + 4;    // rail above the shelf junction
wwin_y1 = eave_y - 3;                // rail below the eave slope
wwin_z1 = side_wall_z1 - 8;          // rear rail, sized with the r8 round
owin_z0 = 12;                        // outer wall front rail: 8 past the panel
owin_w = (wwin_z1 - owin_z0 - 8) / 2;   // two windows, 8 rib between
iwin_z0 = owin_z0 + owin_w + 8;

// corner-rounding pass (mount-left's vocabulary)
panel_r = 4;            // panel's outer corners
cage_r = 8;             // cage top-rear corner, across walls + eaves
cage_er = 2;            // wall outer edges: top-outer (along z) and rear
                        // vertical (above the shelf)
flange_r = 6;           // flange top-rear corner (the bottom one dies
                        // into the shelf)
shelf_r = 6;            // shelf rear corners

// shelf venting
hex_af = 13;            // hexagon across-flats
hex_web = 3;            // material between hexes

// Solid landing pads in the hex field where the feet stand
foot_keepout_r = foot_d / 2 + hex_af / 2 + 3;
foot_pads = [for (p = ont_feet)
    [bay_x0 + clr + p[0], panel_t + clr + ont_w - p[1]]];

echo(str("piece_w=", piece_w, " panel_h=", panel_h, " cage_z1=", cage_z1,
         " slot_x=", slot_x, " left piece width=", rack_total_w - piece_w));

module hex_holes(x0, x1, z0, z1) {
    px = hex_af + hex_web;
    pz = px * 0.866;
    for (row = [0 : floor((z1 - z0 - hex_af) / pz)])
        for (col = [0 : floor((x1 - x0 - hex_af) / px)]) {
            x = x0 + hex_af / 2 + col * px + (row % 2 == 0 ? 0 : px / 2);
            z = z0 + hex_af / 2 + row * pz;
            clear_of_feet = min([for (p = foot_pads) norm([x - p[0], z - p[1]])])
                            > foot_keepout_r;
            if (x + hex_af / 2 <= x1 && clear_of_feet)
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
            difference() {
                union() {
                    linear_extrude(panel_t) hull() {                 // panel, outer
                        square([piece_w - panel_r, panel_h]);        // corners round
                        for (y = [panel_r, panel_h - panel_r])
                            translate([piece_w - panel_r, y])
                                circle(panel_r, $fn = 48);
                    }
                    cube([mate_wall_t, panel_h, mate_z1]);           // joint flange
                    translate([mate_wall_t - wall, shelf_y0, mate_z1])  // inner wall
                        cube([wall, wall_top - shelf_y0,             // runs on past
                              side_wall_z1 - mate_z1]);              // the flange
                    translate([0, shelf_y0 + shelf_t, 0])            // shelf, rear
                        rotate([90, 0, 0]) linear_extrude(shelf_t) hull() {  // corners round
                            square([cage_x1, cage_z1 - shelf_r]);
                            for (x = [shelf_r, cage_x1 - shelf_r])
                                translate([x, cage_z1 - shelf_r])
                                    circle(shelf_r, $fn = 32);
                        }
                    translate([bay_x1, shelf_y0, 0])                 // outer cage wall
                        cube([wall, wall_top - shelf_y0, side_wall_z1]);
                }
                // ONT bay, including the foot zone above the shelf
                translate([bay_x0, shelf_y0 + shelf_t, panel_t])
                    cube([bay_w, foot_h + ont_h + clr, bay_d]);
                // LED window
                translate([win_x0, win_y0, -1])
                    cube([win_x1 - win_x0, win_y1 - win_y0, panel_t + 2]);
                // rack slots
                for (y = [6.35, panel_h - 6.35])
                    translate([slot_x, y, 0]) rack_slot();
                // M5 joint holes through the flange + button-head insets
                for (z = [20, mate_z1 - 16]) {
                    translate([-1, panel_h / 2, z]) rotate([0, 90, 0])
                        cylinder(h = mate_wall_t + 2, d = mate_hole_d, $fn = 24);
                    translate([mate_wall_t - cbore_t, panel_h / 2, z])
                        rotate([0, 90, 0])
                            cylinder(h = cbore_t + 1, d = cbore_d, $fn = 48);
                }
                // shelf vents
                hex_holes(bay_x0 + 8, cage_x1 - 8, panel_t + 8, cage_z1 - 8);
            }
            // top eaves (added after the bay cut — they intentionally reach
            // into it), full bay depth like the walls
            translate([0, 0, panel_t]) linear_extrude(side_wall_z1 - panel_t)
                polygon([[bay_x1, eave_y], [bay_x1 - eave_depth, eave_y + eave_depth],
                         [bay_x1 - eave_depth, wall_top], [bay_x1, wall_top]]);
            translate([0, 0, panel_t]) linear_extrude(side_wall_z1 - panel_t)
                polygon([[mate_wall_t, eave_y], [mate_wall_t + eave_depth, eave_y + eave_depth],
                         [mate_wall_t + eave_depth, wall_top], [mate_wall_t, wall_top]]);
            // front brow segments flanking the LED window (panel-face
            // material, full panel height — above the low wall ceiling)
            for (xr = [[0, win_x0], [win_x1, cage_x1]])
                translate([xr[0], 0, 0]) rotate([90, 0, 90]) linear_extrude(xr[1] - xr[0])
                    polygon([[eave_y, panel_t], [eave_y + brow_z1 - panel_t, brow_z1],
                             [panel_h, brow_z1], [panel_h, panel_t]]);
        }
        // side-wall windows: outer wall two, inner wall one past the
        // flange, z-aligned with the outer rear window
        for (p = [[bay_x1 - 1, owin_z0], [bay_x1 - 1, iwin_z0],
                  [mate_wall_t - wall - 1, iwin_z0]]) {
            hh = (wwin_y1 - wwin_y0) / 2;
            translate([p[0], 0, 0]) rotate([90, 0, 90]) linear_extrude(wall + 2)
                offset(r = win_r) offset(delta = -win_r) polygon([
                    [wwin_y0 + hh, p[1]],
                    [wwin_y1, p[1] + hh], [wwin_y1, p[1] + owin_w - hh],
                    [wwin_y0 + hh, p[1] + owin_w],
                    [wwin_y0, p[1] + owin_w - hh], [wwin_y0, p[1] + hh]]);
        }
        // round the cage's top-rear corner, across walls + eaves in one cut
        difference() {
            translate([mate_wall_t - wall - 1, wall_top - cage_r, side_wall_z1 - cage_r])
                cube([cage_x1 - mate_wall_t + wall + 2, cage_r + 1, cage_r + 1]);
            translate([mate_wall_t - wall - 2, wall_top - cage_r, side_wall_z1 - cage_r])
                rotate([0, 90, 0])
                    cylinder(h = cage_x1 - mate_wall_t + wall + 4, r = cage_r, $fn = 48);
        }
        // round the walls' outer edges: top-outer along z and rear verticals
        // above the shelf, a quarter-torus following the r8 arc between
        // them (the inner wall's runs start where it emerges past the
        // flange; the outer wall's behind the panel)
        for (p = [[mate_wall_t - wall, 1, mate_z1], [cage_x1, -1, panel_t]]) {
            xc = p[0] + p[1] * cage_er;
            xb = p[1] > 0 ? p[0] - 1 : p[0] - cage_er;
            difference() {
                translate([xb, wall_top - cage_er, p[2]])
                    cube([cage_er + 1, cage_er + 1,
                          side_wall_z1 - cage_r - p[2] + 0.01]);
                translate([xc, wall_top - cage_er, p[2] - 0.5])
                    cylinder(h = side_wall_z1 - cage_r - p[2] + 1, r = cage_er,
                             $fn = 24);
            }
            difference() {
                translate([xb, shelf_y0 + shelf_t, side_wall_z1 - cage_er])
                    cube([cage_er + 1,
                          wall_top - cage_r - shelf_y0 - shelf_t + 0.01,
                          cage_er + 1]);
                translate([xc, shelf_y0 + shelf_t - 0.5, side_wall_z1 - cage_er])
                    rotate([-90, 0, 0])
                        cylinder(h = wall_top - cage_r - shelf_y0 - shelf_t + 1,
                                 r = cage_er, $fn = 24);
            }
            translate([0, wall_top - cage_r, side_wall_z1 - cage_r]) rotate([90, 0, 90])
                rotate_extrude(angle = 90, $fn = 48) difference() {
                    translate([cage_r - cage_er, min(xb, xc)])
                        square([cage_er + 1, cage_er + 1]);
                    translate([cage_r - cage_er, xc]) circle(cage_er, $fn = 24);
                }
        }
        // round the flange's top-rear corner (the bottom one dies into
        // the shelf)
        difference() {
            translate([-1, panel_h - flange_r, mate_z1 - flange_r])
                cube([mate_wall_t + 2, flange_r + 1, flange_r + 1]);
            translate([-2, panel_h - flange_r, mate_z1 - flange_r])
                rotate([0, 90, 0])
                    cylinder(h = mate_wall_t + 4, r = flange_r, $fn = 48);
        }
    }
}

module assembly() {
    mount_right();
    // ghost ONT in its pocket: model z (33) -> mount y, model y (148) ->
    // mount z; feet at model z<0 hang into the gap above the shelf
    if (show_ont && $preview)
        %translate([bay_x0 + clr, ont_y0, panel_t + clr + ont_w])
            rotate([-90, 0, 0]) ont();
}

if (right_half) mirror([1, 0, 0]) assembly();
else assembly();
