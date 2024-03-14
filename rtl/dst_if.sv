`timescale 1ns/1ps
interface dst_if(input bit clock);

	logic valid_out;
	logic read_enable;
	logic [7:0]data_out;

	clocking dst_drv_cb@(posedge clock);
		default input #1 output #1;
		input valid_out;
		output read_enable;
	endclocking

	clocking dst_mon_cb@(posedge clock);
		default input #1 output #1;
		input valid_out;
		input read_enable;
		input data_out;
	endclocking

	modport DST_DRV(clocking dst_drv_cb);
	modport DST_MON(clocking dst_mon_cb);

endinterface
