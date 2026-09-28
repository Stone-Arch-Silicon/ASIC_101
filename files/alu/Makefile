# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# ASIC 101 reference ALU: every check the RTL and Verification tracks teach.
#
#   make check              run everything with the ripple-carry adder
#   make check ADDER=cla    same, carry-lookahead adder (rca | cla | csel)
#   make sim-alu            one target at a time
#
# Needs: iverilog, verilator, yosys, sby + z3, python3 with cocotb.

ADDER ?= rca
RTL   := rtl/adder8_$(ADDER).v rtl/alu_core.v rtl/alu_top.v
B     := build/$(ADDER)

.PHONY: check lint sim-adder sim-alu sim-top cocotb cocotb-top tt formal synth clean

check: lint sim-adder sim-alu sim-top cocotb cocotb-top tt formal synth
	@echo "All checks passed for ADDER=$(ADDER)"

$(B):
	mkdir -p $@

lint:
	verilator --lint-only -Wall rtl/lint_waivers.vlt $(RTL) --top-module alu_top

sim-adder: | $(B)
	iverilog -g2012 -o $(B)/adder8_tb.vvp tb/adder8_tb.v rtl/adder8_$(ADDER).v
	vvp -n $(B)/adder8_tb.vvp | tee $(B)/adder8_tb.log
	grep -q "^PASS" $(B)/adder8_tb.log

sim-alu: | $(B)
	iverilog -g2012 -o $(B)/alu_tb.vvp tb/alu_tb.v rtl/adder8_$(ADDER).v rtl/alu_core.v
	vvp -n $(B)/alu_tb.vvp | tee $(B)/alu_tb.log
	grep -q "^PASS" $(B)/alu_tb.log

sim-top: | $(B)
	iverilog -g2012 -o $(B)/alu_top_tb.vvp tb/alu_top_tb.v $(RTL)
	vvp -n $(B)/alu_top_tb.vvp | tee $(B)/alu_top_tb.log
	grep -q "^PASS" $(B)/alu_top_tb.log

cocotb:
	$(MAKE) -C cocotb ADDER=$(ADDER) TOP=alu_core
	! grep -q "<failure" cocotb/results.xml

cocotb-top:
	$(MAKE) -C cocotb ADDER=$(ADDER) TOP=alu_top
	! grep -q "<failure" cocotb/results.xml

tt:
	$(MAKE) -C tt ADDER=$(ADDER)
	! grep -q "<failure" tt/results.xml

formal:
	cd formal && sby -f adder8.sby $(ADDER) && sby -f alu.sby good

synth: | $(B)
	yosys -q -p "read_verilog $(RTL); synth -flatten -top alu_top; abc -g AND,NAND,OR,NOR,XOR,XNOR,MUX; opt_clean; tee -o $(B)/synth_stat.txt stat; tee -o $(B)/synth_ltp.txt ltp -noff"
	cat $(B)/synth_stat.txt

clean:
	rm -rf build cocotb/sim_build cocotb/results.xml tt/sim_build tt/results.xml \
	       formal/adder8_rca formal/adder8_cla formal/adder8_csel formal/alu_good formal/alu_buggy pd/runs *.vcd
