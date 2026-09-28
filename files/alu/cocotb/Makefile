# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# cocotb testbenches.  Usage:
#   make                      test alu_core with the ripple-carry adder
#   make ADDER=cla            same tests, carry-lookahead adder
#   make TOP=alu_top          clocked tests for the registered wrapper
#   make SIM=verilator        use Verilator instead of Icarus Verilog

ADDER          ?= rca
TOP            ?= alu_core
SIM            ?= icarus
TOPLEVEL_LANG   = verilog
RTL             = $(abspath ../rtl)
VERILOG_SOURCES = $(RTL)/adder8_$(ADDER).v $(RTL)/alu_core.v $(RTL)/alu_top.v
COCOTB_TOPLEVEL = $(TOP)
COCOTB_TEST_MODULES = test_$(TOP)
SIM_BUILD       = sim_build/$(TOP)_$(ADDER)_$(SIM)

include $(shell cocotb-config --makefiles)/Makefile.sim
