# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
"""Clocked cocotb tests for alu_top (the registered wrapper).

The driver changes the inputs on the falling edge of the clock, the monitor
reads the outputs just after each rising edge, and a scoreboard (a Python
deque) holds expected results until the two-cycle latency has passed.

Run with:  make TOP=alu_top
"""

import random
from collections import deque

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, ReadOnly, RisingEdge

from test_alu_core import model, pick_operand

LATENCY = 2


async def start(dut):
    """Start a 100 MHz clock and hold reset for two cycles."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    dut.rst_n.value = 0
    dut.a.value = 0
    dut.b.value = 0
    dut.op.value = 0
    for _ in range(2):
        await RisingEdge(dut.clk)


@cocotb.test()
async def reset_values(dut):
    """While rst_n is low the outputs must be y = 0 with the zero flag set."""
    await start(dut)
    await ReadOnly()
    assert int(dut.y.value) == 0 and int(dut.zero.value) == 1


@cocotb.test()
async def pipeline_scoreboard(dut):
    """10,000 back-to-back random transactions checked through a scoreboard."""
    await start(dut)
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1

    rng = random.Random(7)
    pending = deque()
    checked = 0
    for cycle in range(10_000):
        await FallingEdge(dut.clk)                   # driver
        a, b, op = pick_operand(rng), pick_operand(rng), rng.randrange(8)
        dut.a.value, dut.b.value, dut.op.value = a, b, op
        pending.append(model(a, b, op))

        await RisingEdge(dut.clk)                    # monitor
        await ReadOnly()
        if len(pending) == LATENCY:                  # scoreboard
            expected = pending.popleft()
            got = (int(dut.y.value), int(dut.carry.value), int(dut.overflow.value),
                   int(dut.zero.value), int(dut.negative.value))
            assert got == expected, f"cycle {cycle}: got {got}, expected {expected}"
            checked += 1

    dut._log.info("%d results matched the scoreboard", checked)
