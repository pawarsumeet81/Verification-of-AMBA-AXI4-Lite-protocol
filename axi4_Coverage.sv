///////////////////////////////////////////////////////////////////////////////
// axi4_coverage.sv - coverages.
//
// Author: Sumeet Pawar(pawar@pdx.edu), Surakshith Reddy Mothe(smothe@pdx.edu)
// Modified: June 5, 2020
//
// Description:
// ------------
// contains all covergroups for code coverage and functional coverage.
//
////////////////////////////////////////////////////////////////////////////////



// import the global definitions of AXI4 Lite bus
import axi4_lite_Defs::*;

// coverage class
class axi4_Coverage;

//Hook the coverage up with the AXI4:
  virtual axi4_lite_bfm bfm;


// ------------------------------------------------------- COVERAGES -------------------------------------------------------
// Covergroup 1 for Read Address
covergroup cg_Read_Address;
   Read_Address_Valid: coverpoint bfm.ARVALID iff (bfm.ARESETN) {   // Coverpoint for Read Address Valid signal
   	bins ARVALID_High = {1};
   	bins ARVALID_Low = {0};
   	}

	Read_Address_Ready: coverpoint bfm.ARREADY iff (bfm.ARESETN) {   // Coverpoint for Read Address Ready signal
   	bins ARREADY_High = {1};
   	bins ARREADY_Low = {0};
   	}

   Read_Address: coverpoint bfm.ARADDR {                          // Coverpoint for Read Address
   	bins ARADDR_First_Location = {0};
   	bins ARADDR_Last_Location = {4096};
   	bins ARADDR_range[] = {[1:4095]};
   	}
endgroup : cg_Read_Address


// Covergroup 2 for Read Data
covergroup cg_Read_Data;
   Read_Data_Valid: coverpoint bfm.RVALID iff (bfm.ARESETN) {    // Coverpoint for Read Data Valid signal
		bins RVALID_High = {1};
   	bins RVALID_Low = {0};
   	}

	Read_Data_Ready: coverpoint bfm.RREADY iff (bfm.ARESETN) {       // Coverpoint for Read Data Ready signal
   		bins RREADY_High = {1};
   		bins RREADY_Low = {0};
   	}

   Read_Data: coverpoint bfm.RDATA {                                 // Coverpoint for Read Data
   	   bins RDATA_All_Zeros = {0};
   		bins RDATA_All_Ones = {4096};
   		bins RDATA_range[] = {[1:4095]};
   	}
endgroup : cg_Read_Data


// Covergroup 3 for Write Address
covergroup cg_Write_Address;
   Write_Address_Valid: coverpoint bfm.AWVALID iff (bfm.ARESETN) {  // Coverpoint for Write Address Valid signal
	  	bins AWVALID_High = {1};
   	bins AWVALID_Low = {0};
   	}

	Write_Address_Ready: coverpoint bfm.AWREADY iff (bfm.ARESETN) {     // Coverpoint for Write Address Ready signal
   	  	bins AWREADY_High = {1};
   		bins AWREADY_Low = {0};
   	}

   Write_Address: coverpoint bfm.AWADDR {                               // Coverpoint for Write Address signal
   		bins AWADDR_First_Location = {0};
   		bins AWADDR_Last_Location = {4096};
   		bins AWADDR_range[] = {[1:4095]};
   	}
endgroup : cg_Write_Address


// Covergroup 4 for Write Data
covergroup cg_Write_Data;
   Write_Data_Valid: coverpoint bfm.WVALID iff (bfm.ARESETN) {      // Coverpoint for Write Data Valid signal
   		bins WVALID_High = {1};
   		bins WVALID_Low = {0};
   	}

	Write_Data_Ready: coverpoint bfm.WREADY iff (bfm.ARESETN) {         // Coverpoint for Write Data Ready signal
   		bins WREADY_High = {1};
   		bins WREADY_Low = {0};
   	}

   Write_Data: coverpoint bfm.WDATA {                               // Coverpoint for Write Data signal
   		bins WDATA_All_Zeros = {0};
   		bins WDATA_All_Ones = {4096};
   		bins WDATA_range[] = {[1:4095]};
   	}
endgroup : cg_Write_Data


