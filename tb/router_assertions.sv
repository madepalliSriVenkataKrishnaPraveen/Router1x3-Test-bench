module router_assertions (clock,busy,pkt_valid,resetn,valid_out_0,valid_out_1,valid_out_2,read_enable_0,read_enable_1,read_enable_2,data_out_0,data_out_1,data_out_2,data_in);

	input clock,busy,pkt_valid,resetn,valid_out_0,valid_out_1,valid_out_2,read_enable_0,read_enable_1,read_enable_2;
	input [7:0]data_out_0,data_out_1,data_out_2,data_in;

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
	
/*	property pkt_valid;
		bit [5:0]a;
		@(posedge clock) disable iff(!resetn)
			($rose(pkt_valid),(a==data_out[7:2]))|=> ##1(pkt_valid[*a]) ##1 $fell(pkt_valid);
	endproperty
*/
	property rd_vld_out0;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_0) |=> ##1 (valid_out_0[*0:29]) ##1 read_enable_0;
	endproperty
	
	property rd_vld_out1;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_1) |=> ##1 (valid_out_1[*0:29]) ##1 read_enable_1;
	endproperty
	
	property rd_vld_out2;
		@(posedge clock) disable iff(!resetn)
			$rose(valid_out_2) |=> ##1 (valid_out_2[*0:29]) ##1 read_enable_2;
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
			$rose(read_enable_0) |=> data_out_0;
	endproperty

	property data_out1;
		@(posedge clock) disable iff(!resetn)
			$rose(read_enable_1) |=> data_out_1;
	endproperty

	property data_out2;
		@(posedge clock) disable iff(!resetn)
			$rose(read_enable_2) |=> data_out_2;
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
