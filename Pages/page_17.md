# Page 17 — Placement: decide where every standard cell goes

## What you are learning

After synthesis, the netlist says:

```text
cell A connects to cell B
cell B connects to cell C
```

Placement adds coordinates:

```text
cell A → location (x1, y1)
cell B → location (x2, y2)
cell C → location (x3, y3)
```

Those coordinates matter because physical distance affects routing, delay, congestion, and power.

## 1. Placement is an optimization problem

A placer tries to satisfy many competing goals:

```text
short wires
low congestion
legal density
good timing
routing access
physical legality
```

There is rarely one perfect placement.

EDA tools search for a good solution.

## 2. Why not place all connected cells directly beside each other?

Because every cell is part of many constraints at once.

A cell may connect to:

```text
several logic neighbors
clock
power
I/O pins
high-fanout nets
```

Packing one cluster tightly may make another net impossible to route cleanly.

Physical design is a global optimization problem.

## 3. Global placement

Global placement determines approximate cell locations while optimizing objectives such as wirelength and density.

At this stage, cells may not yet be perfectly legal on the placement grid.

Think:

```text
find good neighborhoods
```

rather than:

```text
snap every cell to its final exact site
```

## 4. Detailed placement

Detailed placement legalizes the design.

Cells are moved onto valid sites and overlaps are removed while trying not to destroy the quality of global placement.

Think:

```text
turn the approximate solution into a physically legal one
```

## 5. Why wirelength matters

Long wires tend to create more parasitic resistance and capacitance.

That can increase:

```text
delay
dynamic power
routing resource usage
```

Shortening important connections is therefore valuable.

But shortest-total-wirelength is not the only objective.

## 6. What is congestion?

Routing resources are finite.

Imagine a city where ten highways all need to pass through the same narrow corridor.

The physical-design equivalent is routing congestion.

Too many nets competing for too few tracks can cause:

```text
detours
longer wires
timing degradation
routing failure
DRC problems
```

## 7. Find placement stages

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'placement|globalplacement|detailedplacement|gpl|dpl'
```

The names may vary slightly by LibreLane release.

## 8. Inspect the final placement

Open OpenROAD:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Zoom into the cell rows.

Individual standard cells should appear as many small rectangles packed along legal rows.

Try selecting or highlighting instances.

Notice that the physical design contains more than the neat conceptual blocks from your RTL.

## 9. Why did extra cells appear?

Physical implementation can insert cells that were not explicitly described in your RTL.

Examples include:

```text
buffers
clock buffers
filler cells
tap cells
endcaps
diode/antenna-repair structures
```

Some optimize timing or electrical behavior.

Others satisfy physical/manufacturing requirements.

That is normal.

## 10. Placement changes timing before routing is even finished

Suppose a path is:

```text
FF1 → logic A → logic B → FF2
```

If the cells are placed close together, the wires can be shorter.

If they are spread across the block, net delay can grow.

That is why timing optimization does not stop after synthesis.

## 11. Density is local, not only global

A design may have low average utilization and still have one congested hotspot.

For example:

```text
left half: mostly empty
right corner: extremely dense
```

Average utilization alone cannot describe local routability.

This is why placement tools use density and congestion maps.

## 12. Save placement evidence

Save:

```text
screenshots/placement.png
```

If OpenROAD provides a useful congestion or density heatmap for your run, save an additional image:

```text
screenshots/placement_heatmap.png
```

Then create:

```text
reports/page17_placement_notes.md
```

Answer:

1. What is the difference between global and detailed placement?
2. Why does placement affect timing?
3. What is routing congestion?
4. Why can physical design insert buffers that are absent from your RTL?
5. Why can low average utilization still contain a local hotspot?

## Checkpoint

- [ ] you understand global vs detailed placement
- [ ] you understand why placement affects wirelength and delay
- [ ] you understand congestion conceptually
- [ ] you found the placement stages
- [ ] you inspected standard-cell locations
- [ ] you know why extra cells may appear after physical optimization
- [ ] you saved placement evidence

## References

- OpenROAD global placement: https://openroad.readthedocs.io/
- OpenROAD detailed placement: https://openroad.readthedocs.io/
