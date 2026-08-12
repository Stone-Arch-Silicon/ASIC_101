# ASIC 101 project: build an 8-bit ALU

This project is your first complete hardware-design flow in Vivado. You will build one 8-bit ALU, choose one adder architecture, verify it, synthesize it, implement it, and collect timing, utilization, and power results.

## Overview

The project has one common specification, but you get to choose how the arithmetic hardware is built.

Everyone completes the same ALU. The only branch is the adder:

| adder | difficulty | go to |
|-------|------------|-------|
| Ripple Carry Adder | beginner | [page 4](page_4.md) |
| Carry Lookahead Adder | intermediate | [page 5](page_5.md) |
| Carry Select Adder | intermediate | [page 6](page_6.md) |

You only need to complete **one** adder.

After your adder works, everyone returns to [page 7](page_7.md) for verification.

Your final repository should contain:

```text
asic_101/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── sim/
│   └── alu_tb.v
├── constr/
│   └── alu.xdc
├── reports/
├── screenshots/
└── README.md
```

By the end, you should have:

- a working 8-bit ALU
- an automated testbench
- a synthesized Vivado design
- a routed Vivado implementation
- utilization results
- timing results
- power results
- a short engineering interpretation of the results

## Prerequisites

- AMD Vivado
- basic Verilog
- a target AMD/Xilinx FPGA part or board
- Git
- prior page: [What an ASIC is, and what we're building](page_1.md)

You do **not** need to program a physical FPGA board for this project. Vivado is being used as the synthesis, implementation, timing, and power-analysis environment.

## Steps

1. Create a folder named `asic_101`.

2. Create the directory structure shown above.

3. Open Vivado and select **Create Project**.

4. Create an **RTL Project**.

5. Select the FPGA board or part assigned by your university/team.

6. Do not add RTL yet if you have not written it.

7. Continue to the ALU specification on [page 3](page_3.md).

## Project rules

For the arithmetic block:

- You must choose exactly one adder architecture from pages 4–6.
- Your adder module must be named `adder8`.
- It must use the interface shown on page 3.
- Do not use `a + b` inside `adder8`.
- Do not use a vendor adder IP block.
- The `+` operator is allowed inside the **testbench** to calculate expected answers.
- Your chosen adder must perform both ADD and SUB operations inside the ALU.

The rest of the ALU may use normal Verilog operators.

## Results

At the end of the project, your README will contain a table like this:

| metric | result |
|--------|-------:|
| Adder architecture | — |
| LUTs | — |
| Flip-flops | — |
| Carry resources | — |
| Worst Negative Slack | — |
| Total Negative Slack | — |
| Total on-chip power | — |
| Dynamic power | — |
| Static power | — |

Do not fill these values in yet.

## Checklist

- [ ] Created the project folder
- [ ] Created the Vivado RTL project
- [ ] Selected a target FPGA
- [ ] Read the project rules
- [ ] Continued to page 3

---

*Questions? Ask in the network Discord.*
