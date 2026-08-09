# Left-half brief — power brick enclosure

You are building the LEFT half of this two-piece 19" rack mount: the pocket
for the Verizon "Power OK" inline PSU. The right half (ONT cage,
`cad/mount.scad`) is designed, test-printed once, and iterating with Zack.
Deliverable: a first pass + design notes — Zack is hands-on at the printer
and will iterate with you. Propose before building anything you're unsure of.

Read first: `README.md`, `cad/devices.scad` (brick() is fully measured),
`cad/mount.scad` (conventions, rack numbers, and the tricks to reuse).

## Fixed decisions

- Two pieces, ASYMMETRIC split: right piece is 265 wide, this piece gets
  **217.6** (482.6 total). Joint carries M5 screws in x through the right
  piece's 6-thick flange (Ø5.3 holes at z 20 and 48, y = panel_h/2); THIS
  piece carries the nut side — hex pockets, like the UCG-Fiber left module
  Zack owns (`~/sync/3d printing/projects/server rack/UCG-Fiber+PSU+19-inch+
  Modular+Rack+Mount/Left side - Hex Nuts/`). Zack wants "more meat" at the
  joint than the right piece currently has — thickening both sides is on the
  table, coordinate via Zack.
- Rack ear on the outer (rack-left) edge: oval slots 10×7 for M6 cage-nut
  screws, centers 8.75 from the outer panel edge, y at 6.35 and
  panel_h − 6.35.
- **2U only** (`panel_u = 2` equivalent): the brick is 44 tall and cannot
  live in 1U. The right half flips to 2U later.
- Print orientation: front panel flat on the bed, everything grows in +z,
  no supports. Retention features work as wall cross-sections (see the
  eave/brow trick in mount.scad).
- Brick orientation: cords/shroud end (+x in devices.scad coords) faces rack
  REAR. Keep that whole face open — two Ø6 cords exit there, plus the strain
  relief reaching ~15 beyond the body face at mid-height. Total x-chain with
  both tabs ≈ 184, lying along the rack WIDTH: fits inside 217.6 minus walls,
  but it's snug — budget carefully.

## Retention ideas (propose, don't gold-plate)

- The brick's top perimeter has a 6 mm chamfer → the mount.scad eave trick
  (45°-parallel underside, `eave_squeeze`) works here too. Note: v1 print
  showed +0.2 squeeze is overly tight in ASA; right half now runs −0.1.
- The −x tab (wedge 3.8→8.2 thick, flat at tip, bottom-flush) faces rack
  FRONT — a printed pocket/rail seat is a natural positive lock.
- The +x tab hangs off the shroud tip at the rear; a narrow centered catch
  clears both cords (they exit ±y of it). Optional.
- Sides bulge ~1.2 mm ("diamond") at mid-height; 124 × 88 are max-envelope
  calipers. Baseline clearance `clr = 1.5` per side like the right half.
- Zack liked capturing the device UCG-style (cage, not straps).

## Open questions for Zack

- Keystone: the original plan puts an ethernet keystone in a front plate
  (patch cable from the ONT's rear GigE port). This panel has the free area —
  propose a keystone cutout location.
- Joint hardware final choice (hex pockets assumed), flange meat.
- Whether the brick pocket needs venting (10.5 W max — probably token).

## OpenSCAD gotchas already paid for

- Never `mirror()` a 2D profile that feeds booleans — CGAL "mesh not closed".
  Build flipped profiles directly (see `_tab_plan(tip_right)`).
- Top-level variable order matters: define before use.
- Preview (F5) shows phantom slices on subtractions — verify with F6 or a
  `projection(cut=true)` bbox check before believing a "bug".
- Ghost-device pattern: `%` + `show_*` flag + `$preview` (see assembly() in
  mount.scad); ghosts stay out of renders/STLs.
- Right half is authored as a left and mirrored at top level
  (`right_half = true`) — author THIS piece directly as a left (no mirror).

## Workflow

- Files: `cad/mount-left.scad`. If you extract shared rack numbers into a
  common include, keep `mount.scad` rendering identically (verify before
  commit).
- Render preview PNGs into `cad/`, export `cad/stl/mount-left-2u.stl`.
- Commit + push to master as you land things; plain imperative messages,
  end with the Claude co-author footer (see git log).
- OpenSCAD is installed; Zack views live with auto-reload. `present
  <file>` opens files on his desktop.
