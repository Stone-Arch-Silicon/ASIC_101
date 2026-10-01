# Page 9 — Verify the ALU properly

## What you are learning

Verification is not “look at a waveform and decide it seems okay.”

A good beginner project should tell you automatically when it is wrong.

On this page you will:

- exhaustively verify every combinational ALU input
- keep the exhaustive test separate from waveform generation
- create a small directed waveform test
- learn a repeatable debugging process

## 1. How many ALU input combinations exist?

The ALU core has:

```text
256 possible values of a
256 possible values of b
8 possible values of op
```

Therefore:

```text
256 × 256 × 8 = 524,288
```

input combinations.

That is small enough to simulate exhaustively.

For a large processor, exhaustive simulation would be impossible.

For this tiny ALU, it is ideal.

## 2. Create the exhaustive testbench

Create:

```text
sim/alu_tb.v
```

with:

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
        y        !== exp_y        ||
        carry    !== exp_carry    ||
        overflow !== exp_overflow ||
        zero     !== exp_zero     ||
        negative !== exp_negative
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

## 3. Why the testbench may use `+`

The design rule says:

> `adder8` must explicitly implement the adder structure.

The testbench is different.

Its job is to calculate an independent expected answer.

Using:

```verilog
+
```

inside the testbench is appropriate because it gives us a simple reference model to compare against the custom hardware.

## 4. Compile and run the exhaustive test

```bash
iverilog \
  -g2012 \
  -Wall \
  -s alu_tb \
  -o build/alu_tb.vvp \
  rtl/adder8.v \
  rtl/alu_core.v \
  sim/alu_tb.v

vvp build/alu_tb.vvp
```

You want:

```text
PASS: all 524288 exhaustive ALU vectors passed.
```

Do not continue with known failures.

## 5. Do not dump every exhaustive vector to a waveform

A common beginner mistake is to create a VCD for a huge test.

That can create unnecessarily large waveform files.

Instead:

```text
exhaustive test → automatic PASS/FAIL
small directed test → waveform
```

Use each tool for what it does best.

## 6. Create a directed waveform testbench

Create:

```text
sim/alu_wave_tb.v
```

with:

```verilog
`timescale 1ns/1ps

module alu_wave_tb;

  reg  [7:0] a;
  reg  [7:0] b;
  reg  [2:0] op;

  wire [7:0] y;
  wire       carry;
  wire       overflow;
  wire       zero;
  wire       negative;

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

  initial begin

    $dumpfile("build/alu_wave.vcd");
    $dumpvars(0, alu_wave_tb);

    // ADD: 1 + 1 = 2
    a = 8'h01;
    b = 8'h01;
    op = 3'b000;
    #10;

    // ADD with signed overflow: 127 + 1
    a = 8'h7F;
    b = 8'h01;
    op = 3'b000;
    #10;

    // SUB: 0 - 1 = FF (-1 in signed interpretation)
    a = 8'h00;
    b = 8'h01;
    op = 3'b001;
    #10;

    // XOR
    a = 8'hAA;
    b = 8'h55;
    op = 3'b100;
    #10;

    // Shift left
    a = 8'h81;
    b = 8'h00;
    op = 3'b110;
    #10;

    // Shift right
    a = 8'h81;
    b = 8'h00;
    op = 3'b111;
    #10;

    $finish;
  end

endmodule
```

Compile and run:

```bash
iverilog \
  -g2012 \
  -Wall \
  -s alu_wave_tb \
  -o build/alu_wave_tb.vvp \
  rtl/adder8.v \
  rtl/alu_core.v \
  sim/alu_wave_tb.v

vvp build/alu_wave_tb.vvp
```

Open:

```bash
gtkwave build/alu_wave.vcd
```

Add:

```text
a
b
op
y
carry
overflow
zero
negative
```

Save:

```text
screenshots/alu_waveform.png
```

## 7. Debugging procedure

When a test fails, do not randomly edit code.

Use this sequence.

### Step A — read the first failing vector

Example:

```text
FAIL op=001 a=00 b=01 ...
```

That already tells you which operation and operands triggered the bug.

### Step B — reproduce only that case

Put the failing input into the directed waveform test.

### Step C — inspect intermediate signals

Open the DUT hierarchy and inspect signals such as:

```text
sub
b_arith
arithmetic_result
arithmetic_cout
```

### Step D — trace backward

Ask:

```text
Where is the first signal that becomes wrong?
```

That is usually more useful than staring only at the final output.

### Step E — fix one thing and rerun the full test

After fixing the directed case, rerun all:

```text
524,288
```

vectors.

A local fix is not enough if it breaks another case.

## 8. Common beginner bugs

### Wrong width

Example:

```verilog
reg [7:0] tmp;
```

cannot hold a 9-bit carry-out.

Use:

```verilog
reg [8:0] tmp;
```

when checking 8-bit addition plus carry.

### Signedness assumptions

A bit pattern has no inherent human meaning unless you know how the logic interprets it.

For example:

```text
11111111
```

may be:

```text
255 unsigned
```

or:

```text
-1 signed two's complement
```

### Latches

If a combinational `always @*` block does not assign every output on every path, synthesis may infer storage.

### Confusing carry with overflow

They describe different arithmetic conditions.

### Huge waveforms

Do not dump every signal for every exhaustive vector unless you have a specific reason.

## 9. Save your verified revision

Once the exhaustive test passes:

```bash
git add rtl sim screenshots
git commit -m "Verify 8-bit ALU"
```

This gives you a known-good RTL revision before synthesis.

## Before continuing

You are ready for synthesis when:

- [ ] the adder exhaustive test passes
- [ ] all 524,288 ALU combinations pass
- [ ] you inspected the directed ALU waveform
- [ ] you understand how to reproduce a failing vector
- [ ] the verified RTL is committed to Git
