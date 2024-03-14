`timescale 1ns/1ps
interface src_if(input bit clock);

	logic rst;
	logic pkt_valid;
	logic error;
	logic busy;
	logic [7:0]data_in;

	clocking src_drv_cb@(posedge clock);
		default input #1 output #1;
		output rst;
		output pkt_valid;
		output data_in;
		input error;
		input busy;
	endclocking

	clocking src_mon_cb@(posedge clock);
		default input #1 output #1;
		input rst;
		input pkt_valid;
		input data_in;
		input error;
		input busy;
	endclocking

	modport SRC_DRV(clocking src_drv_cb);
	modport SRC_MON(clocking src_mon_cb);

endinterface
