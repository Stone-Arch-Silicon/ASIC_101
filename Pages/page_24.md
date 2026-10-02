# Page 24 — Engineering experiment: compare three adder architectures fairly

## What you are learning

You began ASIC 101 with a ripple-carry adder because it is easy to derive and verify from first principles.

Now you finally have enough background to ask a more interesting engineering question:

```text
Does a different adder architecture produce a better physical ASIC implementation?
```

This is where carry lookahead and carry select belong.

Not as early branches that beginners copy without context, but as a **controlled architecture experiment**.

## 1. The rule of a fair comparison

Change one primary variable at a time.

For this experiment, keep constant:

```text
same ALU behavior
same top-level registers
same testbench expectations
same PDK
same standard-cell library
same clock target
same floorplan
same LibreLane version
same physical-design settings
```

Change only:

```text
adder architecture
```

Then compare the resulting implementation.

## 2. Architecture A — Ripple Carry Adder

This is your baseline from Part 1.

Conceptually:

```text
bit 0 carry
   ↓
bit 1 carry
   ↓
bit 2 carry
   ↓
...
   ↓
bit 7 carry
```

Its strength is simplicity.

Its weakness is a potentially long serial carry dependency.

## 3. Architecture B — Block Carry Lookahead Adder

Carry lookahead introduces **propagate** and **generate** signals.

For bit `i`:

```text
p[i] = a[i] XOR b[i]
g[i] = a[i] AND b[i]
```

The carry recurrence is:

```text
c[i+1] = g[i] OR (p[i] AND c[i])
```

Instead of implementing every carry as a strictly serial full-adder chain, lookahead expands carry conditions so logic can evaluate more of the dependency in parallel.

For ASIC 101, use two 4-bit lookahead blocks.

Create a separate variant file, for example:

```text
rtl_variants/cla/adder8.v
```

with:

```verilog
module cla4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  wire [3:0] p;
  wire [3:0] g;
  wire [4:0] c;

  assign p = a ^ b;
  assign g = a & b;

  assign c[0] = cin;

  assign c[1] = g[0] | (p[0] & c[0]);

  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);

  assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

  assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

  assign sum = p ^ c[3:0];
  assign cout = c[4];

endmodule

module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire carry4;

  cla4 u_low (
    .a    (a[3:0]),
    .b    (b[3:0]),
    .cin  (cin),
    .sum  (sum[3:0]),
    .cout (carry4)
  );

  cla4 u_high (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (carry4),
    .sum  (sum[7:4]),
    .cout (cout)
  );

endmodule
```

This is **block carry lookahead**, not one giant fully expanded 8-bit lookahead equation.

## 4. Architecture C — Carry Select Adder

Carry select trades extra hardware for reduced waiting on a later carry.

The idea is:

```text
compute upper result assuming carry-in = 0
compute upper result assuming carry-in = 1
when real carry arrives, select the correct result
```

That duplicates some arithmetic hardware.

Create:

```text
rtl_variants/carry_select/adder8.v
```

One simple implementation is:

```verilog
module ripple4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  wire [4:0] c;
  assign c[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : GEN_FA
      assign sum[i] = a[i] ^ b[i] ^ c[i];
      assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
    end
  endgenerate

  assign cout = c[4];

endmodule

module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire       c4;

  wire [3:0] upper_sum_c0;
  wire [3:0] upper_sum_c1;
  wire       upper_cout_c0;
  wire       upper_cout_c1;

  ripple4 u_low (
    .a    (a[3:0]),
    .b    (b[3:0]),
    .cin  (cin),
    .sum  (sum[3:0]),
    .cout (c4)
  );

  ripple4 u_upper_c0 (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (1'b0),
    .sum  (upper_sum_c0),
    .cout (upper_cout_c0)
  );

  ripple4 u_upper_c1 (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (1'b1),
    .sum  (upper_sum_c1),
    .cout (upper_cout_c1)
  );

  assign sum[7:4] = c4 ? upper_sum_c1  : upper_sum_c0;
  assign cout     = c4 ? upper_cout_c1 : upper_cout_c0;

endmodule
```

## 5. Never compare unverified variants

Before physical implementation, every architecture must pass the **same functional testbench**.

That means the exhaustive ALU test from Page 9 should pass unchanged.

Do not create special expected values for one architecture.

The whole point is:

```text
same function
three implementations
```

## 6. Organize the experiment cleanly

Create:

```text
asic_101/
├── rtl/
│   ├── adder8.v              # baseline ripple version
│   ├── alu_core.v
│   └── alu_top.v
├── rtl_variants/
│   ├── ripple/
│   │   └── adder8.v
│   ├── cla/
│   │   └── adder8.v
│   └── carry_select/
│       └── adder8.v
└── asic_variants/
    ├── ripple/
    ├── cla/
    └── carry_select/
```

