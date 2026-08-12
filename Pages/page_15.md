# Floorplanning: die, core, rows, pins, taps, and endcaps

Floorplanning creates the physical canvas on which the design will be built. This is where abstract logic first receives a real physical boundary.

## Overview

Two rectangles matter immediately:

```text
+----------------------------------+
|              DIE                 |
|                                  |
|   +--------------------------+   |
|   |          CORE            |   |
|   |                          |   |
|   |  standard-cell rows      |   |
|   |                          |   |
|   +--------------------------+   |
|                                  |
+----------------------------------+
```

### Die area

The **die area** is the outer boundary of the block being hardened.

In this project:

```json
"DIE_AREA": [0, 0, 150, 150]
```

means approximately:

```text
150 µm × 150 µm
```

for the block boundary.

### Core area

The **core area** is the inner region where standard-cell rows are created.

```json
"CORE_AREA": [10, 10, 140, 140]
```

creates margins around the core.

### Why not fill the entire die with cells?

Physical design needs room for:

- routing
- power distribution
- clock buffers
- timing-fix buffers
- legal placement movement
- congestion relief
- physical-only cells

A design with no whitespace can become impossible to route or impossible to fix.

### Placement sites and rows

Standard cells are not placed at arbitrary coordinates.

They sit on legal **sites** arranged into rows.

Cells are designed to align so neighboring cells can share power rails and follow the library's placement geometry.

### Tap cells

CMOS wells/substrate regions must be tied to the correct supply potentials.

Tap cells provide legal well/substrate connections at required intervals.

They are physical infrastructure, not part of your Boolean function.

### Endcap cells

Endcaps protect/legalize the ends of standard-cell rows according to library/process requirements.

Again, they are physical-only cells.

## Prerequisites

- [synthesis understood](page_14.md)

## Steps

### 1. Locate the floorplan state

```bash
RUN=$(ls -dt runs/* | head -1)

FP_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*openroad-floorplan*' | head -1)

echo "$FP_DIR"
```

### 2. Open the floorplan in OpenROAD

```bash
librelane \
  --with-initial-state "$FP_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 3. Identify the die boundary

In the GUI, find the outer block rectangle.

This is not a decorative border.

It is the physical boundary used by the implementation.

### 4. Identify the core

Look inside the die for the region containing placement rows.

Ask:

```text
How much margin exists between the core and die?
Why might routing or PDN need that margin?
```

### 5. Inspect rows

Zoom in until you can see the repeated standard-cell row structure.

Rows generally alternate orientation so adjacent rows can share power rails correctly.

### 6. Find the tap/endcap stage

```bash
TAP_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*tapendcapinsertion*' | head -1)

echo "$TAP_DIR"
```

Open it:

```bash
librelane \
  --with-initial-state "$TAP_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

Now compare this with the raw floorplan.

Look for physical-only cells added to the rows.

### 7. Understand utilization

Core utilization is conceptually:

```text
standard-cell area
------------------ × 100%
usable core area
```

Higher utilization means:

```text
more cells packed into less area
```

That can improve compactness, but can also cause:

```text
routing congestion
poor timing
insufficient room for buffers
harder legalization
```

Lower utilization usually means more whitespace and a larger core.

### 8. Understand aspect ratio

An aspect ratio near:

```text
1.0
```

produces a roughly square core.

A rectangular core may be useful for:

- interface geometry
- macro placement
- top-level integration
- routing structure
- package constraints

There is no universal ideal shape.

### 9. Measure dimensions

Record:

```text
die width
die height
core width
core height
```

Calculate:

```text
die area  = width × height
core area = width × height
```

Use µm and µm².

### 10. Save screenshots

Save:

```text
screenshots/floorplan.png
screenshots/tap_endcap.png
```

## Results

Record:

| floorplan metric | value |
|------------------|------:|
| Die width | |
| Die height | |
| Die area | |
| Core width | |
| Core height | |
| Core area | |
| Aspect ratio | |
| Target utilization/density | |

## Checklist

- [ ] Can identify die boundary
- [ ] Can identify core boundary
- [ ] Can identify placement rows
- [ ] Understand placement sites
- [ ] Understand tap cells
- [ ] Understand endcap cells
- [ ] Understand utilization
- [ ] Recorded dimensions
- [ ] Continued to page 16

---

*Questions? Ask in the network Discord.*
