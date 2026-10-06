# Page 8 — Build the complete 8-bit ALU

## What you are learning

Now we combine the ideas from the previous pages into the main ASIC 101 design.

You will create:

```text
adder8
    ↓
alu_core
    ↓
alu_top
```

The ALU core is combinational.

The top level adds input and output registers so the ASIC flow later has a clear synchronous timing path.

## 1. ALU interface

The inputs are:

```text
a   : 8 bits
b   : 8 bits
op  : 3 bits
```

The operation encoding is:

| `op` | Operation | Result |
| --- | --- | --- |
| `000` | ADD | `a + b` through `adder8` |
| `001` | SUB | `a - b` through `adder8` |
| `010` | AND | `a & b` |
| `011` | OR | `a \| b` |
| `100` | XOR | `a ^ b` |
| `101` | NOT | `~a` |
| `110` | Shift left | `a << 1` |
| `111` | Shift right | `a >> 1` |

The outputs are:

```text
y
carry
overflow
zero
negative
```

## 2. Status flags

### `zero`

```text
1 when y == 0
```

### `negative`

```text
most-significant bit of y
```

For an 8-bit two's-complement value, `y[7] = 1` means the result is negative.

### `carry`

Meaningful for ADD and SUB according to the arithmetic convention described on Page 7.

### `overflow`

Signals signed two's-complement overflow for ADD and SUB.

## 3. Create `alu_core`

Create:

```text
rtl/alu_core.v
```

with:

```verilog
module alu_core (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,

  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  wire       sub;
  wire [7:0] b_arith;
  wire [7:0] arithmetic_result;
  wire       arithmetic_cout;

  assign sub     = (op == 3'b001);
  assign b_arith = b ^ {8{sub}};

  adder8 u_adder (
    .a    (a),
    .b    (b_arith),
    .cin  (sub),
    .sum  (arithmetic_result),
    .cout (arithmetic_cout)
  );

  always @* begin

    // Safe defaults.
    // Every output gets a value for every path through this block.
    y        = 8'h00;
    carry    = 1'b0;
    overflow = 1'b0;

    case (op)

      3'b000: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (~(a[7] ^ b[7])) & (arithmetic_result[7] ^ a[7]);
      end

      3'b001: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (a[7] ^ b[7]) & (arithmetic_result[7] ^ a[7]);
      end

      3'b010: y = a & b;
      3'b011: y = a | b;
      3'b100: y = a ^ b;
      3'b101: y = ~a;
      3'b110: y = a << 1;
      3'b111: y = a >> 1;

      default: y = 8'h00;

    endcase

    zero     = (y == 8'h00);
    negative = y[7];

  end

endmodule
```

## 4. Why this `always` block is combinational

The sensitivity list is:

```verilog
always @*
```

That tells Verilog to re-evaluate the block when any relevant input changes.

Inside this combinational block, we use blocking assignments:

```verilog
=
```

That is different from the nonblocking assignments used in the clocked register on Page 6.

## 5. Why default assignments matter

At the beginning of the block:

```verilog
y        = 8'h00;
carry    = 1'b0;
overflow = 1'b0;
```

Every output is assigned on every possible path.

If a combinational procedural block fails to assign an output for some condition, synthesis may infer storage, commonly called a **latch**.

For this ALU, we do not want latches.

Safe defaults make the intended combinational behavior explicit.

## 6. Create the registered top level

Create:

```text
rtl/alu_top.v
```

with:

```verilog
module alu_top (
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,

  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  reg [7:0] a_q;
  reg [7:0] b_q;
  reg [2:0] op_q;

  wire [7:0] y_comb;
  wire       carry_comb;
  wire       overflow_comb;
  wire       zero_comb;
  wire       negative_comb;

  alu_core u_core (
    .a        (a_q),
    .b        (b_q),
    .op       (op_q),
    .y        (y_comb),
    .carry    (carry_comb),
    .overflow (overflow_comb),
    .zero     (zero_comb),
    .negative (negative_comb)
  );

  always @(posedge clk) begin

    if (!rst_n) begin

      a_q      <= 8'h00;
      b_q      <= 8'h00;
      op_q     <= 3'b000;

      y        <= 8'h00;
      carry    <= 1'b0;
      overflow <= 1'b0;
      zero     <= 1'b1;
      negative <= 1'b0;

    end
    else begin

      a_q      <= a;
      b_q      <= b;
      op_q     <= op;

      y        <= y_comb;
      carry    <= carry_comb;
      overflow <= overflow_comb;
      zero     <= zero_comb;
      negative <= negative_comb;

    end

  end

endmodule
```

## 7. Understand the data path

The structure is:

```text
external inputs
      ↓
input registers: a_q, b_q, op_q
      ↓
combinational alu_core
      ↓
output registers
      ↓
external outputs
```

This gives later timing analysis a path like:

```text
launch register
      ↓
combinational logic
      ↓
capture register
```

## 8. Understand the latency

Because the top level has input and output registers, the external input sampled at one rising edge is processed and captured at a later edge.

Do not treat `alu_top` as zero-latency combinational logic.

For exhaustive functional verification, we will test `alu_core` directly.

For implementation and timing, we will synthesize `alu_top`.

That is intentional.

## 9. Compile the whole hierarchy

Run:

```bash
iverilog \
  -g2012 \
  -Wall \
  -s alu_top \
  -o build/alu_top.vvp \
  rtl/adder8.v \
  rtl/alu_core.v \
  rtl/alu_top.v
```

You should get no compile errors.

## 10. Check your source tree

You should now have:

```text
rtl/
├── logic_demo.v
├── register8.v
├── adder8.v
├── alu_core.v
└── alu_top.v
```

The main project files are:

```text
adder8.v
alu_core.v
alu_top.v
```

## Before continuing

You should understand:

- why `alu_core` is combinational
- why `alu_top` contains registers
- why ADD and SUB use the custom `adder8`
- why default assignments prevent unintended latches
- why `alu_core` and `alu_top` are tested for different purposes
