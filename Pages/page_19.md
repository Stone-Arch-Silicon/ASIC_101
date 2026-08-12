# Routing: turn nets into metal and vias

Routing creates the physical metal shapes that electrically connect the placed cells.

## Overview

Placement gives each pin a location.

Routing must connect pins through legal metal tracks while obeying:

```text
minimum width
minimum spacing
via rules
routing-layer rules
obstructions
capacity
antenna constraints
```

### Global routing

Global routing decides approximate paths and routing regions.

Think:

```text
which corridors and layers should this net use?
```

It estimates congestion and creates routing guides.

### Detailed routing

Detailed routing assigns actual legal tracks, segments, and vias.

Think:

```text
exactly which metal shape goes where?
```

### Preferred routing directions

Metal layers often have preferred horizontal or vertical routing directions.

Alternating directions makes multi-layer routing manageable.

Do not assume every wire stays on one layer.

### Vias

Whenever a routed connection changes metal layers, a via provides the vertical electrical connection.

### Congestion

Congestion occurs when too many nets compete for limited routing resources.

The router may respond by:

- detouring
- changing layers
- moving through less congested regions

Long detours add wirelength and parasitic RC.

## Prerequisites

- [clock tree synthesis](page_18.md)

## Steps

### 1. Find global routing

```bash
RUN=$(ls -dt runs/* | head -1)

GRT_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*globalrouting*' | head -1)

echo "$GRT_DIR"
```

### 2. Open global-routing state

```bash
librelane \
  --with-initial-state "$GRT_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

Inspect congestion/route guides if available in the GUI.

### 3. Find detailed routing

```bash
DRT_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*detailedrouting*' | head -1)

echo "$DRT_DIR"
```

Open it:

```bash
librelane \
  --with-initial-state "$DRT_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 4. Toggle metal layers

Turn layers on and off individually.

Observe that:

- one layer tends to carry one direction
- another carries the other direction
- vias connect them

### 5. Follow one signal

Select a net such as one output bit or an internal arithmetic net.

Trace it across:

```text
driver pin
wire segment
via
another metal layer
sink pin
```

### 6. Inspect the clock route

Compare the clock network with ordinary signal nets.

The clock may use different routing behavior or layer constraints than general signals.

### 7. Check total wirelength

The Classic flow includes wirelength reporting.

Search:

```bash
find "$RUN" -maxdepth 1 -type d -iname '*wirelength*'
```

and:

```bash
grep -RniE "wire|length" "$RUN"/*wirelength* 2>/dev/null | head -80
```

### 8. Understand antenna violations

During fabrication, long unconnected metal structures can accumulate charge during plasma processing.

That charge can damage thin transistor gate oxides.

This is the **antenna effect**.

The flow checks antenna properties and may repair violations using methods such as:

- routing changes
- antenna diodes

Antenna rules are manufacturing rules, not logical RTL rules.

### 9. Inspect detailed-routing DRC

Detailed routing also checks routing-rule violations.

Search:

```bash
grep -RniE "violation|drc|error" "$DRT_DIR" | head -100
```

### 10. Save screenshots

Save:

```text
screenshots/global_routing.png
screenshots/detailed_routing.png
screenshots/metal_layers.png
```

## Results

Record:

| routing item | value/observation |
|--------------|------------------:|
| Total wirelength | |
| Routing congestion | |
| Detailed-route violations | |
| Antenna violations before repair | |
| Antenna violations after repair | |
| Lowest signal routing layer | |
| Highest signal routing layer | |

## Checklist

- [ ] Understand global routing
- [ ] Understand detailed routing
- [ ] Can identify metal wires
- [ ] Can identify vias
- [ ] Inspected multiple metal layers
- [ ] Understand congestion
- [ ] Understand antenna effect
- [ ] Continued to page 20

---

*Questions? Ask in the network Discord.*
