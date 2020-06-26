///////////////////////////////////////////////////////////////
// axi4_checker_obj.sv - a simple checker and scoreboard for an object oriented axi4-lite bus testbench.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Modified: May 29, 2020
//
// Description:
//------------------------
// A simple checker and scoreboard object for an object oriented AXI4 testbench.
// It will look at the BFM's address lines and the testbench local memory and compare them.
// If the same, yay. If not the same, track a miscompare.
//////////////////////////////////////////////////////////////

import axi4_lite_Defs::*;

class axi4_checker;

  virtual axi4_lite_bfm bfm;

  int score = 0;

  //To store values for comparison:
  logic [Data_Width-1:0] local_mem[4096];
  int i;


//Instantiate BFM, wipe local mem.
  function new (virtual axi4_lite_bfm b);
    bfm = b;
    for (i = 0; i < 4096; i++) begin
      local_mem[i] = 0;
    end
  endfunction: new

  //Read the write data line and store the value to local memory.
  protected task save_val();
  begin
  @(posedge bfm.ACLK);
  //If the WRITE ADDR value is true, we can store the value to local mem.
  if (bfm.AWVALID) begin
    local_mem[bfm.AWADDR] = bfm.WDATA; //So it goes.
    $display("CHECKING ADDR %d, FINDING VALUE %d\n", bfm.AWADDR, bfm.WDATA);
  end
  end

  endtask: save_val

  //Read the read value line and check local memory to confirm
  protected task check_val();
  begin
  @(posedge bfm.ACLK);
  //If the RVALID is true, then a valid read op is in progress so we can compare.
  if (bfm.RVALID) begin
    //So we just compare it to local mem.
    if (!(bfm.RDATA == local_mem[bfm.ARADDR])) begin
      score = score + 1;
    end
  end
end
endtask : check_val

  task execute();
  int k = 0;
  for (k = 0; k < 4096; k++) begin
    @(posedge bfm.ACLK);
    fork
    save_val();
    check_val();
    join
    if (k == 4095) begin
      $display("SCORE IS: %d\n", score);
    end
  end

endtask: execute

endclass: axi4_checker
