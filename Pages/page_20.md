# Page 20 — Parasitics and static timing analysis

## What you are learning

A routed wire is not ideal.

It has electrical behavior.

After routing, the tools can estimate that behavior from the physical geometry and perform much more realistic timing analysis.

This page connects three ideas:

```text
physical wires
→ parasitic RC
→ timing delay
```

## 1. What are parasitics?

In ideal RTL, a wire has no delay.

In real silicon, interconnect has unwanted but unavoidable electrical properties.

The two most important introductory effects are:

```text
R = resistance
C = capacitance
```

Together they contribute to signal delay and transition behavior.

## 2. Why long wires are usually more expensive

A longer wire generally contains more physical material and interacts with more surrounding conductor area.

That tends to increase parasitic effects.

Therefore placement and routing can change performance even when the logical Boolean function is identical.

## 3. What OpenRCX does

LibreLane uses parasitic extraction tooling such as OpenRCX to estimate interconnect resistance and capacitance from the routed design.

The extracted information can be represented in files such as:

```text
SPEF
```

SPEF stands for **Standard Parasitic Exchange Format**.

You do not need to read a full SPEF by hand.

You need to understand what it represents.

## 4. Find the SPEF files

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN/final" -type f -name '*.spef' | sort
```

You may see more than one file because timing can be analyzed under multiple corners.

## 5. What is a timing corner?

Transistor and wire behavior changes with operating and manufacturing conditions.

Timing analysis therefore considers different **corners**.

A PVT corner describes:

```text
Process
Voltage
Temperature
```

For example, SKY130 timing libraries include characterized conditions representing different process speeds, voltages, and temperatures.

Interconnect extraction can also have minimum/nominal/maximum RC assumptions.

The point is not to trust one perfect “delay number.”

The implementation must be considered under relevant operating conditions.

## 6. What Static Timing Analysis does

**Static Timing Analysis (STA)** checks timing paths mathematically without requiring you to simulate every possible input vector.

STA knows things such as:

```text
clock constraints
cell delays
wire delays
setup requirements
hold requirements
clock arrival times
```

It propagates timing information through the design and checks whether constraints are met.

## 7. Four useful timing-path categories

A timing path can conceptually be:

```text
input  → output
input  → register
register → output
register → register
```

For ASIC 101, the registered `alu_top` gives you meaningful register-to-register paths through the ALU logic.

## 8. Slack

Slack is one of the most important numbers in digital timing.

Conceptually:

```text
slack = required time - actual arrival time
```

For a setup check:

```text
positive slack → requirement met
zero slack     → exactly on the boundary
negative slack → timing violation
```

Do not confuse a positive number with “the path delay.”

Slack is the **margin relative to a requirement**.

## 9. Worst Negative Slack and Total Negative Slack

Two common summary concepts are:

### WNS — Worst Negative Slack

The worst single timing margin.

If the worst path has:

```text
slack = -0.35 ns
```

then timing is violated by 0.35 ns on that path.

### TNS — Total Negative Slack

A summary of negative slack across violating endpoints/paths according to the reporting methodology.

WNS tells you about the worst offender.

TNS gives a sense of how widespread timing failure is.

## 10. Find timing-related stages and reports

Run:

```bash
find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'sta|timing|rcx|spef'
```

Then search text reports for slack:

```bash
grep -Rni --include='*.rpt' --include='*.log' 'slack' "$RUN" | head -80
```

Report organization can change between releases, so searching by concept is more durable than memorizing one path.

## 11. Read one timing path

Find a detailed setup or hold report and identify:

```text
Startpoint
Endpoint
Path Type
individual cell/net delays
data arrival time
data required time
slack
```

You do not need to understand every line yet.

Trace the path as a story:

```text
clock launches data
→ data passes through cells and wires
→ data reaches the destination
→ timing tool compares arrival against requirement
```

## 12. Cell delay vs net delay

A timing path is not only gates.

It contains:

```text
cell delay
+
interconnect/net delay
```

This is why a logically elegant design can still perform poorly after bad physical placement or routing.

## 13. What is the critical path?

For setup timing, the critical path is typically the path with the smallest setup slack.

In your ALU it may involve:

```text
input register
→ arithmetic logic
→ ALU result selection
→ output register
```

Do not assume the ripple-carry chain is automatically the final critical path.

Synthesis and physical implementation may restructure the logic.

**Measure the implemented design.**

## 14. Timing closure

Timing closure means iterating the design and physical implementation until required timing constraints are satisfied.

Possible changes include:

```text
RTL architecture
pipelining
cell sizing
buffering
placement
routing
clock tree
floorplan
constraints
```

A production design can require many iterations.

## 15. Save timing evidence

Create:

```text
reports/page20_timing_notes.md
```

Record:

```text
clock period
clock frequency
worst setup slack
worst hold slack
critical-path startpoint
critical-path endpoint
major logic/cells on the critical path
```

If timing is violated, do **not** hide it.

Write:

```text
TIMING VIOLATION PRESENT
```

and explain where.

That is better engineering than pretending the run is clean.

## Checkpoint

- [ ] you understand parasitic R and C
- [ ] you found SPEF output
- [ ] you know what a PVT corner represents
- [ ] you can define STA
- [ ] you can define slack
- [ ] you understand setup and hold are separate checks
- [ ] you identified one real timing path from the implementation
- [ ] you recorded timing evidence and any violations

## References

- LibreLane timing corners: https://librelane.readthedocs.io/en/stable/usage/timing_corners.html
- LibreLane timing closure: https://librelane.readthedocs.io/en/stable/usage/timing_closure/
