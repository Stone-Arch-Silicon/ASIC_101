# Page 18 — Clock tree synthesis: distribute time across the chip

## What you are learning

Your RTL treats the clock almost like magic:

```verilog
always @(posedge clk)
```

Every flip-flop appears to receive the same perfect clock edge.

Real silicon cannot distribute a clock instantaneously.

The clock is an electrical signal traveling through physical wires and buffers.

**Clock Tree Synthesis (CTS)** builds that physical network.

## 1. Why clocks are special

The clock reaches many sequential elements.

That means it can have enormous fanout in a larger design.

A single tiny logic gate cannot directly drive thousands of clock pins with good edge quality.

So the implementation creates a buffered clock network.

Conceptually:

```text
                 clk
                  |
             root buffer
             /         \
        buffer         buffer
       /     \         /    \
     FF       FF      FF      FF
```

Real trees are much more complicated.

## 2. Clock latency

**Clock latency** is the time from the clock source/reference to when the clock edge reaches a sink.

For one sink:

```text
clock source
    ↓
clock buffers + wires
    ↓
flip-flop clock pin
```

The traversal takes time.

## 3. Clock skew

If two flip-flops receive the same nominal clock edge at different times, the difference is **clock skew**.

Example:

```text
FF1 clock arrives at 2.10 ns
FF2 clock arrives at 2.24 ns

skew = 0.14 ns
```

The sign and effect depend on the timing relationship being analyzed.

The key idea is that clocks are not physically simultaneous everywhere.

## 4. Why skew matters

Timing checks compare data arrival with the clock edges that launch and capture that data.

Clock arrival differences therefore change the timing budget.

Poor clock distribution can create or worsen:

```text
setup problems
hold problems
```

## 5. Setup intuition

For a simple register-to-register path:

```text
launch FF
   ↓
combinational logic
   ↓
capture FF
```

The data must arrive early enough before the capture edge to satisfy the capture register's setup requirement.

A simplified mental model is:

```text
available cycle time
>
clock-to-Q + data-path delay + setup requirement
```

Clock skew and uncertainty modify the real equation.

## 6. Hold intuition

Hold asks a different question:

```text
Does the new data change too soon after the capture clock edge?
```

Very short data paths can cause hold problems.

This surprises many beginners because “faster logic” sounds universally good.

It is not.

A design can fail because a path is:

```text
too slow for setup
```

or:

```text
too fast for hold
```

## 7. Find the CTS stage

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | grep -Ei 'cts|clock'
```

## 8. Inspect the clock network

Open OpenROAD:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Try to select or highlight the `clk` net.

Depending on the GUI and version, you may be able to trace the buffered clock tree visually.

Look for repeated clock-buffer structures feeding sequential elements.

## 9. Compare cell types before and after CTS

Because CTS inserts clock buffers, the design's cell count can increase.

This is a useful lesson:

```text
synthesis cell count ≠ final physical cell count
```

Physical implementation modifies the netlist for physical reasons.

## 10. Why a balanced tree is not perfectly balanced

Real geometry is irregular.

Clock sinks are at different coordinates.

Different branches have different:

```text
wire lengths
loads
buffer choices
parasitics
```

CTS attempts to manage latency and skew, but zero skew everywhere is not a realistic expectation.

## 11. Clock trees consume power

The clock switches every cycle.

That means its buffers and wires toggle continuously while the design is active.

Clock networks can therefore represent a significant fraction of dynamic power in large synchronous chips.

This is one reason clock gating exists in more advanced low-power design.

ASIC 101 does not need to implement clock gating, but you should understand why clocks are expensive.

## 12. Save CTS evidence

Save:

```text
screenshots/clock_tree.png
```

Create:

```text
reports/page18_cts_notes.md
```

Answer:

1. Why can one source not simply drive every clock pin directly?
2. What is clock latency?
3. What is clock skew?
4. What is the conceptual difference between setup and hold timing?
5. Why can CTS increase both area and power?

## Checkpoint

- [ ] you know why CTS exists
- [ ] you can define clock latency
- [ ] you can define clock skew
- [ ] you understand setup vs hold at an intuitive level
- [ ] you found the CTS stage
- [ ] you inspected the clock network
- [ ] you saved CTS evidence

## References

- OpenROAD CTS documentation: https://openroad.readthedocs.io/
- LibreLane timing-closure guide: https://librelane.readthedocs.io/en/stable/usage/timing_closure/
