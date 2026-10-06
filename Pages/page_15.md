# Page 15 — Floorplanning: give the circuit a physical home

## What you are learning

Synthesis tells you **what cells are connected**.

It does not tell you where those cells physically live.

Floorplanning creates the physical canvas for the design.

This is where coordinates, boundaries, rows, and pins enter the story.

## 1. Die and core

Your configuration used:

```json
"DIE_AREA":  [0, 0, 150, 150],
"CORE_AREA": [10, 10, 140, 140]
```

Conceptually:

```text
+---------------------------------------+
|                  DIE                  |
|                                       |
|    +-----------------------------+    |
|    |            CORE             |    |
|    |                             |    |
|    |  standard-cell rows live    |    |
|    |  inside this region         |    |
|    |                             |    |
|    +-----------------------------+    |
|                                       |
+---------------------------------------+
```

The **die** is the outer physical boundary of this hardened block.

The **core** is the region where standard-cell placement occurs.

## 2. Why not place cells anywhere?

Standard cells are designed to sit on legal placement rows and sites.

Think of the core like graph paper with a manufacturing-defined grid.

Cells cannot simply be dropped at arbitrary continuous coordinates.

They must align to legal placement locations.

## 3. What is a row?

A standard-cell row is a horizontal strip containing legal placement sites.

Conceptually:

```text
row 5: |__|__|__|__|__|__|__|__|__|
row 4: |__|__|__|__|__|__|__|__|__|
row 3: |__|__|__|__|__|__|__|__|__|
row 2: |__|__|__|__|__|__|__|__|__|
row 1: |__|__|__|__|__|__|__|__|__|
```

Different standard cells occupy one or more site widths.

## 4. Why rows often flip orientation

Adjacent rows commonly alternate orientation so power rails line up correctly.

You may see cells mirrored vertically in alternating rows.

That is not a bug.

It is part of how standard-cell architectures are constructed.

## 5. What are tap and endcap cells?

Not every cell computes logic.

Physical design uses special cells too.

### Tap cells

Tap cells provide well/substrate connections needed to keep transistor bodies properly tied to power rails.

### Endcap cells

Endcap cells terminate standard-cell rows in a legal way and help satisfy edge-related physical rules.

These are examples of **physical-only cells**.

They exist because silicon is physical, not because your Boolean equations requested them.

## 6. Find the floorplan stage

From the ASIC directory:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'floorplan|tap|endcap|io'
```

You may see several stages because floorplanning is more than one operation.

## 7. Inspect the design in OpenROAD

Open the final design:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Even though this opens the final state, it is useful for learning the floorplan geometry.

In the GUI, locate:

```text
die boundary
core boundary
standard-cell rows
input/output pins
placed cells
```

Use zoom aggressively.

A tiny design inside a 150 µm square may initially look sparse.

## 8. Find an intermediate OpenROAD database

The run is a history of the design.

Find OpenROAD database files:

```bash
find "$RUN" -type f -name '*.odb' | sort
```

Look for an `.odb` produced around the floorplanning stage.

You can often open a specific database directly with:

```bash
openroad -gui <PATH_TO_ODB>
```

If a particular database also requires libraries or setup scripts, use LibreLane's generated commands or open the closest state using the documented flow mechanisms.

The important habit is to learn that **intermediate states are inspectable**.

## 9. What does utilization mean geometrically?

Imagine the available core area is:

```text
A_core
```

and the total placeable standard-cell area is:

```text
A_cells
```

Then a simplified utilization intuition is:

```text
utilization ≈ A_cells / A_core
```

A design at very high utilization leaves little whitespace.

Whitespace is not always wasted.

It gives the implementation room for:

```text
buffer insertion
clock cells
routing access
congestion relief
timing repair
```

## 10. Why our floorplan is intentionally oversized

This ALU is tiny.

A highly optimized commercial floorplan would probably be much smaller than the teaching floorplan.

We intentionally gave it room so you can clearly see:

```text
rows
power straps
cell clusters
routing
clock structures
```

Later, Page 24 turns area into an engineering experiment.

## 11. Input/output pins are physical objects too

At RTL, a port is just a named interface:

```verilog
input wire [7:0] a;
```

At physical design, those signals need physical pin shapes on metal layers.

Pin placement affects routing because every signal has to reach its pin.

For a macro embedded inside a larger chip, these pins become the physical interface to the surrounding design.

## 12. Save floorplan evidence

Save a screenshot showing:

```text
die boundary
core boundary
rows
some visible cells/pins
```

as:

```text
screenshots/floorplan.png
```

Then create:

```text
reports/page15_floorplan_notes.md
```

and answer:

1. What is the die?
2. What is the core?
3. Why do rows exist?
4. Why does a low-utilization design contain whitespace?
5. Name two types of physical-only cells.

## Checkpoint

- [ ] you can distinguish die area from core area
- [ ] you understand placement rows and sites
- [ ] you know what tap and endcap cells are for
- [ ] you understand utilization conceptually
- [ ] you found floorplan-related steps in the run
- [ ] you inspected the physical boundaries in OpenROAD
- [ ] you saved a floorplan screenshot and notes

## References

- LibreLane step variables: https://librelane.readthedocs.io/en/stable/reference/step_config_vars.html
- OpenROAD floorplanning documentation: https://openroad.readthedocs.io/
