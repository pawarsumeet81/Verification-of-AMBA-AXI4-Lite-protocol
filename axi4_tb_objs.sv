//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// axi4_tb_objs.sv - object definitions for an AXI4-Lite bus testbench.
//
// Author: Seth Rohrbach (rseth@pdx.edu), Sumeet S. Pawar (pawar@pdx.edu), Surakshith Reddy Mothe (smothe@pdx.edu)
// Modified: June 2, 2020
//
// Description:
// ------------
// Implements direct and random testcases which can be called in the environment class.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import axi4_lite_Defs::*;

class axi4_tester;

  //local variables *NOT CPU SIGNALS*
  rand logic [Addr_Width-1:0] Read_Address;
  rand logic [Addr_Width-1:0] Write_Address;
  rand logic [Data_Width-1:0] Write_Data;
  
  //Constraining the address, because we can only use 4k local memory.
  constraint legal {
  Read_Address >= 0;
  Write_Address >= 0;
  Read_Address <= 4095;
  Write_Address <= 4095;
  }

  //Hook the tester up with the AXI4:
  virtual axi4_lite_bfm bfm;


  //TB local vars:

  function new (virtual axi4_lite_bfm b);
    bfm = b;
  endfunction: new

  // ------------------------------------------ RANDOM WRITE TASK ------------------------------------------
  protected task rand_write_op( );

  begin
  @(posedge bfm.ACLK);
  bfm.WVALID = 1;
  bfm.AWVALID = 1;
  bfm.AWADDR = Write_Address;
  bfm.WDATA = Write_Data;
  $display("WRITING %d TO %d", Write_Data, Write_Address);
  end
  repeat(5) @(posedge bfm.ACLK)
  begin
  bfm.WVALID = 0;
  bfm.AWVALID = 0;
  end
  endtask: rand_write_op

  // ------------------------------------------ RANDOM READ TASK ------------------------------------------
  protected task rand_read_op( );

  begin
  @(posedge bfm.ACLK)
  bfm.ARVALID = 1;
  bfm.RREADY = 1;
  bfm.ARADDR = Read_Address;
  end
  begin
  repeat(5) @(posedge bfm.ACLK)
  bfm.ARVALID = 0;
  bfm.RREADY = 0;
  end
  endtask : rand_read_op


  // ------------------------------------------ READ TASK ------------------------------------------
  task Readtask(input [Addr_Width-1:0] R_Address);

  begin
  @(posedge bfm.ACLK)
  bfm.ARVALID = 1;
  bfm.RREADY = 1;
  bfm.ARADDR = R_Address;
  end
  begin
  repeat(5) @(posedge bfm.ACLK)
  $display("Reading from %d; Value read:%d",R_Address, bfm.RDATA);
  bfm.ARVALID = 0;
  bfm.RREADY = 0;
  end
endtask : Readtask

// ------------------------------------------ WRITE TASK ------------------------------------------
  task Writetask (input [Addr_Width-1:0] W_Address, input [Data_Width-1:0] W_Data);
  begin
  @(posedge bfm.ACLK);
  bfm.WVALID = 1;
  bfm.AWVALID = 1;
  bfm.AWADDR = W_Address;
  bfm.WDATA = W_Data;
  $display("WRITING %d TO %d", W_Data, W_Address);
  end
  repeat(5) @(posedge bfm.ACLK)
  begin
  bfm.WVALID = 0;
  bfm.AWVALID = 0;
  end
  endtask : Writetask


  // ------------------------------------------ TESTCASES TASKS ------------------------------------------
