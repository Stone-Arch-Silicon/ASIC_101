# Page 14 — Synthesis again, but now with real SKY130 standard cells

## What you are learning

On Page 10 you synthesized the ALU with Yosys to learn what synthesis means.

Now LibreLane has synthesized it **for a real technology library**.

That difference is fundamental.

Generic synthesis asks:

```text
What Boolean/sequential structure implements the RTL?
```

Technology mapping asks:

```text
Which cells that actually exist in this process should implement that structure?
```

## 1. From abstract logic to library cells

Your RTL may contain:

```verilog
assign p = a ^ b;
```

The source code does not say what transistor layout should implement XOR.

The SKY130 standard-cell library provides already-designed physical cells for functions such as:

```text
inverters
buffers
NAND
NOR
AND
OR
XOR
multiplexers
flip-flops
clock buffers
```

After technology mapping, your netlist contains instances with names from the selected library.

You may see names beginning with:

```text
sky130_fd_sc_hd__
```

## 2. Find the synthesis step

Set the run variable again if you opened a new shell:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"
```

Search the stage names:

```bash
find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'yosys|synth'
```

You may see multiple synthesis-related stages.

That is normal.

Do not rely on one hard-coded numeric prefix.

## 3. Find the final gate-level netlist

The final directory is usually the easiest stable place to begin:

```bash
find "$RUN/final" -type f \( -name '*.v' -o -name '*.nl.v' -o -name '*.pnl.v' \) | sort
```

The exact file naming depends on the view.

A file ending in something like:

```text
.nl.v
```

is a logical gate-level netlist.

A physical netlist may include explicit power connections and use a name such as:

```text
.pnl.v
```

## 4. Search for SKY130 cells

Choose the final synthesized/physical netlist and run something like:

```bash
grep -o 'sky130_fd_sc_hd__[A-Za-z0-9_]*' <NETLIST_FILE> \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -30
```

Replace `<NETLIST_FILE>` with the actual path you found.

You should see a count of cell names.

For example, the design may contain classes of cells corresponding to:

```text
flip-flops
muxes
inverters
NAND/NOR gates
XOR/XNOR gates
buffers
```

Your exact mapping may differ with tool versions and optimization settings.

## 5. A standard-cell name contains information

A name such as:

```text
sky130_fd_sc_hd__buf_2
```

can be read conceptually as:

```text
sky130              process family
fd_sc               foundry digital standard cell
hd                  high-density library
buf                 buffer function
2                   drive-strength variant
```

Do not memorize every naming convention.

The important point is that synthesis is now choosing **real cells with real characterized timing and physical dimensions**.

## 6. Why are there multiple drive strengths?

A tiny inverter driving one nearby gate does not need the same transistor size as a buffer driving a large fanout.

A stronger cell can usually drive more capacitance or transition faster, but it often costs:

```text
more area
more input capacitance
more power
```

Physical-design optimization is full of tradeoffs like this.

## 7. Look for your registers

Your `alu_top` contains input and output registers.

Therefore the mapped design should contain sequential cells.

Search the cell count for names that correspond to flip-flops.

Do not worry if the exact cell type is different from what you expected.

Synthesis and optimization are allowed to choose equivalent cells.

## 8. Why source hierarchy may disappear

You wrote modules such as:

```text
alu_top
alu_core
adder8
```

but after optimization the physical netlist may not preserve that hierarchy cleanly.

The tools may:

```text
flatten modules
propagate constants
merge equivalent logic
rewrite Boolean equations
resize cells
insert buffers
```

The contract is functional equivalence under the design constraints—not source-code prettiness.

## 9. Synthesis statistics are only the beginning

At this stage, you can count cells.

But a cell count alone does **not** tell you final ASIC area or performance.

Why?

Because physical design has not yet been fully considered in a cell count.

Real timing depends on:

```text
cell delay
wire length
wire resistance
wire capacitance
fanout
buffering
clock arrival
PVT corner
```

Real physical area also includes:

```text
cell footprints
spacing
power structures
routing resources
physical-only cells
```

## 10. Compare generic Yosys output with ASIC-mapped output

Open both:

```text
~/asic_101/build/alu_top_synth.v
```

from Page 10 and the mapped netlist from LibreLane.

Ask:

1. Which one contains SKY130 cell names?
2. Which one is process-independent?
3. Which one can be connected to characterized SKY130 timing models?
4. Which one is much closer to something that can be physically placed?

Write a short answer in:

```text
reports/page14_synthesis_notes.md
```

## 11. Save synthesis evidence

Create a compact cell summary:

```bash
grep -o 'sky130_fd_sc_hd__[A-Za-z0-9_]*' <NETLIST_FILE> \
  | sort \
  | uniq -c \
  | sort -nr \
  > ../reports/sky130_cell_counts.txt
```

Do not worry if physical-design stages later add more buffers or special cells.

That is part of the lesson.

## Checkpoint

- [ ] you can explain generic synthesis vs technology mapping
- [ ] you found a gate-level SKY130 netlist
- [ ] you found `sky130_fd_sc_hd__...` cell instances
- [ ] you identified at least one sequential cell class
- [ ] you understand that multiple drive strengths trade area/power for electrical strength
- [ ] you understand why source hierarchy can change
- [ ] you saved a cell-count summary

## References

- Yosys: https://yosyshq.readthedocs.io/
- LibreLane PDKs and standard cells: https://librelane.readthedocs.io/en/stable/usage/about_pdks.html
- SKY130 standard-cell documentation: https://skywater-pdk.readthedocs.io/
