# Synthesis: turn RTL into standard cells

Synthesis converts the behavioral RTL into a gate-level network and maps that network onto cells from the Sky130 standard-cell library.

## Overview

Start with RTL:

```verilog
always @(posedge clk) begin
  a_q <= a;
end
```

After synthesis, the design contains an actual library flip-flop cell.

Start with:

```verilog
assign y = a ^ b;
```

After synthesis, the logic may become:

- XOR cells
- NAND/NOR combinations
- AOI/OAI cells
- mux cells
- some other equivalent network

Synthesis is allowed to transform logic as long as the resulting circuit is logically equivalent under the design constraints.

### Three conceptual synthesis phases

```text
RTL elaboration
→ generic Boolean/sequential network
→ technology mapping
```

### Why your adder source may not survive literally

You chose an architecture such as:

```text
Ripple Carry
Carry Lookahead
Carry Select
```

That architecture expresses your RTL intent.

Yosys and its technology-mapping passes may:

- flatten hierarchy
- propagate constants
- simplify Boolean expressions
- remove redundant logic
- remap functions
- resize/restructure logic later in PNR

Therefore:

> compare the implemented results, not just the number of operators you typed.

## Prerequisites

- [baseline run complete](page_13.md)

## Steps

### 1. Locate the synthesis step

Find it without relying on a hard-coded step number:

```bash
RUN=$(ls -dt runs/* | head -1)
find "$RUN" -maxdepth 1 -type d -name '*yosys-synthesis*'
```

Store the directory:

```bash
SYNTH_DIR=$(find "$RUN" -maxdepth 1 -type d -name '*yosys-synthesis*' | head -1)
echo "$SYNTH_DIR"
```

### 2. Inspect synthesis output files

```bash
find "$SYNTH_DIR" -maxdepth 1 -type f -printf '%f\n' | sort
```

Look for:

```text
log files
netlists
reports
state_out.json
```

### 3. Search the mapped netlist for Sky130 cells

```bash
grep -R "sky130_fd_sc_hd__" "$SYNTH_DIR" | head -40
```

You should see standard-cell instance names.

### 4. Count cell-name occurrences

This is only a rough text-level exploration, not the authoritative area report:

```bash
grep -Rho "sky130_fd_sc_hd__[A-Za-z0-9_]*" "$SYNTH_DIR" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -30
```

Later OpenROAD/metrics reports provide more reliable physical counts and area.

### 5. Find the synthesis statistics

Search:

```bash
grep -RniE "area|cells|wires|ABC|stat" "$SYNTH_DIR" | head -80
```

Look at the Yosys log and identify:

- number of cells
- cell types
- sequential elements
- combinational elements
- area estimate if reported

### 6. Compare RTL and netlist

Ask:

```text
Can I still recognize the adder hierarchy?
Did synthesis flatten it?
What cell implements the input/output registers?
Are there explicit XOR cells?
Are there mux cells?
Were some operations combined?
```

### 7. Understand the clock before CTS

At this stage the design has clocked cells, but the **physical clock tree has not been built yet**.

Synthesis knows:

```text
these flip-flops are driven by clk
```

It does not yet know the final physical clock-buffer locations and routed clock wires.

### 8. Understand area at this stage

Synthesis area is mainly:

```text
sum of standard-cell areas
```

It is **not** final die area.

Final physical area also needs:

- whitespace
- placement rows
- tap/endcap cells
- clock buffers
- routing resources
- PDN
- physical margins
- possibly decap/filler cells

### 9. Save evidence

Save a short text excerpt or screenshot showing mapped Sky130 cells:

```text
screenshots/synthesis_cells.png
```

## Results

You should now understand the boundary:

```text
RTL describes function
synthesis chooses a gate-level implementation
physical design assigns real positions and wires
```

## Checklist

- [ ] Located the Yosys synthesis step
- [ ] Found a mapped netlist
- [ ] Found Sky130 standard-cell names
- [ ] Identified flip-flop cells
- [ ] Inspected synthesis statistics
- [ ] Understand why RTL architecture and final physical implementation may differ
- [ ] Continued to page 15

---

*Questions? Ask in the network Discord.*