Copy your baseline ripple adder into:

```text
rtl_variants/ripple/adder8.v
```

## 7. Give each variant its own LibreLane configuration

The easiest reproducible approach is one design directory per variant.

For example:

```text
asic_variants/ripple/config.json
asic_variants/cla/config.json
asic_variants/carry_select/config.json
```

Each should keep the same settings.

Only the path to `adder8.v` changes.

For the CLA version, for example:

```json
{
  "DESIGN_NAME": "alu_top",

  "VERILOG_FILES": [
    "dir::../../rtl_variants/cla/adder8.v",
    "dir::../../rtl/alu_core.v",
    "dir::../../rtl/alu_top.v"
  ],

  "CLOCK_PORT": "clk",
  "CLOCK_PERIOD": 10.0,

  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "sky130_fd_sc_hd",

  "FP_SIZING": "absolute",
  "DIE_AREA": [0, 0, 150, 150],
  "CORE_AREA": [10, 10, 140, 140],

  "FP_CORE_UTIL": 35,
  "PL_TARGET_DENSITY_PCT": 45
}
```

## 8. Run all three under the same environment

Inside the same Nix shell and without changing tool versions:

```bash
librelane ~/asic_101/asic_variants/ripple/config.json
librelane ~/asic_101/asic_variants/cla/config.json
librelane ~/asic_101/asic_variants/carry_select/config.json
```

If one fails, record the failure.

Do not secretly change only that variant's density or floorplan and then call the comparison fair.

If a common setting must change for routability, rerun **all three** with that same changed setting.

## 9. Build the comparison table

Create:

```text
reports/adder_architecture_comparison.md
```

with:

```markdown
| Metric | Ripple | CLA | Carry Select |
|---|---:|---:|---:|
| Functional verification | | | |
| Clock constraint | 10 ns | 10 ns | 10 ns |
| Cell count | | | |
| Standard-cell area | | | |
| Worst setup slack | | | |
| Worst hold slack | | | |
| Estimated power | | | |
| Routed wirelength | | | |
| Buffer count | | | |
| DRC status | | | |
| LVS status | | | |
| Final flow status | | | |
```

Use the actual metrics available in your LibreLane version.

## 10. Do not assume the textbook winner

You may expect:

```text
ripple = smallest but slowest
carry select = larger but faster
carry lookahead = faster carry logic
```

Those are useful architectural intuitions.

But your actual 8-bit synthesized results may not follow the stereotype cleanly.

Why?

Because:

```text
8 bits is tiny
synthesis can rewrite logic
standard-cell choices matter
wire delay matters
physical placement matters
mux delay matters
library cells differ
```

The correct answer is the implemented evidence.

## 11. Inspect the critical path for each design

For every architecture, record:

```text
critical-path startpoint
critical-path endpoint
major cell sequence
cell delay contribution
net delay contribution
```

Then ask:

```text
Did changing the adder actually change the critical path?
```

It may not.

Perhaps the output mux or another part of the ALU dominates.

That is precisely why physical implementation is valuable.

## 12. Optional experiment: tighten the clock

After the fair 10 ns comparison is complete, you can explore timing limits.

Try a common tighter period for all three, for example:

```text
8 ns
6 ns
4 ns
```

Do **not** blindly assume each will route successfully.

Record:

```text
which constraints close
where failures begin
how area/buffering changes
whether congestion appears
```

This turns the project into an actual architecture study.

## 13. Optional experiment: shrink the floorplan

You can also reduce the common die/core dimensions and rerun all three.

This explores:

```text
area pressure
utilization
congestion
routability
timing tradeoffs
```

Again, use identical physical constraints across designs.

## 14. Your engineering conclusion must explain *why*

Do not finish with:

```text
CLA got 0.7 ns better slack.
```

Explain what physically changed.

A strong conclusion discusses evidence such as:

```text
cell count
logic depth
critical path
buffering
wire delay
muxing
placement
routing
```

## Checkpoint

- [ ] all three adders implement the same interface
- [ ] all three pass the same functional verification
- [ ] all three use the same PDK/library/tool environment
- [ ] all three use the same clock and physical constraints
- [ ] you collected comparable PPA and signoff metrics
- [ ] you inspected the critical path for all three
- [ ] you wrote a physical explanation, not only a numeric ranking
- [ ] any extra clock/floorplan experiment was applied fairly to every design

## References

- LibreLane synthesis exploration/timing tools: https://librelane.readthedocs.io/en/stable/reference/flows.html
- LibreLane timing closure: https://librelane.readthedocs.io/en/stable/usage/timing_closure/
