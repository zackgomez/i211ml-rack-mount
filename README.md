# Verizon ONT I-211M-L — 19" Rack Mount

**Published**: https://www.printables.com/model/1806857-verizon-fios-i-211m-l-ont-power-brick-19-rack-moun
(CC BY 4.0). Installed and in service 2026-08-10 — ONT in the rack, on the UPS.

Design and print a 1U (or 2U) rack mount for the Verizon FiOS ONT (Alcatel-Lucent
I-211M-L) plus its inline power brick, so the ONT moves from the basement wall box
into the server rack. Fiber arrives as a stiff black drop, coiled/anchored in the
wall box's back pocket, terminating in a green SC/APC connector that plugs into the
ONT — so the move is unplug → re-route a couple feet → replug (or a longer G.657
SC/APC simplex patch cable if slack runs short).

## Device facts

Measured 2026-08-08 with soft tape (±2 mm) except items marked *calipers*.
The Alcatel manual claims 249 × 159 × 38 — trust the tape+calipers numbers below.

**ONT — Alcatel-Lucent I-211M-L** (P/N 3FE52343AKAA, our unit SN ALCLF4493816)
- 227 (x, tape) × 148 (y, *calipers*) × 33 mm (z, *calipers*)
- 45° chamfer on ALL edges, face width 10.5 mm (*calipers*) → ~7.4 mm legs;
  the LED bevel is one of them
- 4 rubber feet on the bottom, Ø11 × 3 tall (*calipers*): gaps measured from
  the chamfer edge, applying on both axes from each corner — LED-side pair
  1.5, port-side pair 20 (centers 14.4 / 32.9 from their corners). Also
  unmeasured mounting bosses, shorter than the feet — the cage floats the
  ONT on its feet so bosses hover
