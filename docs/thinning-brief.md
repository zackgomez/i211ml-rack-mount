# Thinning brief — material/print-time pass

You are the third instance on this two-piece 19" rack mount (Verizon ONT
I-211M-L + power brick). Both halves are designed, test-printed once, and
fit-verified. Your mission is plastic and print time, in three stages, in
this order:

1. **Brick cage walls** (`cad/mount-left.scad`): hollow out the wall
   centers — big cutouts through the side walls' free spans, with
   aesthetic corner rounding on the interior (cutout) edges. The panel,
   shelf, front wall, flange, ramps, and keystone boss are NOT in scope
   yet. Also queued in this file, Zack-approved: reduce the front
   tab-seat wall to posts (it must keep: the forward stop for the brick
   face, the tab slot's side keying + hold-down bar over the tab's flat
   tip, and the brow's foundation — "wall with big windows" more than
   freestanding pins).
2. **Discussion**: the primary thickness dimension. `wall = 4`,
   `panel_t = 4`, `shelf_t = 4` are shared design language across BOTH
   pieces. Thinning any of them is a cross-piece change — bring options
   and tradeoffs (stiffness, joint meat, print time deltas) to Zack
   in-terminal, and coordinate with the right-piece session before
   changing shared numbers.
3. **ONT portion** (`cad/mount.scad`): same hollowing treatment. This
   file is owned by the coordinator session ("Design 1U enclosure for
   Verizon ONT relocation") — announce intent via SendMessage before
   editing, rebase-pull first, stage explicit paths only.

## Read first

`README.md` (device facts + per-piece design snapshots), then
`cad/mount-left.scad` and `cad/mount.scad` (both heavily commented),
`cad/devices.scad` (reference solids — brick dims corrected 2026-08-09
after test fit). History/context: `docs/left-half-brief.md`.

## Frozen — do not move

- Joint interface: Ø5.3 holes at y = panel_h/2, z 20/48; left flange 10
  (4 web + 6 hex pocket, AF 8.2); right flange 8.
- Retention contact surfaces: eave 45° undersides (`eave_y`,
  `eave_squeeze`), brow, tab slot fit — fit-critical, test-verified.
- Keystone slot geometry (measured off the UCG Shelf Keystone x6,
  print-verified "perfect").
- Rack ear slots 14×7 at 8.75 from the outer edge.
- Both `panel_u` variants of mount-left must keep rendering (2U default,
  1U with the hanging floor); exports are `stl/mount-left-2u.stl`,
  `stl/mount-left-1u.stl`, `stl/mount-right-1u.stl`.

## Constraints and conventions

- Print orientation: panel flat on the bed, everything grows +z, no
  supports. Wall cutouts are per-layer cross-section changes — keep any
  reappearing material 45°-ramped (see the eave restart ramp discussion
  in git history) or make cutouts full z-columns.
- OpenSCAD gotchas already paid for: never mirror() 2D that feeds
  booleans; top-level variable order matters; F5 shows phantom slices on
  subtractions — verify with F6 or STL sections (`projection(cut=true)`
  over an `import()` of the STL works well; there is also a trimesh venv
  pattern in the session logs).
- The right piece is authored as a left and mirrored (`right_half`);
  mount-left is authored directly.
- Commit + push to master as you land things; plain imperative messages,
  Claude co-author footer (see git log). Rebase-pull before pushing;
  stage explicit paths, never `git add -A` (three sessions share this
  tree).
- Zack watches live in OpenSCAD with auto-reload and is hands-on at the
  printer. Propose before building anything you're unsure of; "propose"
  means show, don't apply.

## Open follow-up (optional, fits stage 3)

mount-left now uses the lean eave-derived ceiling
(`wall_top = eave_y + eave_depth + 3`, brow reach tied to it). The right
piece still runs `wall_top = panel_h` ("print stability, fuller capture,
flush"). The same treatment there would save ~7 of full-thickness wall
band at 1U — candidate for stage 3; propose to Zack and coordinate with
the right-piece session.
