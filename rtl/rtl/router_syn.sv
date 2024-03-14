module router_sync(detect_add , data_in , write_enb_reg , clock , resetn , vld_out_0 , vld_out_1 , vld_out_2 , read_enb_0 , read_enb_1 , read_enb_2 , write_enb , fifo_full , empty_0 , empty_1 , empty_2 , soft_reset_0 , soft_reset_1 , soft_reset_2 , full_0 , full_1 , full_2);

input detect_add ,write_enb_reg , clock , resetn , read_enb_0 , read_enb_1 , read_enb_2 , full_0 , full_1 , full_2 , empty_0 , empty_1 , empty_2;
input [1:0] data_in;
output vld_out_0 , vld_out_1 , vld_out_2 ;
output reg fifo_full , soft_reset_0 , soft_reset_1 , soft_reset_2 ;
output reg [2:0] write_enb;

reg [1:0] int_addr;
reg [4:0] counter_0 , counter_1 , counter_2;

//logic for latching address
always@(posedge clock)
begin
	if(!resetn)
	int_addr <= 2'b11;
	else if(detect_add)
	int_addr <= data_in;
	else
	int_addr <= int_addr;
end

//logic for valid
assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//logic for write enable
always@(*)
begin
	if(!resetn)
	write_enb = 3'b0;
	else if(write_enb_reg)
	begin
		case(int_addr)
			2'b00 : write_enb = 3'b001;
			2'b01 : write_enb = 3'b010;
			2'b10 : write_enb = 3'b100;
			default: write_enb = 3'b0;
		endcase
	end
	else
	write_enb = 3'b0;
end

//logic for full
always@(*)
begin
	if(!resetn)
	fifo_full = 1'b0;
	else
	begin
		case (int_addr)
		2'b00: fifo_full = full_0;
		2'b01: fifo_full = full_1;
		2'b10: fifo_full = full_2;
		default: fifo_full = 0;
		endcase
	end
end

//logic for soft reset
always@(posedge clock)
begin
	if(!resetn)
	begin
		counter_0<=5'b0;
	//	counter_1<=5'b0;
	//	counter_2<=5'b0;
		soft_reset_0 <= 1'b0;
	//	soft_reset_1 <= 1'b0;
	//	soft_reset_2 <= 1'b0;
	end
	else if(vld_out_0)
	begin
		if(read_enb_0)
		begin
			counter_0 <= 5'b0;
			soft_reset_0 <= 1'b0;
		end
		else if(counter_0 === 5'b11101)
		begin
			soft_reset_0 <= 1'b1;
			counter_0 <= 5'b0;
		end
		else
		begin
			counter_0 <= counter_0 + 5'b1;
			soft_reset_0 <= 1'b0;
		end
	end
	else
		soft_reset_0 <= 0;
end

always@(posedge clock)
begin
	if(!resetn)
	begin
		counter_1<=5'b0;
		soft_reset_1 <= 1'b0;
	end
	else if(vld_out_1)
	begin
		if(read_enb_1)
		begin
			counter_1 <= 5'b0;
			soft_reset_1 <= 1'b0;
		end
		else if(counter_1 === 5'b11101)
		begin
			soft_reset_1 <= 1'b1;
			counter_1 <= 5'b0;
		end
		else
		begin
			counter_1 <= counter_1 + 5'b1;
			soft_reset_1 <= 1'b0;
		end
	end
	else
		soft_reset_1 <= 1'b0;
end

always@(posedge clock)
begin
	if(!resetn)
	begin
		counter_2<=5'b0;
		soft_reset_2 <= 1'b0;
	end
	else if(vld_out_2)
	begin
		if(read_enb_2)
		begin
			counter_2 <= 5'b0;
			soft_reset_2 <= 1'b0;
		end
		else if(counter_2 === 5'b11101)
		begin
			soft_reset_2 <= 1'b1;
			counter_2 <= 5'b0;
		end
		else
		begin
			counter_2 <= counter_2 + 5'b1;
			soft_reset_2 <= 5'b0;
		end
	end
	else
		soft_reset_2 <= 1'b0;
end


endmodule

