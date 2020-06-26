ECE-593 Fundamentals of Pre-silicon Validation (Spring 2020)
Title: AXI4 Lite Verification
Guide: Dr. Tom Schubert
Team: Seth Rohrbach, Surakshith Reddy Mothe and Sumeet Subhash Pawar


This directory ECE593_Final_Project contains the following folders and files:
- Docs folder: Contains Verification Plan (revised), Verification Report and the Design Architecture Overview Document
- DUT folder: Contains Design source codes namely: axi4_lite_Defs.sv, axi4_lite_if.sv, axi4_lite_master.sv and axi4_lite_slave.sv  
- TB folder: Contains Testbench codes namely: axi4_checker_obj.sv, axi4_Coverage.sv, axi4_env.sv, axi4_lite_bfm.sv, axi4_ootb_top.sv and axi_tb_objs.sv
- Makefile
- README 


Instructions to run the code:
i) Change the current working directory to ECE593_Final_Project. This can be done by typing 'cd ECE593_Final_Project' in the linux/unix command window.
ii) compile and simulate the code with 'make' command
iii) After simulation, type 'run 1000' in the QuestaSim command window to run the code for 1000 time units
iv) To check the coverage data after the run, type 'coverage report' in the questa command window