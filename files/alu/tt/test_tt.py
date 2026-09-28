# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
"""cocotb test for the Tiny Tapeout wrapper: load a, b and op through the
shared ui_in bus, then check y and the flags."""

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, ReadOnly

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "cocotb"))
from test_alu_core import model  # noqa: E402

LOAD_A, LOAD_B, LOAD_OP = 1, 2, 4


async def load(dut, strobe, value):
    await FallingEdge(dut.clk)
    dut.ui_in.value = value
    dut.uio_in.value = strobe
    await FallingEdge(dut.clk)
    dut.uio_in.value = 0


@cocotb.test()
async def tiny_tapeout_alu(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())   # 50 MHz, like the TT demo board
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)
    dut.rst_n.value = 1

    rng = random.Random(1)
    for _ in range(300):
        a, b, op = rng.randrange(256), rng.randrange(256), rng.randrange(8)
        await load(dut, LOAD_A, a)
        await load(dut, LOAD_B, b)
        await load(dut, LOAD_OP, op)
        await FallingEdge(dut.clk)          # one more edge for the output register
        await ReadOnly()
        y, carry, overflow, zero, negative = model(a, b, op)
        flags = int(dut.uio_out.value) >> 4
        assert int(dut.uo_out.value) == y, f"op {op} a {a} b {b}: y {int(dut.uo_out.value)} != {y}"
        assert flags == (negative << 3) | (zero << 2) | (overflow << 1) | carry
        assert int(dut.uio_oe.value) == 0xF0
