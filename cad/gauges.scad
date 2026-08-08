// Printable fit gauges for the I-211M-L rack mount project.
// Slip these over the real devices to validate measurements + ASA shrink
// before cutting the actual mount. Print at 100% — if a gauge is tight,
// the difference IS the number to bake into the final clearances.
//
// Render one part at a time:
//   openscad -D 'part="ont_cap"' -o stl/gauge-ont-cap.stl gauges.scad

include <devices.scad>
show_devices = false;   // suppress the device preview from devices.scad

part = "all";     // ont_cap | ont_length | brick_cap | brick_length | all

clear = 0.5;      // per-side clearance built into every gauge
wall = 3;
lip = 15;         // how far a cap slips onto the device

// C-channel cap that slips over the end of a w x h cross-section.
// Open on one long face (so it clears feet/labels) and at the mouth.
module end_cap(w, h) {
    iw = w + 2 * clear;
    ih = h + 2 * clear;
    difference() {
        cube([lip, iw + 2 * wall, ih + wall]);          // no floor wall: open face
        translate([-1, wall, -1]) cube([lip + 2, iw, ih + 1 + clear]);
    }
}

// U-bar: checks an outside length between two end stops.
module length_gauge(l, stop = 12) {
    il = l + 2 * clear;
    w = 15;
    difference() {
        cube([il + 2 * wall, w, stop + wall]);
        translate([wall, -1, -1]) cube([il, w + 2, stop + 1]);
    }
}

if (part == "ont_cap" || part == "all")
    end_cap(ont_w, ont_h);                              // 148 x 33 cross-section

if (part == "ont_length" || part == "all")
    translate([0, 60, 0]) length_gauge(ont_l);          // 227 outside length

if (part == "brick_cap" || part == "all")
    translate([0, 110, 0]) end_cap(brick_w, brick_h);   // 88 x 44 cross-section

if (part == "brick_length" || part == "all")
    translate([0, 230, 0]) length_gauge(brick_l);       // 128 outside length
