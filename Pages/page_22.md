# Page 22 — Signoff checks: DRC, LVS, antenna, and “is this layout actually legal?”

## What you are learning

A beautiful GDS screenshot proves almost nothing by itself.

Before a layout is considered healthy, multiple different verification checks must answer different questions.

This page introduces the major physical signoff concepts you will encounter in the open-source flow.

## 1. One check cannot prove everything

Consider these questions:

```text
Does the geometry obey manufacturing rules?
Does the extracted connectivity match the intended circuit?
Does the design meet timing?
Are there antenna problems?
Did layout generation preserve the intended shapes?
```

These are different questions.

They require different checks.

## 2. DRC — Design Rule Checking

DRC asks:

```text
Is the physical geometry legal according to the process rules?
```

Examples of rules include:

```text
minimum metal width
minimum metal spacing
minimum area
via enclosure
layer overlap requirements
well/diffusion relationships
```

A DRC violation is not a logic error.

It is a **physical/manufacturing-rule error**.

## 3. Why foundries have design rules

Lithography and fabrication are physical processes with limits.

If two metal lines are too close, fabrication may not reliably produce the intended separation.

If a via is not properly enclosed, it may not connect reliably.

Design rules encode constraints required for manufacturability and reliability.

## 4. LVS — Layout Versus Schematic

LVS asks:

```text
Does the circuit extracted from the layout match the intended netlist/schematic connectivity?
```

Imagine a layout where two signals accidentally short together.

The geometry could theoretically satisfy local width/spacing rules yet still implement the wrong circuit.

LVS checks electrical connectivity, not merely geometric legality.

## 5. DRC-clean does not imply LVS-clean

This distinction is important enough to state directly:

```text
DRC asks: is the geometry legal?
LVS asks: is the connectivity correct?
```

Passing one does not prove the other.

## 6. Antenna checks

As introduced on Page 19, antenna checks protect against fabrication-time charge accumulation that can damage sensitive gate oxides.

A routed design can therefore be logically correct and DRC-clean but still have antenna violations.

## 7. XOR / layout consistency checks

Some flows compare two layout representations geometrically using XOR-style checks.

The basic idea is:

```text
layout A XOR layout B
```

If the geometry is identical, the difference should be empty.

This can help verify that different stream-out paths or representations agree.

## 8. Timing is also part of signoff thinking

A design can be:

```text
DRC-clean
LVS-clean
```

and still fail timing.

That means the silicon geometry may be legal and electrically connected correctly but not meet the required clock performance.

Signoff is multi-dimensional.

## 9. Find verification stages

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'drc|lvs|netgen|magic|klayout|antenna|xor|checker'
```

Different releases may use different step names or multiple implementations of similar checks.

## 10. Search for violations and failures

Useful generic searches include:

```bash
grep -Rni --include='*.rpt' --include='*.log' \
  -E 'violation|violations|error|mismatch|fail|unmatched' "$RUN" \
  | head -200
```

Do not treat every line containing the word `error` as a fatal signoff failure without context.

EDA reports can mention counts, historical messages, or tool diagnostics.

Read the surrounding report.

## 11. Inspect final metrics for signoff indicators

Use the `metrics.json` exploration script from Page 21 and search keys containing:

```text
drc
lvs
antenna
xor
viol
error
```

Record what the actual flow reports.

## 12. What should you do if a check fails?

Do **not** write:

```text
it probably doesn't matter
```

Instead classify it.

For each unresolved issue, record:

```text
check name
count/status
source report
likely cause if known
whether the issue blocks completion
what you tried
what remains unresolved
```

That is professional engineering behavior.

## 13. “A GDS file exists” is not a signoff statement

A flow can often generate layout output even if warnings or violations exist.

Therefore:

```text
GDS generated
```

is not equivalent to:

```text
design is tapeout-ready
```

## 14. A hardened macro is not automatically a standalone chip

Your `alu_top` layout is a digital macro/block.

A complete standalone chip typically also needs integration components such as:

```text
pad cells or bumps
ESD protection
power/ground pads
top-level power planning
clock/reset entry
package connectivity
I/O voltage domains
foundry/shuttle-specific checks
```

ASIC 101 is teaching the RTL-to-hardened-macro flow.

That is already a major milestone.

Do not oversell it as packaged, fabricated, or measured silicon.

## 15. Create a signoff summary

Create:

```text
reports/signoff_summary.md
```

with:

```markdown
# Signoff summary

| Check | Status | Evidence/report | Notes |
|---|---|---|---|
| RTL exhaustive verification | PASS/FAIL | | |
| Setup timing | PASS/FAIL | | |
| Hold timing | PASS/FAIL | | |
| Detailed-routing violations | PASS/FAIL | | |
| DRC | PASS/FAIL | | |
| LVS | PASS/FAIL | | |
| Antenna | PASS/FAIL | | |
| Other flow checks | PASS/FAIL | | |
```

If you cannot establish a status, write:

```text
UNKNOWN — needs investigation
```

Unknown is better than false confidence.

## Checkpoint

- [ ] you can explain DRC
- [ ] you can explain LVS
- [ ] you understand why DRC and LVS are independent
- [ ] you can explain antenna checks at a high level
- [ ] you understand why timing is a separate signoff dimension
- [ ] you found verification-related stages/reports
- [ ] you created a signoff summary
- [ ] you explicitly documented unresolved issues

## References

- LibreLane newcomers/signoff overview: https://librelane.readthedocs.io/en/stable/getting_started/newcomers/
- Magic: http://opencircuitdesign.com/magic/
- Netgen: http://opencircuitdesign.com/netgen/
- KLayout: https://www.klayout.de/