// Covergroup 5 for Write Response
covergroup cg_Write_Response;
   Write_Response_Valid: coverpoint bfm.BVALID iff (bfm.ARESETN) {  // Coverpoint for Write Response Valid signal
   		bins BVALID_High = {1};
   		bins BVALID_Low = {0};
   	}

	Write_Response_Ready: coverpoint bfm.BREADY iff (bfm.ARESETN) {     // Coverpoint for Write Response Ready signal
   		bins BREADY_High = {1};
   		bins BREADY_Low = {0};
   	}
endgroup : cg_Write_Response


// Covergroup 6 for Master FSM
covergroup cg_Master_FSM;
   	Master_Read_FSM: coverpoint $root.a_OOTB_TOP.MP.current_state_read iff (bfm.ARESETN) {   // Coverpoint for Master Read FSM
   		bins mr1 = (IDLE => ADDR);
   		bins mr2 = (ADDR => DATA);
   		bins mr3 = (DATA => RESP);
   		bins mr4 = (RESP => IDLE);
   		bins mr_sequence = (IDLE => ADDR => DATA => RESP => IDLE);
   		illegal_bins mr_illegal1 = (DATA => ADDR);
   		illegal_bins mr_illegal2 = (RESP => DATA);
   	  	illegal_bins mr_illegal3 = (RESP => ADDR);
   		illegal_bins mr_illegal4 = (IDLE => DATA);
   		illegal_bins mr_illegal5 = (IDLE => RESP);
   		illegal_bins mr_illegal6 = (ADDR => RESP);
   	}

   	Master_Write_FSM: coverpoint $root.a_OOTB_TOP.MP.current_state_write iff (bfm.ARESETN) {    // Coverpoint for Master Write FSM
   		bins mw1 = (IDLE => ADDR);
   		bins mw2 = (ADDR => DATA);
   		bins mw3 = (DATA => RESP);
   		bins mw4 = (RESP => IDLE);
   		bins mw_sequence = (IDLE => ADDR => DATA => RESP => IDLE);
   		illegal_bins mw_illegal1 = (DATA => ADDR);
   		illegal_bins mw_illegal2 = (RESP => DATA);
   	  	illegal_bins mw_illegal3 = (RESP => ADDR);
   		illegal_bins mw_illegal4 = (IDLE => DATA);
   		illegal_bins mw_illegal5 = (IDLE => RESP);
   		illegal_bins mw_illegal6 = (ADDR => RESP);
   	}
endgroup : cg_Master_FSM


// Covergroup 7 for Slave FSM
covergroup cg_Slave_FSM;
   	Slave_Read_FSM: coverpoint $root.a_OOTB_TOP.SP.current_state_read iff (bfm.ARESETN) {  // Coverpoint for Slave Read FSM
   		bins sr1 = (IDLE => ADDR);
   		bins sr2 = (ADDR => DATA);
   		bins sr3 = (DATA => RESP);
   		bins sr4 = (RESP => IDLE);
   		bins sr_sequence = (IDLE => ADDR => DATA => RESP => IDLE);
   		illegal_bins sr_illegal1 = (DATA => ADDR);
   		illegal_bins sr_illegal2 = (RESP => DATA);
   	  	illegal_bins sr_illegal3 = (RESP => ADDR);
   		illegal_bins sr_illegal4 = (IDLE => DATA);
   		illegal_bins sr_illegal5 = (IDLE => RESP);
   		illegal_bins sr_illegal6 = (ADDR => RESP);
   	}

   	Slave_Write_FSM: coverpoint $root.a_OOTB_TOP.SP.current_state_write iff (bfm.ARESETN) {   // Coverpoint for Slave Write FSM
   	  	bins sw1 = (IDLE => ADDR);
   		bins sw2 = (ADDR => DATA);
   		bins sw3 = (DATA => RESP);
   		bins sw4 = (RESP => IDLE);
   		bins sw_sequence = (IDLE => ADDR => DATA => RESP => IDLE);
   		illegal_bins sw_illegal1 = (DATA => ADDR);
   		illegal_bins sw_illegal2 = (RESP => DATA);
   	  	illegal_bins sw_illegal3 = (RESP => ADDR);
   		illegal_bins sw_illegal4 = (IDLE => DATA);
   		illegal_bins sw_illegal5 = (IDLE => RESP);
   		illegal_bins sw_illegal6 = (ADDR => RESP);
   	}
