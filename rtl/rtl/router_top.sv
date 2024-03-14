module router_1x3(clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);

	input clock , resetn , read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid;
	input [7:0] data_in;
	output valid_out_0 , valid_out_1 , valid_out_2 , error , busy;
	output [7:0] data_out_0 , data_out_1 , data_out_2;
	wire parity_done, soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full ,low_pkt_valid , empty_0  , empty_1 , empty_2, detect_add , ld_state , laf_state, full_state , write_enb_reg , rst_int_reg , lfd_state;
	wire [2:0] write_enb , full;
	wire [7:0] dout;

	router_fsm  RFS(clock , resetn , pkt_valid , busy , parity_done , data_in[1:0] , soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full , low_pkt_valid , empty_0 , empty_1 , empty_2 , detect_add , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state);

	router_sync RSY(detect_add , data_in[1:0] , write_enb_reg , clock , resetn , valid_out_0 , valid_out_1 , valid_out_2 , read_enb_0 , read_enb_1 , read_enb_2 , write_enb , fifo_full , empty_0 , empty_1 , empty_2 , soft_reset_0 , soft_reset_1 , soft_reset_2 , full[0] , full[1] , full[2]);

	router_reg RRG(clock , resetn , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , error , dout);

	router_fifo FIF0(dout , resetn , clock , write_enb[0] , read_enb_0 , soft_reset_0 , lfd_state , empty_0 , full[0] , data_out_0);
	router_fifo FIF1(dout , resetn , clock , write_enb[1] , read_enb_1 , soft_reset_1 , lfd_state , empty_1 , full[1] , data_out_1);
	router_fifo FIF2(dout , resetn , clock , write_enb[2] , read_enb_2 , soft_reset_2 , lfd_state , empty_2 , full[2] , data_out_2);

	property rstn;
		@(posedge clock) !resetn |=> (data_out_0 == 0 && data_out_1 == 0 && data_out_2 == 0);
	endproperty

	property bsy;
		@(posedge clock) disable iff(!resetn)
			busy |=> data_in == $past(data_in,1);
	endproperty

	property bsy_pkt_vld;
		@(posedge clock) disable iff(!resetn)
			$rose(pkt_valid) |=> $rose(busy);
	endproperty
	
//	property pkt_valid;
//		bit [5:0]a;
//		@(posedge clock) disable iff(!resetn)
//			($rose(pkt_valid),(a==data_out[7:2]))|=> ##1(pkt_valid[*a]) ##1 $fell(pkt_valid);
//	endproperty

	property rd_vld_out0;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_0) |=> ##1 (valid_out_0[*0:29]) ##1 read_enb_0;
	endproperty
	
	property rd_vld_out1;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_1) |=> ##1 (valid_out_1[*0:29]) ##1 read_enb_1;
	endproperty
	
	property rd_vld_out2;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_2) |=> ##1 (valid_out_2[*0:29]) ##1 read_enb_2;
	endproperty

	property valid_out;
		bit [1:0]a;
		@(posedge clock) disable iff(!resetn)
			($rose(pkt_valid),a=data_in[1:0])|=> if(a==2'b00)
									(##[0:$] valid_out_0)
								else if(a==2'b01)
									(##[0:$] valid_out_1)
								else if(a==2'b10)
									(##[0:$] valid_out_2);
	endproperty

	property data_out0;
		@(posedge clock) disable iff(!resetn)
			$rose(read_enb_0) |=> data_out_0;
	endproperty

	property data_out1;
		@(posedge clock) disable iff(!resetn)
			$rose(read_enb_1) |=> data_out_1;
	endproperty

	property data_out2;
		@(posedge clock) disable iff(!resetn)
			$rose(read_enb_2) |=> data_out_2;
	endproperty

	RESET : assert property(rstn);
	BUSY : assert property(bsy);
	BSY_PKT_VLD : assert property(bsy_pkt_vld);
	RD_VLD_OUT0 : assert property(rd_vld_out0);
	RD_VLD_OUT1 : assert property(rd_vld_out1);
	RD_VLD_OUT2 : assert property(rd_vld_out2);
	VALID_OUT : assert property(valid_out);
	DATA_OUT0 : assert property(data_out0);
	DATA_OUT1 : assert property(data_out1);
	DATA_OUT2 : assert property(data_out2);


endmodule

