//------------------------------------------
// TOP MODULE
//------------------------------------------

`timescale 1ns/1ps
module router_top();

	//import uvm pkg,user defined pkg and include uvm macros
	import uvm_pkg::*;
	import router_test_pkg::*;
	`include "uvm_macros.svh"

	//declare clock
	bit clock;
	always
		#10 clock = ~clock;

	//declare interfaces
	src_if src_if0(clock);
	dst_if dst_if0(clock);
	dst_if dst_if1(clock);
	dst_if dst_if2(clock);

	//declare dut
	router_1x3 DUV(.clock(clock) ,
			.resetn(src_if0.rst) ,
			.read_enb_0(dst_if0.read_enable) ,
			.read_enb_1(dst_if1.read_enable) ,
			.read_enb_2(dst_if2.read_enable) ,
			.data_in(src_if0.data_in) ,
			.pkt_valid(src_if0.pkt_valid) ,
			.data_out_0(dst_if0.data_out) ,
			.data_out_1(dst_if1.data_out) ,
			.data_out_2(dst_if2.data_out) ,
			.valid_out_0(dst_if0.valid_out) ,
			.valid_out_1(dst_if1.valid_out) ,
			.valid_out_2(dst_if2.valid_out) ,
			.error(src_if0.error) ,
			.busy(src_if0.busy));

//	bind DUV.router1 router_assertions ROUTER_ASSERTION(clock,busy,pkt_valid,resetn,valid_out_0,valid_out_1,valid_out_2,read_enb_0,read_enb_1,read_enb_2);

	initial
		begin
			`ifdef VCS
		$fsdbDumpSVA(0,router_top);
         	$fsdbDumpvars(0, router_top);
        	`endif

			//set virtual interfaces in config db
			uvm_config_db#(virtual src_if)::set(null,"*","src_if",src_if0);
			uvm_config_db#(virtual dst_if)::set(null,"*","dst_if0",dst_if0);
			uvm_config_db#(virtual dst_if)::set(null,"*","dst_if1",dst_if1);
			uvm_config_db#(virtual dst_if)::set(null,"*","dst_if2",dst_if2);

			// call run test method
			run_test();
		end

endmodule
