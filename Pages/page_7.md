# Verify the complete ALU

Before synthesis, prove that the RTL is functionally correct. The testbench checks all 524,288 combinations of `a`, `b`, and `op`.

## Overview

There are

```text
256 possible values of a
256 possible values of b
8 possible operations
```

so the complete ALU input space is

```text
256 × 256 × 8 = 524,288 test vectors
```

Because this ALU is small, exhaustive simulation is practical.

The testbench is allowed to use normal Verilog arithmetic to calculate the expected result. The design under test is still required to use your custom `adder8`.

## Prerequisites

Complete exactly one adder page:

- [Ripple Carry](page_4.md)
- [Carry Lookahead](page_5.md)
- [Carry Select](page_6.md)

You should also have:

```text
rtl/adder8.v
rtl/alu_core.v
rtl/alu_top.v
```

## Steps

### 1. Create `sim/alu_tb.v`

```verilog
`timescale 1ns/1ps

module alu_tb;

  reg  [7:0] a;
  reg  [7:0] b;
  reg  [2:0] op;

  wire [7:0] y;
  wire       carry;
  wire       overflow;
  wire       zero;
  wire       negative;

  reg  [7:0] exp_y;
  reg        exp_carry;
  reg        exp_overflow;
  reg        exp_zero;
  reg        exp_negative;
  reg  [8:0] tmp;

  integer ia;
  integer ib;
  integer iop;
  integer errors;

  alu_core dut (
    .a        (a),
    .b        (b),
    .op       (op),
    .y        (y),
    .carry    (carry),
    .overflow (overflow),
    .zero     (zero),
    .negative (negative)
  );

  task check_current;
    begin
      exp_y        = 8'h00;
      exp_carry    = 1'b0;
      exp_overflow = 1'b0;
      tmp          = 9'h000;

      case (op)
        3'b000: begin
          tmp          = {1'b0, a} + {1'b0, b};
          exp_y        = tmp[7:0];
          exp_carry    = tmp[8];
          exp_overflow = (~(a[7] ^ b[7])) & (exp_y[7] ^ a[7]);
        end

        3'b001: begin
          tmp          = {1'b0, a} + {1'b0, (~b)} + 9'd1;
          exp_y        = tmp[7:0];
          exp_carry    = tmp[8];
          exp_overflow = (a[7] ^ b[7]) & (exp_y[7] ^ a[7]);
        end

        3'b010: exp_y = a & b;
        3'b011: exp_y = a | b;
        3'b100: exp_y = a ^ b;
        3'b101: exp_y = ~a;
        3'b110: exp_y = a << 1;
        3'b111: exp_y = a >> 1;
      endcase

      exp_zero     = (exp_y == 8'h00);
      exp_negative = exp_y[7];

      #1;

      if (
        (y        !== exp_y)        ||
        (carry    !== exp_carry)    ||
        (overflow !== exp_overflow) ||
        (zero     !== exp_zero)     ||
        (negative !== exp_negative)
      ) begin

        if (errors < 20) begin
          $display(
            "FAIL op=%b a=%h b=%h | y=%h c=%b v=%b z=%b n=%b | expected y=%h c=%b v=%b z=%b n=%b",
            op, a, b,
            y, carry, overflow, zero, negative,
            exp_y, exp_carry, exp_overflow, exp_zero, exp_negative
          );
        end

        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    a      = 8'h00;
    b      = 8'h00;
    op     = 3'b000;

    // A few recognizable vectors appear at the beginning of the waveform.
    a = 8'h01; b = 8'h01; op = 3'b000; check_current;
    a = 8'h7F; b = 8'h01; op = 3'b000; check_current;
    a = 8'h00; b = 8'h01; op = 3'b001; check_current;
    a = 8'hAA; b = 8'h55; op = 3'b100; check_current;
    a = 8'h81; b = 8'h00; op = 3'b110; check_current;
    a = 8'h81; b = 8'h00; op = 3'b111; check_current;

    // Exhaustive verification.
    for (iop = 0; iop < 8; iop = iop + 1) begin
      for (ia = 0; ia < 256; ia = ia + 1) begin
        for (ib = 0; ib < 256; ib = ib + 1) begin
          op = iop[2:0];
          a  = ia[7:0];
          b  = ib[7:0];
          check_current;
        end
      end
    end

    if (errors == 0)
      $display("PASS: all 524288 exhaustive ALU vectors passed.");
    else
      $display("FAIL: %0d vectors failed.", errors);

    $finish;
  end

endmodule
```

### 2. Add the simulation source in Vivado

Under **Simulation Sources**:

1. add `sim/alu_tb.v`
2. set `alu_tb` as the simulation top
3. keep `alu_top` as the synthesis top

The testbench intentionally instantiates `alu_core` directly so the combinational logic can be exhaustively checked without worrying about pipeline latency.

### 3. Run Behavioral Simulation

In Flow Navigator:

```text
Simulation
→ Run Simulation
→ Run Behavioral Simulation
```

Run until the testbench reaches `$finish`.

You want to see:

```text
PASS: all 524288 exhaustive ALU vectors passed.
```

### 4. Inspect the waveform

Zoom in near the beginning of the simulation.

Find at least:

- one ADD
- one SUB
- one bitwise operation
- one shift

Confirm that the waveform matches what you expect.

### 5. Save evidence

Save:

```text
screenshots/simulation.png
```

The screenshot should show:

- `a`
- `b`
- `op`
- `y`
- the four flags

Also save or screenshot the final PASS message.

Do not continue to synthesis with known simulation failures.

## Results

Your project should now pass functional verification before implementation.

| verification item | expected result |
|-------------------|-----------------|
| Directed vectors | pass |
| Exhaustive vectors | 524,288 pass |
| ADD/SUB flags | pass |
| Waveform inspected | yes |

## Checklist

- [ ] Added `alu_tb.v`
- [ ] Set the correct simulation top
- [ ] Behavioral simulation completed
- [ ] All 524,288 exhaustive vectors passed
- [ ] Saved a waveform screenshot
- [ ] Continued to page 8

Continue to [Synthesize and implement in Vivado](page_8.md).

---

*Questions? Ask in the network Discord.*
