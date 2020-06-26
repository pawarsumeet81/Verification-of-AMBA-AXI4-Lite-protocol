//////////////////////////////////////////////////////////////////////////////////////////////
// axi4_ootb_top.sv - top module to instantiate and execute the object oriented testbench.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Modified: June 5, 2020
//
// Description:
// ------------
// Top module that creates an instance of axi4_environment class
// and executes task 'execute' in it.
///////////////////////////////////////////////////////////////////////////////////////////////


//Packages and includes:
import axi4_lite_Defs::*;
`include "TB/axi4_env.sv"


module a_OOTB_TOP;

  //Local vars:
  bit clk;
  bit rst_N;


  // declare the internal variables                                // system reset, active low
  logic rd_en, wr_en;                                   // read and write enable
  logic [Addr_Width-1:0] Read_Address, Write_Address;   // read and write address variables
  logic [Data_Width-1:0] Write_Data;                    // write data variable
  logic [31:0] i;                                       // loop variable

  //Instantiate the BFM:
  axi4_lite_bfm bfm(.ACLK(clk), .ARESETN(rst_N));

  //Instantiate the DUT master and slave:

  // instantiate the master module
  axi4_lite_master MP(
  		.rd_en(rd_en),
  		.wr_en(wr_en),
  		.Read_Address(Read_Address),
  		.Write_Address(Write_Address),
  		.Write_Data(Write_Data),
  		.M(bfm.master_if)
  );


  // instantiate the slave module
  axi4_lite_slave SP(
          .S(bfm.slave_if)
          );

  //Object handles:
  axi4_environment env_h;





  //Start the clock:
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //Make object handles, reset, and execute:

  initial begin
    rst_N = 0;
    #20 rst_N = 1;

    env_h = new(bfm);
    
    env_h.execute();
    #10000
    $display("Testing finished!");

  end

endmodule : a_OOTB_TOP
