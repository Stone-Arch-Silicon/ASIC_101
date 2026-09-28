# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
# cocotb test for the Tiny Tapeout wrapper.  Usage:  make

ADDER          ?= rca
SIM            ?= icarus
TOPLEVEL_LANG   = verilog
RTL             = $(abspath ../rtl)
VERILOG_SOURCES = $(RTL)/adder8_$(ADDER).v $(RTL)/alu_core.v $(abspath tt_um_sasi_alu.v)
COCOTB_TOPLEVEL = tt_um_sasi_alu
COCOTB_TEST_MODULES = test_tt
SIM_BUILD       = sim_build/$(ADDER)_$(SIM)

include $(shell cocotb-config --makefiles)/Makefile.sim
