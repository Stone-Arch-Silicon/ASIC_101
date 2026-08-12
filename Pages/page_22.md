# Signoff checks: DRC, LVS, antenna, XOR, and manufacturability

A GDS file is only useful if its geometry is legal and its extracted connectivity matches the intended circuit.

## Overview

Several different checks answer different questions.

| check | question |
|-------|----------|
| DRC | Is the geometry legal for the manufacturing rules? |
| LVS | Does the extracted layout connectivity match the schematic/netlist? |
| Antenna | Could manufacturing charge damage transistor gates? |
| XOR | Do two independently generated layout streams match geometrically? |
| STA | Does timing satisfy the constraints across required corners? |
| IR drop | Is the supply network electrically acceptable under the modeled conditions? |

Passing one does not imply passing the others.

### DRC

Design Rule Checking tests geometry rules such as:

```text
minimum metal width
minimum spacing
via enclosure
minimum area
layer interaction rules
```

### LVS

Layout Versus Schematic asks:

```text
Does the circuit extracted from the physical layout
match the intended netlist?
```

DRC can pass while LVS fails.

A beautiful legal layout can still be electrically wrong.

### XOR

LibreLane can stream GDS through more than one backend and compare them.

Geometric differences may reveal stream-out inconsistencies.

## Prerequisites

- [PPA analysis](page_21.md)

## Steps

### 1. Find DRC steps

```bash
RUN=$(ls -dt runs/* | head -1)

find "$RUN" -maxdepth 1 -type d \
  \( -iname '*magic-drc*' -o -iname '*klayout-drc*' \)
```

### 2. Search DRC reports

```bash
grep -RniE "drc|violation|error|count" \
  "$RUN"/*drc* 2>/dev/null | head -120
```

Record Magic and KLayout DRC results separately if both are present.

### 3. Find LVS

```bash
LVS_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -iname '*netgen-lvs*' | head -1)

echo "$LVS_DIR"
```

Inspect:

```bash
grep -RniE "match|mismatch|lvs|error|net|device" \
  "$LVS_DIR" | head -150
```

The desired result is logical/layout equivalence under the checker's rules.

### 4. Find antenna checks

```bash
find "$RUN" -maxdepth 1 -type d -iname '*antenna*'
```

Inspect the reports before and after repair when both exist.

### 5. Find XOR

```bash
find "$RUN" -maxdepth 1 -type d -iname '*xor*'
```

Look for the reported geometric-difference count.

### 6. Read the manufacturability summary

Find:

```bash
find "$RUN" -maxdepth 2 -type f \
  -iname '*manufactur*' -o -iname '*summary*'
```

Also inspect:

```text
error.log
warning.log
```

from the run root.

### 7. Do not ignore deferred errors

Some flows continue through multiple checks so you can collect more information before the final failure.

That means:

```text
flow reached GDS
```

does **not** necessarily mean:

```text
flow passed signoff
```

Read the final status and checker reports.

### 8. Understand what "clean" means

For this educational macro, a strong result is:

```text
0 DRC violations
LVS clean
0 unresolved antenna violations
0 disconnected pins/nets
no setup violations
no hold violations
acceptable IR-drop report
consistent stream-out/XOR result
```

The exact requirements for a real tapeout are defined by the foundry/shuttle/integration platform.

### 9. Save evidence

Save:

```text
screenshots/drc_clean.png
screenshots/lvs_clean.png
screenshots/signoff_summary.png
```

## Results

Create:

| signoff item | result |
|--------------|--------|
| Magic DRC | |
| KLayout DRC | |
| LVS | |
| Antenna | |
| XOR | |
| Setup | |
| Hold | |
| Disconnected pins | |
| IR drop | |

## Checklist

- [ ] Checked Magic DRC
- [ ] Checked KLayout DRC
- [ ] Checked LVS
- [ ] Checked antenna
- [ ] Checked XOR
- [ ] Checked setup
- [ ] Checked hold
- [ ] Checked run error/warning logs
- [ ] Continued to page 23

---

*Questions? Ask in the network Discord.*
