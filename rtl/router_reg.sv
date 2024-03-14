module router_reg(clock , resetn , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , err , dout);

input clock , resetn , pkt_valid , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state;
output reg parity_done , low_pkt_valid , err ;
output reg [7:0] dout;
input  [7:0] data_in;

reg [7:0] hold_header_byte , fifo_full_byte , internal_parity_byte , packet_parity_byte;

// HHB and FFB
always@(posedge clock)
begin
	if(!resetn)
	{hold_header_byte , fifo_full_byte} <= 16'b0;
	else 
	begin
		if(detect_add && pkt_valid)
		hold_header_byte <= data_in;
		else if(ld_state && fifo_full)
		fifo_full_byte <= data_in;
		else
		{hold_header_byte , fifo_full_byte} <= {hold_header_byte , fifo_full_byte};
	end
end

//Data out logic
always@(posedge clock)
begin
	if(!resetn)
	dout <= 8'b0;
	else if(lfd_state)
	dout <= hold_header_byte;
	else if(ld_state && (~fifo_full))
	dout <= data_in;
	else if(laf_state)
	dout <= fifo_full_byte;
	else
	dout <= dout;
end

//Low packet valid logic
always@(posedge clock)
begin
	if(!resetn || rst_int_reg)
	low_pkt_valid <= 1'b0;
	else if(ld_state && (!pkt_valid))
	low_pkt_valid <= 1'b1;
	else
	low_pkt_valid <= low_pkt_valid;
end

//Parity done signal logic
always@(posedge clock)
begin
	if(!resetn || detect_add)
	parity_done <= 1'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
	parity_done <= 1'b1;
	else
	parity_done <= parity_done;
end

//Packet Parity
always@(posedge clock)
begin
	if(!resetn || detect_add)
	packet_parity_byte <= 8'b0;
	else if(!pkt_valid)
	packet_parity_byte <= data_in;
	else
	packet_parity_byte <= packet_parity_byte;
end

//Internal Parity logic
always@(posedge clock)
begin
	if(!resetn || detect_add)
	internal_parity_byte <= 8'b0;
	else if(lfd_state && pkt_valid)
	internal_parity_byte <= internal_parity_byte ^ hold_header_byte;
	else if(pkt_valid && !full_state && ld_state)
	internal_parity_byte <= internal_parity_byte ^ data_in;
	else
	internal_parity_byte <= internal_parity_byte;
end

//Error signal
always@(posedge clock)
begin
	if(!resetn)
	err <= 1'b0;
	else if(!pkt_valid && rst_int_reg)
	begin
		if(internal_parity_byte !== packet_parity_byte)
		err <= 1'b1;
		else
		err <= 1'b0;
	end
	else
	err <= err;
end

endmodule

