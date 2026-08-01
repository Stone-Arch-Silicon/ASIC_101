# What an ASIC is, and what we're building

> Drop this file in as `Pages/page_1.md` to see the theme with real content. Replace it with the actual lesson.

An **ASIC** — application-specific integrated circuit — is a chip built to do one job, with the logic frozen into the silicon at manufacturing time. That's the trade: an FPGA can be reprogrammed after it ships, an ASIC can't, and in exchange the ASIC is smaller, faster, and far cheaper per unit at volume.

ASIC 101 walks the whole path once, end to end, on a design small enough to finish: RTL, simulation, synthesis, place and route, and a GDS file that could actually be taped out.

## What you need before lesson 2

- A Linux shell you're comfortable in (WSL is fine)
- Git, and a GitHub account for turning in work
- Verilog at the level of EE 2301 — modules, always blocks, testbenches

## The flow, in order

| Stage | You write | The tool produces |
| --- | --- | --- |
| RTL | Verilog | — |
| Simulation | Testbench | Waveforms |
| Synthesis | Constraints | Gate-level netlist |
| Place & route | Floorplan | GDSII layout |

## A first module

```verilog
module blink #(parameter N = 24) (
  input  wire clk,
  input  wire rst_n,
  output wire led
);
  reg [N-1:0] count;
  always @(posedge clk or negedge rst_n)
    if (!rst_n) count <= 0;
    else        count <= count + 1'b1;

  assign led = count[N-1];
endmodule
```

Nothing here is ASIC-specific yet — that's the point. The RTL is the same; everything downstream of it changes.

## Checklist

- [x] Read this page
- [ ] Install the toolchain
- [ ] Simulate `blink` and screenshot the waveform