// ------------------------- Single Write followed by a single Read to the same intermediate location -------------------------
  task Write_Read_IntermediateLocation_Test();
    //Reset();                            // Calling Reset task
    Writetask(32'h101, 32'hFFFFFFF0);     // Calling Write task
    Readtask(32'h101);                    // Calling Read task
  endtask : Write_Read_IntermediateLocation_Test

// ------------------------- Single Write followed by a single Read to the same first location -------------------------
  task Write_Read_FirstLocation_Test();
    //Reset();                           // Calling Reset task
    Writetask(32'h000, 32'hFFFFFFF0);    // Calling Write task
    Readtask(32'h000);                   // Calling Read task
  endtask : Write_Read_FirstLocation_Test

// ------------------------- Single Write followed by a single Read to the same last location -------------------------
  task Write_Read_LastLocation_Test();
    //Reset();                            // Calling Reset task
    Writetask(32'h111, 32'hFFFFFFF0);     // Calling Write task
    Readtask(32'h111);                    // Calling Read task
  endtask : Write_Read_LastLocation_Test

// ------------------------- Perform single Read and a single Write at the same time to the same location -------------------------
task Write_Read_Sametime_SameLocation_Test();
  begin
  @(posedge bfm.ACLK);
  bfm.ARVALID = 1;
  bfm.WVALID = 1;
  bfm.AWVALID = 1;
  bfm.AWADDR = 32'h101;             // Providing the Write Address to the DUT
  bfm.WDATA = 32'hFFFFFFF0;         // Providing the Write Data to the DUT
  bfm.ARADDR = 32'h101;             // Providing Read Address to the DUT
  $display("WRITING %d TO %d", bfm.WDATA, bfm.AWADDR);
  end
  repeat(10) @(posedge bfm.ACLK)
  begin
  bfm.ARVALID = 0;
  bfm.WVALID = 0;
  bfm.AWVALID = 0;
  end
endtask : Write_Read_Sametime_SameLocation_Test

// ------------------------- Perform single Read and a single Write at the same time to a different location -------------------------
  task Write_Read_Sametime_DifferentLocation_Test();
  begin
  @(posedge bfm.ACLK);
  bfm.ARVALID = 1;
  bfm.WVALID = 1;
  bfm.AWVALID = 1;
  bfm.AWADDR = 32'h111;             // Providing the Write Address to the DUT
  bfm.WDATA = 32'hFFFFFFF0;         // Providing the Write Data to the DUT
  bfm.ARADDR = 32'h101;             // Providing Read Address to the DUT
  $display("WRITING %d TO %d", bfm.WDATA, bfm.AWADDR);
  end
  repeat(10) @(posedge bfm.ACLK)
  begin
  bfm.ARVALID = 0;
  bfm.WVALID = 0;
  bfm.AWVALID = 0;
  end
  endtask : Write_Read_Sametime_DifferentLocation_Test

// ------------------------- Perform Writes first to all consecutive locations followed by Reads later to the same consecutive locations -------------------------
  task Multiple_Writes_Multiple_Reads_ConsecutiveLocations_Test();
    int i;                        // Declaring a local variable 'i' for the for loop
    int j;                        // Declaring a local variable 'j' for the for loop
    //Reset();                    // Calling Reset task

    for (i = 0; i < 4096; i++) begin    // Loop to iterate through all locations
      Writetask(i, i);                  // Calling Write task
    end

    for (j = 0; j < 4096; j++) begin  // Loop to iterate through all locations
      Readtask(j);                    // Calling Read task
    end
  endtask : Multiple_Writes_Multiple_Reads_ConsecutiveLocations_Test

// ------------------------- Perform Writes first to all non-consecutive locations followed by Reads later to the same non-consecutive locations -------------------------
  task Multiple_Writes_Multiple_Reads_RandomLocations_Test();
    int i;                // Declaring a local variable 'i' for the for loop
    int j;                // Declaring a local variable 'j' for the for loop
    //Reset();            // Calling Reset task

    for (i = 0; i < 4096; i = i+4) begin // Loop to iterate through random locations throughout the memory size
      Writetask(i, i);                   // Calling Write task
    end

    for (j = 0; j < 4096; j = j+4) begin  // Loop to iterate through random locations throughout the memory size
      Readtask(j);                        // Calling Read task
    end
  endtask : Multiple_Writes_Multiple_Reads_RandomLocations_Test

// ------------------------- Perform Overwriting at the same location followed by a single Read to the same location -------------------------
  task Multiple_Writes_Single_Read_SameLocation_Test();
    int i;                               // Declaring a local variable 'i' for the for loop
    //Reset();                           // Calling Reset task

    for (i = 0; i < 40; i++) begin       // Loop to iterate
      Writetask(32'h011, i);             // Calling Write task while keeping the Write Address same and changing the data (Overwriting the same location)
    end

    Readtask(32'h011);                    // Calling Read task
  endtask : Multiple_Writes_Single_Read_SameLocation_Test


// ------------------------- Perform Write followed by a Read to the same out-of-boundary address -------------------------
  task Outofboundary_Memory_Access_Test();
    //Reset();                                  // Calling Reset task
    Writetask(32'h1111_1101, 32'hFFFFFFF0);     // Calling Write task
    Readtask(32'h1111_1101);                    // Calling Read task
  endtask : Outofboundary_Memory_Access_Test


  task execute();
  int i = 0;
  for (i = 0; i < 4096; i++) begin

    Write_Read_IntermediateLocation_Test();
    Write_Read_FirstLocation_Test();
    Write_Read_LastLocation_Test();
    Write_Read_Sametime_SameLocation_Test();
    Write_Read_Sametime_DifferentLocation_Test();
    Multiple_Writes_Multiple_Reads_ConsecutiveLocations_Test();
    Multiple_Writes_Multiple_Reads_RandomLocations_Test();
    Multiple_Writes_Single_Read_SameLocation_Test();
    Outofboundary_Memory_Access_Test();

   @(posedge bfm.ACLK)
   fork
   rand_write_op();
   rand_read_op();
   join
   end

endtask : execute

endclass: axi4_tester