endgroup : cg_Slave_FSM


// Covergroup 8 for Reset signals
covergroup cg_Reset_Signal;

	Read_Address_Valid_Reset: coverpoint bfm.ARVALID iff (!(bfm.ARESETN)) {   // Coverpoint for Read Address Valid Signal
   		bins ARVALID_Low_Reset = {0};
   		illegal_bins ARVALID_High_Reset_illegal = {1};
   	}

	Read_Address_Ready_Reset: coverpoint bfm.ARREADY iff (!(bfm.ARESETN)) {   // Coverpoint for Read Address Ready Signal
   		bins ARREADY_Low_Reset = {0};
   	   	illegal_bins ARREADY_High_Reset_illegal = {1};
   	}

   Read_Data_Valid_Reset: coverpoint bfm.RVALID iff (!(bfm.ARESETN)) {       // Coverpoint for Read Data Valid Signal
   		bins RVALID_Low_Reset = {0};
   		illegal_bins RVALID_High_Reset_illegal = {1};
   	}

	Read_Data_Ready_Reset: coverpoint bfm.RREADY iff (!(bfm.ARESETN)) {       // Coverpoint for Read Data Ready Signal
   		bins RREADY_Low_Reset = {0};
   		illegal_bins RREADY_High_Reset_illegal = {1};
   	}

   Write_Address_Valid_Reset: coverpoint bfm.AWVALID iff (!(bfm.ARESETN)) {  // Coverpoint for Write Address Valid Signal
   		bins AWVALID_Low_Reset = {0};
	  	   illegal_bins AWVALID_High_Reset_illegal = {1};
   	}

	Write_Address_Ready_Reset: coverpoint bfm.AWREADY iff (!(bfm.ARESETN)) {  // Coverpoint for Write Address Ready Signal
   		bins AWREADY_Low_Reset = {0};
   	  	illegal_bins AWREADY_High_Reset_illegal = {1};
   	}

   Write_Data_Valid_Reset: coverpoint bfm.WVALID iff (!(bfm.ARESETN)) {      // Coverpoint for Write Data Valid Signal
   		bins WVALID_Low_Reset = {0};
   		illegal_bins WVALID_High_Reset_illegal = {1};
   	}

	Write_Data_Ready_Reset: coverpoint bfm.WREADY iff (!(bfm.ARESETN)) {      // Coverpoint for Write Data Ready Signal
   		bins WREADY_Low_Reset = {0};
   		illegal_bins WREADY_High_Reset_illegal = {1};
   	}

   Write_Response_Valid_Reset: coverpoint bfm.BVALID iff (!(bfm.ARESETN)) {   // Coverpoint for Write Response Valid Signal
   		bins BVALID_Low_Reset = {0};
   		illegal_bins BVALID_High_Reset_illegal = {1};
   	}

	Write_Response_Ready_Reset: coverpoint bfm.BREADY iff (!(bfm.ARESETN)) {  // Coverpoint for Write Response Ready Signal
   		bins BREADY_Low_Reset = {0};
   		illegal_bins BREADY_High_Reset_illegal = {1};
   	}

   Master_Read_FSM_Reset: coverpoint $root.a_OOTB_TOP.MP.current_state_read iff (!(bfm.ARESETN)) {   // Coverpoint for Master Read FSM
   		bins mr_reset1 = (ADDR => IDLE);
   		bins mr_reset2 = (DATA => IDLE);
   		bins mr_reset3 = (RESP => IDLE);
   		illegal_bins mr_illegal1 = (IDLE => ADDR);
   		illegal_bins mr_illegal2 = (ADDR => DATA);
   		illegal_bins mr_illegal3 = (DATA => RESP);
   		illegal_bins mr_illegal4 = (DATA => ADDR);
   	   illegal_bins mr_illegal5 = (RESP => DATA);
   	  	illegal_bins mr_illegal6 = (RESP => ADDR);
   	   illegal_bins mr_illegal7 = (IDLE => DATA);
   	   illegal_bins mr_illegal8 = (IDLE => RESP);
   	   illegal_bins mr_illegal9 = (ADDR => RESP);

   	}

   Master_Write_FSM_Reset: coverpoint $root.a_OOTB_TOP.MP.current_state_write iff (!(bfm.ARESETN)) {    // Coverpoint for Master Write FSM
   	   bins mw_reset1 = (ADDR => IDLE);
   		bins mw_reset2 = (DATA => IDLE);
   		bins mw_reset3 = (RESP => IDLE);
   		illegal_bins mw_illegal1 = (IDLE => ADDR);
   		illegal_bins mw_illegal2 = (ADDR => DATA);
   		illegal_bins mw_illegal3 = (DATA => RESP);
   		illegal_bins mw_illegal4 = (DATA => ADDR);
   	   illegal_bins mw_illegal5 = (RESP => DATA);
   	  	illegal_bins mw_illegal6 = (RESP => ADDR);
   		illegal_bins mw_illegal7 = (IDLE => DATA);
   		illegal_bins mw_illegal8 = (IDLE => RESP);
   	   illegal_bins mw_illegal9 = (ADDR => RESP);
   	}

   Slave_Read_FSM_Reset: coverpoint $root.a_OOTB_TOP.SP.current_state_read iff (!(bfm.ARESETN)) {    // Coverpoint for Slave Read FSM
   		bins sr_reset1 = (ADDR => IDLE);
   		bins sr_reset2 = (DATA => IDLE);
   		bins sr_reset3 = (RESP => IDLE);
   		illegal_bins sr_illegal1 = (IDLE => ADDR);
   		illegal_bins sr_illegal2 = (ADDR => DATA);
   		illegal_bins sr_illegal3 = (DATA => RESP);
   		illegal_bins sr_illegal4 = (DATA => ADDR);
   	   illegal_bins sr_illegal5 = (RESP => DATA);
   	  	illegal_bins sr_illegal6 = (RESP => ADDR);
   	   illegal_bins sr_illegal7 = (IDLE => DATA);
   	   illegal_bins sr_illegal8 = (IDLE => RESP);
   	   illegal_bins sr_illegal9 = (ADDR => RESP);
   	}

   Slave_Write_FSM_Reset: coverpoint $root.a_OOTB_TOP.SP.current_state_write iff (!(bfm.ARESETN)) {     // Coverpoint for Slave Write FSM
   	   bins sw_reset1 = (ADDR => IDLE);
   		bins sw_reset2 = (DATA => IDLE);
   		bins sw_reset3 = (RESP => IDLE);
   		illegal_bins sw_illegal1 = (IDLE => ADDR);
   		illegal_bins sw_illegal2 = (ADDR => DATA);
   		illegal_bins sw_illegal3 = (DATA => RESP);
   		illegal_bins sw_illegal4 = (DATA => ADDR);
	   	illegal_bins sw_illegal5 = (RESP => DATA);
   	  	illegal_bins sw_illegal6 = (RESP => ADDR);
	   	illegal_bins sw_illegal7 = (IDLE => DATA);
	   	illegal_bins sw_illegal8 = (IDLE => RESP);
	   	illegal_bins sw_illegal9 = (ADDR => RESP);
   	}

endgroup : cg_Reset_Signal


// Function "new" which instantiates all the Covergroups
function new (virtual axi4_lite_bfm b);
      cg_Read_Address = new();
      cg_Read_Data = new();
      cg_Write_Address = new();
      cg_Write_Data = new();
      cg_Write_Response = new();
      cg_Reset_Signal = new();
      cg_Master_FSM = new();
      cg_Slave_FSM = new();

      bfm = b;
endfunction : new


// Task "execute" which samples all the covergroups
// This task can be called in environment class to sample all the covergroups
task execute();
	forever begin : sampling_block
		@(posedge bfm.ACLK);
      cg_Read_Address.sample();
      cg_Read_Data.sample();
      cg_Write_Address.sample();
      cg_Write_Data.sample();
      cg_Write_Response.sample();
      cg_Reset_Signal.sample();
      cg_Master_FSM.sample();
      cg_Slave_FSM.sample();
  end : sampling_block
endtask : execute

endclass
