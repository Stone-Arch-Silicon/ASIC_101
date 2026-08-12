# Power distribution: VDD, ground, rails, straps, and IR drop

The power distribution network, or PDN, delivers current from the block's power connections to every standard cell.

## Overview

Logic gates cannot function without physical power.

A chip does not receive ideal `1` and `0` values.

It receives electrical supply networks:

```text
VDD / VPWR
ground / VGND
```

The PDN often has a hierarchy:

```text
upper metal straps
      ↓
lower-level power distribution
      ↓
standard-cell rails
      ↓
transistor source/body connections
```

### Signal routing and power routing are different jobs

Signal routing connects logic nets:

```text
adder carry
mux select
result bit
clock
```

Power routing distributes current to a huge number of cells.

A PDN needs:

- enough metal width
- enough connections
- appropriate pitch
- adequate via connections
- low enough resistance
- acceptable voltage drop

### IR drop

Any real conductor has resistance.

Voltage drop is approximately:

```text
V = I × R
```

If a region draws current through too much resistance, the local supply voltage falls.

That can:

- slow cells
- worsen timing
- reduce noise margin
- cause functional failure in severe cases

## Prerequisites

- [floorplanning](page_15.md)

## Steps

### 1. Find the PDN generation stage

```bash
RUN=$(ls -dt runs/* | head -1)

PDN_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*generatepdn*' | head -1)

echo "$PDN_DIR"
```

### 2. Open the design after PDN generation

```bash
librelane \
  --with-initial-state "$PDN_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 3. Hide signal layers selectively

Use the OpenROAD GUI layer controls.

Toggle metal layers on and off.

Find the repetitive VDD/ground structures.

Zoom in enough to distinguish:

```text
power rails
power straps
vias
```

### 4. Follow one power path conceptually

Pick a standard-cell row and answer:

```text
How does this row reach VDD?
How does it reach ground?
Which metal layers carry the larger PDN structures?
Where are vias used to change layers?
```

### 5. Understand vias

A wire on one metal layer does not automatically connect to a crossing wire on another layer.

A **via** is required for an electrical connection between layers.

In dense current paths, multiple vias may be used to reduce resistance and improve reliability.

### 6. Understand why upper metal is useful

Higher metal layers are often better suited to long-distance distribution because the process may provide different width/pitch/resistance options on those layers.

The exact layer usage is PDK- and flow-dependent.

### 7. Find the IR-drop report

The default Classic flow includes an OpenROAD IR-drop reporting step when enabled.

Find it:

```bash
find "$RUN" -maxdepth 1 -type d -iname '*irdrop*'
```

Inspect files:

```bash
IR_DIR=$(find "$RUN" -maxdepth 1 -type d -iname '*irdrop*' | head -1)
find "$IR_DIR" -maxdepth 2 -type f -printf '%p\n' | sort
```

Search reports:

```bash
grep -RniE "drop|voltage|worst|VDD|VPWR|VGND" "$IR_DIR" | head -100
```

### 8. Be careful interpreting tiny-design power

Our ALU is extremely small.

Its current profile is not representative of a CPU or large accelerator.

The goal here is to understand:

```text
the analysis
the physical structure
the meaning of voltage drop
```

not to claim this block has solved full-chip power integrity.

### 9. Save screenshots

Save:

```text
screenshots/pdn.png
screenshots/ir_drop.png
```

If the GUI provides an IR-drop heatmap for the loaded state, use it.

## Results

Record:

| PDN item | observation |
|----------|-------------|
| Main visible power layers | |
| Standard-cell rail direction | |
| Strap direction | |
| Worst reported voltage drop | |
| Any PDN warnings | |

## Checklist

- [ ] Can identify VDD/ground structures
- [ ] Know what a via does
- [ ] Know why PDN is not ordinary signal routing
- [ ] Understand IR drop
- [ ] Found the IR-drop report
- [ ] Saved PDN evidence
- [ ] Continued to page 17

---

*Questions? Ask in the network Discord.*
