# Page 16 — Power distribution: VDD and ground are physical networks

## What you are learning

In RTL, power is invisible.

You write:

```verilog
assign y = a & b;
```

and never write:

```text
connect this gate to 1.8 V
connect this gate to ground
```

Real transistors cannot function without a physical supply network.

This page introduces the **power distribution network**, or PDN.

## 1. Logic signals and power are different jobs

Signal nets carry information:

```text
a[0]
carry
clk
y[3]
```

Power nets supply energy:

```text
VDD / VPWR
ground / VGND
```

A power network must deliver current to every active cell while keeping the supply voltage acceptably stable.

## 2. The hierarchy of a power network

A simplified macro PDN might look like:

```text
upper-metal power straps
          ↓
      lower straps
          ↓
standard-cell power rails
          ↓
     cell power pins
          ↓
      transistors
```

The exact metal layers and topology depend on the process and design configuration.

## 3. Why not use one skinny wire for VDD?

A wire has resistance.

Current through resistance causes a voltage drop:

```text
V = I × R
```

If too much current flows through a resistive supply path, the local supply voltage can fall.

This is called **IR drop**.

A logic gate expecting a nominal supply may become slower or unreliable if its local supply is too low.

## 4. Why wider and upper metal can help

Wider conductors generally have lower resistance than narrow conductors of the same material and length.

Upper routing layers are often physically thicker or otherwise designed to support longer, lower-resistance connections.

That makes upper metal useful for distributing power across larger distances.

## 5. Vias connect metal layers

If a route changes from one metal layer to another, it needs a **via**.

Conceptually:

```text
Metal 3  ========
            |
           VIA
            |
Metal 2  ========
```

A real PDN is therefore a three-dimensional network of:

```text
metal segments
vias
rails
straps
```

## 6. Find the PDN stage

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'pdn|power|irdrop'
```

PDN generation normally occurs early in physical design, before ordinary signal routing is complete.

## 7. Inspect the power network visually

Open OpenROAD:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Use the display controls to hide or show routing layers.

Try to identify long, regular structures that belong to the power grid.

Then zoom into the standard-cell rows and look for the local rails feeding cells.

The visual goal is to understand that power is a **distributed physical network**, not an abstract constant.

## 8. Do not confuse power straps with signal routing

Power structures often look:

```text
regular
wide
repetitive
long
```

Signal routing is typically much more irregular because it follows the actual logical connectivity of the design.

## 9. What is electromigration?

Current physically flows through metal.

If current density is too high for too long, the metal can gradually degrade.

This reliability phenomenon is called **electromigration**.

PDN design is therefore concerned not only with voltage drop but also with whether conductors and vias can safely carry the required current.

You do not need to perform advanced EM analysis for this tiny course block.

But you should know why real chips care about:

```text
wire width
via count
current density
power-grid topology
```

## 10. What does an IR-drop report mean for this project?

LibreLane/OpenROAD may produce IR-drop-related analysis when sufficient information is available.

For a tiny educational ALU, treat the result as **flow exposure**, not as a measured prediction of a final packaged chip.

Real power integrity depends on assumptions about:

```text
activity
current draw
supply sources
package resistance
board/package delivery
process corner
```

The lesson is to know what the analysis is trying to answer.

## 11. Why power cannot be judged from the RTL alone

RTL can tell you how logic changes state.

But physical power depends on much more:

```text
which cells were selected
how large they are
how often nodes switch
clock frequency
voltage
wire capacitance
load capacitance
leakage characteristics
PVT corner
```

Physical implementation matters.

## 12. Save PDN evidence

Save a screenshot where the power network is visible:

```text
screenshots/pdn.png
```

Create:

```text
reports/page16_pdn_notes.md
```

Answer:

1. Why does a chip need a distributed power grid?
2. What is IR drop?
3. What does a via do?
4. Why can wide/upper-layer metal be useful for power?
5. Why is an IR-drop number from this tiny course macro not the same as complete-chip power-integrity signoff?

## Checkpoint

- [ ] you can distinguish signal nets from power nets
- [ ] you understand rails, straps, and vias
- [ ] you know what IR drop means
- [ ] you know what electromigration means at a high level
- [ ] you found the PDN-related flow stage
- [ ] you visually inspected the power grid
- [ ] you saved a PDN screenshot and notes

## References

- OpenROAD PDN documentation: https://openroad.readthedocs.io/
- LibreLane built-in steps: https://librelane.readthedocs.io/en/stable/reference/step_config_vars.html
