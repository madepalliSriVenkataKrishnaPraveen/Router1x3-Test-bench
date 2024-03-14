module router_fifo(data_in , resetn , clock , write_enb , read_enb , soft_reset , lfd_state , empty , full , data_out);

input clock , resetn , write_enb , soft_reset , read_enb , lfd_state;
input [7:0] data_in;
output empty , full;
output reg [7:0] data_out;

reg [4:0] w_ptr , r_ptr;
reg [8:0] mem [15:0];
reg [6:0] fifo_counter;
reg lfd_temp;
integer i;


//lfd temp logic
always@(posedge clock)
begin
	if(!resetn)
	lfd_temp <= 1'b0;
	else
	lfd_temp <= lfd_state;
end


//Pointer logic
always@(posedge clock)
begin
	if(~resetn || soft_reset)
	{r_ptr , w_ptr} <= 10'd0;
	else
	begin
		if(~full && write_enb)
		w_ptr <= w_ptr + 5'b1;
		else
		w_ptr <= w_ptr;
		if(~empty && read_enb)
		r_ptr <= r_ptr + 5'b1;
	//	if(!empty && !fifo_counter && (r_ptr!=w_ptr))
	//	r_ptr = w_ptr;
		else 
		r_ptr <= r_ptr;
		
	end
end

//Counter Logic
always@(posedge clock)
begin
	if(~resetn || soft_reset)
	fifo_counter <= 7'b0;
	else if(~empty && read_enb)
	begin
		if(mem[r_ptr[3:0]][8] == 1'b1)
		fifo_counter <= (mem[r_ptr[3:0]][7:2] + 1'b1);
		else if(fifo_counter != 6'b0)
		fifo_counter <= fifo_counter - 1'b1;
		else
		fifo_counter <= fifo_counter;
	end
	else
	fifo_counter <= fifo_counter;	
end

//Read Operation
always@(posedge clock)
begin
	if(~resetn)
	data_out <= 8'b0;
	else if (soft_reset)
	data_out <= 8'b0;
	else if(~empty && read_enb)
	data_out <= mem[r_ptr[3:0]][7:0];
	else if(empty)
	data_out <= 8'bz;
	else if(fifo_counter == 7'b0)
	data_out <= 8'bz;
	else
	data_out <= 8'bz;
end

//Write Operation
always@(posedge clock)
begin
	if(~resetn || soft_reset)
	for(i =0 ;  i< 16; i= i+1)
	mem[i] <= 9'b0;
	else if(~full && write_enb)
	mem[w_ptr[3:0]] <= {lfd_temp, data_in};
end

assign empty = (w_ptr === r_ptr) ? 1'b1 : 1'b0;
assign full = (w_ptr === {~r_ptr[4] , r_ptr[3:0]})? 1'b1:1'b0;

endmodule

