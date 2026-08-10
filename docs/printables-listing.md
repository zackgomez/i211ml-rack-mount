# Printables upload package

Everything below is paste-ready. Files to upload are listed at the bottom.

## Title

Verizon FiOS I-211M-L ONT + Power Brick — 19" Rack Mount (1U, two-piece)

## Category / tags

Category: Gadgets → Computers (or Hobby & Makers → Organizers)
Tags: `rack-mount`, `19-inch`, `1u`, `verizon`, `fios`, `ont`, `i-211m-l`,
`homelab`, `server-rack`, `network`, `openscad`, `asa`

## Summary (120-char limit)

Two-piece 1U rack mount for the Verizon FiOS I-211M-L ONT and its power
brick — LED window, keystone, tool-free fit.

## Description

Moves the Verizon FiOS I-211M-L ONT and its "Power OK" power brick out of
the wall box and into a 19" rack: a two-piece 1U mount with a status-LED
window, keystone passthrough for the ethernet handoff, and tool-free
friction retention that hugs the devices' chamfered edges — no straps,
no screws touching the devices.

Two modules that bolt together into one 19" × 1U face:

- **Right piece — ONT cage.** Hex-vented shelf, side eaves and a front brow
  whose 45° undersides ride the ONT's chamfered edges: slide it in from the
  rear and it self-centers with a light friction grip. The ONT rides on its
  own rubber feet (solid landing pads in the vent field). Status LEDs show
  through a front window; the fiber exits through a gap in the outer wall
  with gentle bend radius; all copper dresses off the open rear.
- **Left piece — power brick cage.** The brick slides in tab-first; its own
  wall-box mounting tab locks under a hold-down bar, eaves grab the top
  chamfer, both cords exit the open rear. Keystone slot in the front face
  for the ethernet handoff (short patch cable inside, rack patching outside).
- Pieces join with two M5 screws into captive hex nuts; each ear takes
  standard M6 cage-nut hardware with widened slots for alignment play.

**1U height note:** the brick is 44 mm tall — this mount lets it dip a few
mm into the rack unit BELOW the panel, so that U must be empty (or use the
included 2U left piece, which keeps everything inside its own footprint —
it pairs with the same right piece printed unchanged; joint holes align at
either height from the source).

Printed in ASA and living in my rack (photos). OpenSCAD source, full
device measurements, and the design/build log:
https://github.com/zackgomez/i211ml-rack-mount

Designed in collaboration with Claude (Fable 5) — co-authored per the
repo's git history.

*This is a fan-made mount; not affiliated with Verizon. The ONT remains
your ISP's property — relocate gently, mind the fiber bend radius, and
keep the dust caps on anything you unplug.*

## Print settings

- Orientation: front panel flat on the bed (as exported)
- Supports: none — EXCEPT `mount-left-1u.stl`, which needs a small support
  under the below-panel overlap (the few mm that dip into the U beneath).
  The 2U left piece and the right piece print support-free
- As printed (the units in the photos): Polymaker ASA, 0.6 mm nozzle,
  0.4 mm layers, 2 walls, 15 % infill
- Bed: the right piece is 265 mm wide — printed diagonally on a 250 mm
  Voron (just fits); 300 mm beds take it straight

## Assembly / hardware

- 2× M5×16 + 2× M5 hex nuts (nuts press into the left piece's pockets)
- 4× M6 cage nuts + screws (or your rack's 10-32/12-24 hardware)
- 1× RJ45 keystone jack + short patch cable (ONT GigE → keystone)
- Load the ONT: slide in from the rear until the front brow grips
- Load the brick: slide in tab-first until the tab seats under the bar
- Friction fit tuning: `eave_squeeze` in the OpenSCAD source

## Files to upload

STLs (from `cad/stl/`):
- `mount-right-1u.stl` — ONT cage, right half
- `mount-left-1u.stl`  — brick cage + keystone, left half (dips into the U below)
- `mount-left-2u.stl`  — alternative left half, self-contained 2U

Photos (from `photos/`):
- `installed-front.jpg` — **cover image** (LEDs through the window, in-rack)
- `installed-rear.jpg`  — rear cable dressing
- `bench-assembled.jpg` — both devices loaded, on the bench

Renders (from `cad/`):
- `render-assembly-front.png` — both pieces joined, interior view
- `render-right-iso.png` — ONT cage with ghosted ONT (shows retention)
- `render-left-iso.png`  — brick cage with ghosted brick

License: **CC BY 4.0** — matches "public domain + please credit me";
attribution is the only requirement, commercial use allowed.