- Rear-face ports, z-centered on the connector face (*calipers*): coax F
  center 36 from the −x face; green SC/APC fiber plug outer edge 20 from the
  +x face (so the fiber lives near the outer wall's rear exit gap)
- Power input: 12 VDC / 2.5 A, keyed circular connector ("TELECOM EQUIPMENT DO NOT
  UNPLUG" collar), max draw 10.5 W — heat is a non-issue, token venting suffices

**Power brick — Verizon "Power OK" inline PSU**
- Body 124 (x) × 85 (y, max) × 44 mm (z) — *calipers*. The y sides are
  drafted, widest at the mid-height shell seam: 83.4 at the bottom face,
  85.0 at the seam, back in toward the chamfer edge (assumed 83.4 via a
  symmetric draft — TODO calipers)
- 6 mm chamfer around the top-face perimeter; vertical edges lightly rounded
  (~r2.5, eyeball); bottom face edges sharp
- Mounting tabs (wall-box rail hooks), bottom-flush, outer vertical corners
  moderately rounded (~r2.5). Wedge profile: max height at the root, sloping
  down to a flat run at min height ending at the tip:
  - body −x end (*calipers*): 18.2 x × 20.3 y, NOT centered — 24.4 off the
    bottom face's −y edge (24.4 + 20.3 + 38.7 closes the 83.4 bottom width
    exactly); wedge 3.8 → 8.2 mm, 4 mm flat
  - far (+x) END of the cord hump: 11 x × 12.5 y, centered on the shroud;
    wedge 3.3 → 7.0 mm, 3 mm flat
- Cord shroud on the +x end (strain relief locking the output cord): 38 beyond
  the body in x, 53 wide in y, bottom-flush, 6 mm margin (*calipers*) off the
  widest −y edge. Side profile: flat top 14 below the brick top (tape), knee
  curving down to a 22.3 mm tip face (*calipers*; traced 2026-08-08, photo in
  Scan inbox). TWO cords (both Ø6, *calipers*) exit the +x end:
  - body cord: leaves the body face toward +y (exact y pending calipers)
    through a strain relief stacked in +x — rect slab 2.5 × 15 × 15, then
    cylinder Ø15 × 12.5 — whose top sits at half the brick height (22), cord
    centerline z ≈ 14.5
  - output cord: off the shroud tip, −y side of the +x tab, cord top 4.8
    below the tip face's max z (centerline z ≈ 14.5 — matches the body cord)
  A half-spool greeble — an unpopulated cord exit ("cord hat") — sits +y of
  the tab on the tip face, its y/z mirroring the output cord across the tab
  (all *calipers*): shaft Ø8 × 6.7, lip Ø10 × 2, bore Ø6, cut at the axis
  z-plane — flat below, half-round above. Full x chain
  incl. tabs ≈ 184 mm; the strain relief reaches ≈ 15 further — keep the
  mount's +x face fully open.
- Port edge (one side): coax F, ground screw, 2× RJ11 POTS, 1× RJ45 GigE, power.
  POTS/MoCA unused — only GigE + power + fiber need routing
- Fiber: SC/APC under a hinged cover on the end opposite the coax
- LEDs (PWR BAT FAIL VID DATA NTWK MGMT POTS MoCA) on the beveled long edge —
  keep visible from the rack front
- Back: 3 keyhole slots (two upper, one lower-center) + 4 rubber feet

**Power brick** — Verizon inline PSU ("Power OK" LED on top), large; has a molded
mounting clip/bracket. Measure the actual unit — dims TBD.

- 1U usable height ≈ 44 mm; ONT lying flat is 38 mm → fits 1U, tight. 2U buys
  room for the brick standing on edge and lazier cable routing.
- 19" opening ≈ 450 mm; ONT flat takes 249 mm → ~200 mm left for the brick bay.

## Design direction

Two-piece screwed-together modular mount, same pattern as the UCG-Fiber mount that
already works well in this rack
(`../UCG-Fiber+PSU+19-inch+Modular+Rack+Mount/` — cage + PSU holder + keystone
passthrough with patch cables). The Print3DSteve Etsy design (central cage + two
ear wings, keystone cutout in one wing) confirms the same architecture at 1U.

Orientation (decided): ONT connector edge (coax, POTS, GigE, power, fiber cover)
faces the REAR of the rack — fiber and power dress off the back, out of sight.
LED bevel faces front. Eth handoff = short patch cable from the rear GigE port,
routed inside the mount, to a keystone jack in the front plate.

Ideas to carry over / decide:
- ONT hangs on printed keyhole posts (3 slots on its back) instead of a full cage —
  smallest modeling job, LEDs stay visible
- Keystone cutout in the front plate (one wing), patch cable inside the mount
- Brick pocket + zip-tie anchors; the brick's own clip may snap onto a printed rail
- Fiber: generous bend radius everywhere (≥30 mm) coming off the rear

## cad/

OpenSCAD, parametric. Shared design language across both mounts:
`wall` / `panel_t` / `shelf_t` = 4 — deliberately kept at 4 (each knob's
4→3 saves only ~8–14 cm³ and spends stiffness exactly at the load
paths: eave retention flex, rack-face flatness, zip-anchor webs).
`devices.scad` = reference solids of ONT + brick (fillet /
chamfer params still TODO-measure). `gauges.scad` = printable go/no-go gauges;
pre-rendered STLs in `cad/stl/`:

- `gauge-ont-cap.stl` — C-channel, slips over the ONT end, checks 148 × 33
- `gauge-ont-length.stl` — U-bar over the 227 length
- `gauge-brick-cap.stl` — C-channel over the brick end, checks 88 × 44
- `gauge-brick-length.stl` — U-bar over the 128 length

All gauges carry 0.5 mm/side clearance (`clear` in gauges.scad). Print flat face
down, no supports. Re-export:
`openscad -D 'part="ont_cap"' -o stl/gauge-ont-cap.stl gauges.scad`

Mount STL + preview regeneration (from `cad/`):

```
openscad --export-format=asciistl -o stl/mount-left-1u.stl mount-left.scad
openscad --export-format=asciistl -D 'panel_u=2' -o stl/mount-left-2u.stl mount-left.scad
openscad --export-format=asciistl -o stl/mount-right-1u.stl mount.scad
openscad -o mount-left-preview.png --imgsize=1600,1100 --viewall --autocenter \
    --camera=0,0,0,65,0,150,0 mount-left.scad   # -preview-rear.png: rz 150->30;
                                                # -2u-preview: add -D 'panel_u=2';
                                                # mount-right-render.png: same
                                                # camera on mount.scad
```

**ASA shrink protocol**: print gauges at 100%, in ASA, same profile as the final
mount. Fit = measurement + shrink verified together; snug/no-go = measure the gap
and adjust `clear` / final pocket clearances. Target for device bays in the real
mount: ~1.5–2 mm/side (tape error + shrink + easy insertion).

Rack-width shrink note: 0.5 % over the 465.1 mm ear-hole span is ~2.3 mm — the
center-cage + two-wings + slotted joints architecture absorbs this; never print
the full 19" width as one piece.

## mount.scad — right half (ONT cage)

UCG-Fiber-style module, panel printed flat on the bed, no supports; 1U
primary (`panel_u`, 2 still renders). Test print v1 (2026-08-08, 1U,
fast ASA): bay width spot-on (227 device / 230 bay confirmed), eave
friction at +0.2 squeeze overly tight → now −0.1 (clearance);
`eave_squeeze` is the tuning knob. Geometry is authored as a left and
mirrored via `right_half = true` so the cage sits rack-RIGHT. The ONT
rides on its feet (solid pads in the hex field, bosses hover); retention
= side eaves + front brow hugging the chamfered edges, brick-cage style:
both side walls run the full bay depth (the inner one continues 4 thick
past the flange) with full-length eaves and the low eave-derived ceiling
(`wall_top = eave_y + eave_depth + 3`; the flange keeps full panel
height for the joint, the brow is panel-face material). The rear is
fully open — fiber, coax, and cords all dress off the back. Each wall
carries the same rounded elongated-hex windows as the brick cage (outer
wall two, inner wall one behind the solid joint span, z-aligned so the
cutouts read through the cage). Joint hardware: M5×16 button heads,
inset Ø10.8 × 3 into the flange's bay-side face (ISO 7380 head 9.5 ×
2.75 vs 1.5 bay clearance), nuts in the left piece's hex pockets.
Roundings match mount-left: panel outer corners r4, cage top-rear r8,
wall edges r2, flange top-rear r6, shelf rear r6.

