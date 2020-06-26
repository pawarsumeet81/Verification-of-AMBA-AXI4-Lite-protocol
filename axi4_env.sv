////////////////////////////////////////////////////////////////////////////////////////////
// axi4_environment.sv - an environment for the axi4 object oriented testbench.
//
// Author: Seth Rohrbach
// Modified June 5, 2020
//
// Description:
// ------------
// Creates the instances of axi4_tester, axi4_coverage, axi4_checker classes
// and also creates separate threads for executing task 'execute' of each class in parallel.
/////////////////////////////////////////////////////////////////////////////////////////////



`include "TB/axi4_Coverage.sv"
import axi4_lite_Defs::*;


class axi4_environment;

	//Hook the environment up with the AXI4:
	virtual axi4_lite_bfm bfm;

	axi4_tester tester_h;		// declaring a axi4_tester class handle
	axi4_Coverage coverage_h;	// declaring a axi4_coverage class handle
	axi4_checker checker_h;		// declaring a axi4_checker class handle

	function new (virtual axi4_lite_bfm b);
		bfm = b;
	endfunction : new

	task execute();
		tester_h = new(bfm);	// instantiating the object of axi4_tester class and storing it in the same class handle
		coverage_h = new(bfm);	// instantiating the object of axi4_coverage class and storing it in the same class handle
		checker_h = new(bfm);	// instantiating the object of axi4_checker class and storing it in the same class handle

		fork
			tester_h.execute();		// calling the execute task of axi4_tester class
			coverage_h.execute();	// calling the execute task of axi4_coverage class
			checker_h.execute();	// calling the execute task of axi4_checker class
		join_none
	endtask : execute

endclass : axi4_environment
