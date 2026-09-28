# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
"""cocotb tests for alu_core: constrained-random stimulus, a Python reference
model, and functional coverage.

Run with:  make            (uses Icarus Verilog by default)
           make ADDER=cla  (pick a different adder option)
"""

import json
import os
import random

import cocotb
from cocotb.triggers import Timer

OPS = ["ADD", "SUB", "AND", "OR", "XOR", "NOT", "SHL", "SHR"]
CORNERS = [0x00, 0x01, 0x7F, 0x80, 0xFF]


def model(a, b, op):
    """Reference model. Returns (y, carry, overflow, zero, negative)."""
    carry = overflow = 0
    sa = a - 256 if a & 0x80 else a          # signed view of a
    sb = b - 256 if b & 0x80 else b
    if op == 0:
        wide = a + b
        y, carry = wide & 0xFF, wide >> 8
        overflow = int(not -128 <= sa + sb <= 127)
    elif op == 1:
        wide = a + (~b & 0xFF) + 1
        y, carry = wide & 0xFF, wide >> 8
        overflow = int(not -128 <= sa - sb <= 127)
    elif op == 2:
        y = a & b
    elif op == 3:
        y = a | b
    elif op == 4:
        y = a ^ b
    elif op == 5:
        y = ~a & 0xFF
    elif op == 6:
        y = (a << 1) & 0xFF
    else:
        y = a >> 1
    return y, carry, overflow, int(y == 0), y >> 7


def pick_operand(rng):
    """Constrained random: 30% corner values, 70% anything."""
    return rng.choice(CORNERS) if rng.random() < 0.3 else rng.randrange(256)


class Coverage:
    """A tiny functional-coverage collector: named bins that count hits."""

    def __init__(self):
        self.bins = {}
        for name in OPS:
            self.bins[f"op {name}"] = 0
        for name in ["ADD carry", "ADD overflow", "SUB borrow", "SUB overflow",
                     "result zero", "result negative"]:
            self.bins[name] = 0
        for c in CORNERS:
            self.bins[f"a = 0x{c:02X}"] = 0

    def sample(self, a, b, op, y, carry, overflow):
        self.bins[f"op {OPS[op]}"] += 1
        if op == 0 and carry:
            self.bins["ADD carry"] += 1
        if op == 0 and overflow:
            self.bins["ADD overflow"] += 1
        if op == 1 and not carry:
            self.bins["SUB borrow"] += 1
        if op == 1 and overflow:
            self.bins["SUB overflow"] += 1
        if y == 0:
            self.bins["result zero"] += 1
        if y & 0x80:
            self.bins["result negative"] += 1
        if a in CORNERS:
            self.bins[f"a = 0x{a:02X}"] += 1

    def holes(self):
        return [name for name, hits in self.bins.items() if hits == 0]


async def apply(dut, a, b, op):
    dut.a.value = a
    dut.b.value = b
    dut.op.value = op
    await Timer(1, unit="ns")
    got = (int(dut.y.value), int(dut.carry.value), int(dut.overflow.value),
           int(dut.zero.value), int(dut.negative.value))
    return got


@cocotb.test()
async def directed_corners(dut):
    """Every op against every pair of corner values (8 x 5 x 5 = 200 checks)."""
    for op in range(8):
        for a in CORNERS:
            for b in CORNERS:
                got = await apply(dut, a, b, op)
                assert got == model(a, b, op), \
                    f"{OPS[op]} a=0x{a:02X} b=0x{b:02X}: got {got}, expected {model(a, b, op)}"


@cocotb.test()
async def random_with_coverage(dut):
    """Constrained-random transactions until every coverage bin is hit."""
    rng = random.Random(int(os.environ.get("SEED", "2026")))
    cov = Coverage()
    n = 0
    while n < 20000:
        a, b, op = pick_operand(rng), pick_operand(rng), rng.randrange(8)
        got = await apply(dut, a, b, op)
        exp = model(a, b, op)
        assert got == exp, f"{OPS[op]} a=0x{a:02X} b=0x{b:02X}: got {got}, expected {exp}"
        cov.sample(a, b, op, *exp[:3])
        n += 1
        if n >= 2000 and not cov.holes():
            break

    dut._log.info("%d random transactions, coverage holes: %s", n, cov.holes() or "none")
    with open("coverage.json", "w") as f:
        json.dump({"transactions": n, "bins": cov.bins}, f, indent=2)
    assert not cov.holes(), f"coverage holes: {cov.holes()}"