## mount-left.scad — left half (brick enclosure)

217.6 wide, authored directly as a left; 1U primary (`panel_u`, 2 still
renders — see the variant paragraph below for how the 44-tall brick fits
a 1U panel). The brick lies flat on a hex-vented shelf, long axis along
rack DEPTH:
wall-box tab end forward, cord/shroud end out the fully open rear (both
cords + strain relief dress off the back). The bay sits OUTBOARD, just
inboard of the rack ear, so the brick's weight hangs next to the mounting
hardware — the cage stops 30 from the panel edge (the UCG mount runs 23
and clears this rack's posts; `ear_clear`). The floor plane spans only
the cage. The brick slides in from the rear: side eaves grab the 6 mm
top-perimeter chamfer (same `eave_squeeze` knob, −0.1), a front brow
grabs the front-top chamfer, and the −x tab passes through a slot in the
front wall — its tip rides to 2 from the panel FRONT face (the slot
pockets into the panel's back, keeping the front wall thin) — with a
hold-down bar riding 0.5 over its flat tip. Two
zip-tie slots behind the body anchor the AC cord so tugs land on the
mount, not the brick. Joint flange is 10 thick: M5 holes match mount.scad
(y = panel_h/2, z 20/48); hex nut pockets 8.2 across flats (UCG pockets
measure ~8.1 and press-fit on this printer), 6 deep over a 4 web — an
M5×16 tip lands flush. Two UCG-style gusset ramps brace the flange, one
near each panel edge and inset 6 in y — full 64 depth at the flange, free
edge a concave quarter-circle fillet running out to the panel at x=70.
Rounded corners: panel outer corners r4 (sized to keep the ear-slot web),
cage top-rear r8 across walls + eaves, cage outer edges r2 (wall
top-outer along z, rear verticals), flange rear corners r6 (tangent to
the ramps), shelf rear r6, keystone boss r3. Keystone slot at x = 52
(joint side), y = panel_h/2, face front, latch DOWN, jack in from the
rear: geometry measured off the UCG "Shelf Keystone x6" left module —
no tuned lip; the teeth wedge against tapered clamp faces (hook side
6.35→12.15 over 4.9 deep, latch side 45° 10.15→12.15), 24.3 × 15.0
cavity, and a rear plate whose 19.8 window guides the jack — cut into a
9.5-thick boss on the panel rear. Rack ear ovals 14 × 7 (UCG-style
horizontal play). Low eave-derived ceiling: walls and eaves stop 3 past
the eave slope (the brick's chamfered top stands ~2 proud; the brow's
45° underside runs exactly to the wall top). Material pass: each side
wall carries two elongated-hex windows (45° pointed ends print
bridge-free, corners r4, 8 rib between, rails tied to the
shelf/eave/brick-face/rear-round lines); the front wall is a windowed
frame — three through-pockets behind the panel, two flanking the tab
housing and one over it, keeping the full-perimeter brick stop, the
slot's keying walls + hold-down bar, and the brow foundation.

At 1U — the primary — the 44-tall brick beats the 43.65 panel only by
poaching inter-U slack: the brick tops out exactly at the panel's top
edge (~2.55 under the UCG mount above, whose rear structure starts 1.75
above its own panel edge, measured from its STL), and the floor + walls
hang 4.35 into the U below — empty in this rack — tucked behind the
panel face so nothing shows under the panel from the front. At 1U the
keystone shifts to x = 60 and the gusset runout shortens to x = 44 to
coexist; eaves, brow, tab slot, and joint holes (panel_h/2 pairs with
the right piece at 1U) all re-derive.

## Next steps

1. Caliper the foot center inset from the LED/port edges (est. 8 in
   devices.scad) + body cord y (`cordA_y`)
2. Reprint both pieces at 1U with the material pass + joint insets:
   right verifies eave feel + foot pads + button-head seating; left
   verifies bay/tab/eave fit after the brick-model correction (its test
   v1 2026-08-09: keystone perfect, rack + joint hardware fit well)
3. The physical move (unplug SC/APC, unmount wall box, re-route, replug)

## references/

- `ebay-ont-i211ml-1.jpg` — ¾ view, port edge + vented top
- `ebay-ont-i211ml-2.jpg` — spec label close-up (12VDC 2.5A, P/N, FCC)
- `ebay-ont-i211ml-3.jpg` — port edge straight on (coax, POTS×2, GigE, power, fiber cover)
- `ebay-ont-i211ml-4.jpg` — top face angled, LED labels
- `ebay-ont-i211ml-5.jpg` — front face portrait (Frontier branding, LED edge)
- `ebay-ont-i211ml-6.jpg` — back: 3 keyhole slots, feet, label
- `ebay-power-brick.jpg` — Verizon "Power OK" inline PSU strapped to a G-211M-C (brick style reference)
- `etsy-g211mc-*.png` — Print3DSteve 1U mount for the *G-211M-C* (different ONT, same
  architecture: center cage, two ear wings, keystone cutout)

## Links

- eBay ONT listing (photo source): https://www.ebay.com/itm/303900171619
- eBay brick listing (photo source): https://www.ebay.com/itm/358831177634
- Etsy G-211M-C 1U mount ($83, wrong model): https://www.etsy.com/listing/4328277623
- Print3DSteve also made an I-211M-L variant (Etsy, search their shop):
  https://br.pinterest.com/pin/155303888119943946/
- Only free I-211M-L print (Leviton SMC bracket, not rack):
  https://www.printables.com/model/396377 / https://www.thingiverse.com/thing:5145029
- Physical specs source (Alcatel-Lucent 7302 manual p.1042–1043):
  https://www.manualslib.com/manual/1575417/Alcatel-Lucent-7302.html?page=1042
