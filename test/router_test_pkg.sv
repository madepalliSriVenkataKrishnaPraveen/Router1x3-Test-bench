//------------------------------------------
// TEST PACKAGE
//------------------------------------------

package router_test_pkg;
	
	//import uvm pkg
	import uvm_pkg::*;

	//include uvm macros
	`include "uvm_macros.svh"
	
	//include transaction and configuration classes
	`include "source_xtn.sv"
	`include "dest_xtn.sv"
	`include "router_source_agent_config.sv"
	`include "router_dest_agent_config.sv"
	`include "router_env_config.sv"
	
	//include source components classes
	`include "router_source_driver.sv"
	`include "router_source_monitor.sv"
	`include "router_source_sequencer.sv"
	`include "router_source_agent.sv"
	`include "router_source_agent_top.sv"
	`include "router_source_sequence.sv"

	//include source components classes
	`include "router_dest_driver.sv"
	`include "router_dest_monitor.sv"
	`include "router_dest_sequencer.sv"
	`include "router_dest_agent.sv"
	`include "router_dest_agent_top.sv"
	`include "router_dest_sequence.sv"

	//include component classes under env class
	`include "router_virtual_sequencer.sv"
	`include "router_virtual_sequence.sv"
	`include "router_scoreboard.sv"

	//include env class
	`include "router_env.sv"

	//include test class
	`include "router_vtest_lib.sv"

endpackage
