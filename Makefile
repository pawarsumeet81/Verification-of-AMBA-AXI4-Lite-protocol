all: setup compile run clean

setup:
	vlib work
	vmap work work

compile:
	vlog DUT/axi4_lite_Defs.sv
	vlog DUT/axi4_lite_if.sv
	vlog DUT/axi4_lite_master.sv
	vlog DUT/axi4_lite_slave.sv
	vlog TB/axi4_checker_obj.sv
	vlog TB/axi4_Coverage.sv
	vlog TB/axi4_env.sv
	vlog TB/axi4_lite_bfm.sv
	vlog TB/axi4_ootb_top.sv
	vlog TB/axi4_tb_objs.sv
	vopt +acc a_OOTB_TOP -o dut_optimized

run:
	vsim dut_optimized 

clean:
	rm -rf transcript vsim.wlf