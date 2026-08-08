# Verizon ONT I-211M-L — 19" Rack Mount

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
- Power input: 12 VDC / 2.5 A, keyed circular connector ("TELECOM EQUIPMENT DO NOT
  UNPLUG" collar), max draw 10.5 W — heat is a non-issue, token venting suffices

**Power brick — Verizon "Power OK" inline PSU**
- Body 124 (x) × 88 (y) × 44 mm (z) — all *calipers*, max envelope
- 6 mm chamfer around the top-face perimeter; vertical edges lightly rounded
  (~r2.5, eyeball); bottom face edges sharp
- Sides bow slightly ("diamond"): widest point ~1.2 mm proud of the chamfer
  edge at mid-height (rough) — 124 × 88 already capture the max
- Mounting tabs (wall-box rail hooks), 11 x × 12.5 y each (*calipers*),
  bottom-flush, outer vertical corners moderately rounded (~r2.5). Wedge
  profile: max height at the root, sloping down to a flat run at min height
  ending at the tip:
  - on the body's −x end: 3.8 → 8.2 mm, 4 mm flat
  - on the far (+x) END of the cord hump: 3.3 → 7.0 mm, 3 mm flat
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

OpenSCAD, parametric. `devices.scad` = reference solids of ONT + brick (fillet /
chamfer params still TODO-measure). `gauges.scad` = printable go/no-go gauges;
pre-rendered STLs in `cad/stl/`:

- `gauge-ont-cap.stl` — C-channel, slips over the ONT end, checks 148 × 33
- `gauge-ont-length.stl` — U-bar over the 227 length
- `gauge-brick-cap.stl` — C-channel over the brick end, checks 88 × 44
- `gauge-brick-length.stl` — U-bar over the 128 length

All gauges carry 0.5 mm/side clearance (`clear` in gauges.scad). Print flat face
down, no supports. Re-export:
`openscad -D 'part="ont_cap"' -o stl/gauge-ont-cap.stl gauges.scad`

**ASA shrink protocol**: print gauges at 100%, in ASA, same profile as the final
mount. Fit = measurement + shrink verified together; snug/no-go = measure the gap
and adjust `clear` / final pocket clearances. Target for device bays in the real
mount: ~1.5–2 mm/side (tape error + shrink + easy insertion).

Rack-width shrink note: 0.5 % over the 465.1 mm ear-hole span is ~2.3 mm — the
center-cage + two-wings + slotted joints architecture absorbs this; never print
the full 19" width as one piece.

## Next steps

Build order: RIGHT half first (ONT cage: LED bevel visible at front, open rear
for cables, rack-ear + half-to-half joints sorted in this piece), then the LEFT
half (brick). 1U vs 2U pending — see brick/tab discussion.

1. Print the four gauges in ASA, check fit, record deltas in this README
2. Model the right half (mount.scad)
3. Print, iterate, model the left half
4. Assemble, then the physical move (unplug SC/APC, unmount wall box,
   re-route, replug)

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
