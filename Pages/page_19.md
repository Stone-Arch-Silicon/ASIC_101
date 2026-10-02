# Page 19 — Routing: turn logical nets into legal metal and vias

## What you are learning

Placement gives cells coordinates.

But the pins are not electrically connected until metal is routed between them.

Routing transforms:

```text
logical connectivity
```

into:

```text
physical conductive geometry
```

## 1. A net becomes geometry

At RTL:

```verilog
wire carry;
```

At the logical netlist level:

```text
output pin of cell A
connects to
input pin of cell B
```

After detailed routing, that connection becomes a physical path containing:

```text
metal segments
tracks
vias
layer changes
```

## 2. Routing layers

A modern process contains multiple metal layers.

The layers are stacked vertically above the transistors.

Conceptually:

```text
upper metal
-----------
metal
-----------
metal
-----------
lower metal
-----------
transistors
```

Different layers can have different:

```text
preferred directions
width rules
spacing rules
resistance
capacitance
allowed uses
```

## 3. Preferred directions

Routing systems often encourage alternating preferred directions between adjacent layers.

For example, one layer may favor horizontal routes while the next favors vertical routes.

Conceptually:

```text
M2: horizontal
M3: vertical
M4: horizontal
M5: vertical
```

Do not treat that exact sequence as universal.

The PDK defines the real rules.

The important idea is that layer structure helps organize a massive routing problem.

## 4. Global routing

Global routing decides approximate paths and resource usage.

Think:

```text
this net should travel through these routing regions
```

It is concerned with capacity and congestion before assigning every exact shape.

## 5. Detailed routing

Detailed routing assigns legal physical tracks, wires, and vias.

Now the tool must obey manufacturing constraints such as:

```text
minimum width
minimum spacing
via enclosure
routing-grid legality
obstructions
minimum area
```

This is where an approximate routing plan becomes actual mask geometry.

## 6. Find routing stages

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'route|routing|grt|drt|antenna'
```

You should see global- and detailed-routing-related work as well as antenna-related checks or repair.

## 7. Inspect routing in OpenROAD

Open:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Use layer visibility controls.

Try this sequence:

```text
show all routing layers
hide upper layers
show only one or two layers
show vias
highlight one signal net
```

The purpose is to train your eye to separate layers instead of seeing one giant colored picture.

## 8. Inspect routing in KLayout

Open:

```bash
librelane --last-run --flow OpenInKLayout config.json
```

KLayout shows the final geometric representation extremely well.

Toggle layers one at a time.

Notice that one electrical connection may move through several layers using vias.

## 9. What happens in congestion?

If too many nets compete for a region, detailed routing may need to:

```text
detour
change layers
add vias
lengthen wires
```

Those detours can worsen timing and power.

Severe congestion can prevent clean routing altogether.

That is why placement quality and floorplan density matter.

## 10. What is an antenna violation?

During fabrication, long pieces of partially constructed interconnect can collect electrical charge before all connections are complete.

That charge can potentially damage thin transistor gate oxides.

This manufacturing issue is known as the **antenna effect**.

Antenna checking asks whether routing geometry violates process antenna rules.

Repair may involve techniques such as:

```text
routing changes
layer hopping
antenna diodes
```

depending on the flow and process.

This is a great example of a problem that is almost invisible at the RTL level.

## 11. Routing creates the parasitics that timing must analyze

Before routing, a net is largely an abstract connection.

After routing, it has real geometry.

That geometry creates:

```text
resistance
capacitance
coupling effects
```

The next page extracts those effects and feeds them into timing analysis.

## 12. Save routing evidence

Save at least two screenshots:

```text
screenshots/routing_all_layers.png
screenshots/routing_few_layers.png
```

Create:

```text
reports/page19_routing_notes.md
```

Answer:

1. What is the difference between global and detailed routing?
2. What is a via?
3. Why do routing layers have rules and preferred directions?
4. How can congestion hurt timing?
5. What is the antenna effect at a high level?

## Checkpoint

- [ ] you understand global vs detailed routing
- [ ] you understand metal layers and vias
- [ ] you found routing-related stages
- [ ] you inspected routing in OpenROAD
- [ ] you inspected final geometry in KLayout
- [ ] you know what an antenna violation represents
- [ ] you saved routing screenshots and notes

## References

- OpenROAD global routing: https://openroad.readthedocs.io/
- OpenROAD detailed routing: https://openroad.readthedocs.io/
- SKY130 PDK documentation: https://skywater-pdk.readthedocs.io/
