module router_fsm(clock , resetn , pkt_valid , busy , parity_done , data_in , soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full , low_pkt_valid , fifo_empty_0 , fifo_empty_1 , fifo_empty_2 , detect_add , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state);


input clock , resetn , pkt_valid , parity_done , soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full , low_pkt_valid , fifo_empty_0 , fifo_empty_1 , fifo_empty_2 ;
input [1:0] data_in;

output busy ,detect_add , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state;

parameter DECODE_ADDRESS = 3'b000 , 
		  LOAD_FIRST_DATA = 3'b001,
		  LOAD_DATA = 3'b010,
		  FIFO_FULL_STATE = 3'b011,
		  LOAD_PARITY = 3'b100,
		  LOAD_AFTER_FULL = 3'b101,
		  CHECK_PARITY_ERROR = 3'b110,
		  WAIT_TILL_EMPTY = 3'b111;

reg [2:0] ps , ns;
reg [1:0] addr;

//latch address
always@(posedge clock)
begin
	if(!resetn)
	addr <= 2'b0;
	else if(detect_add)
	addr <= data_in;
	else
	addr <= addr;
end

//Present state logic
always@(posedge clock)
begin
	if(!resetn)
	ps <= DECODE_ADDRESS;
	else if((soft_reset_0 || soft_reset_1 || soft_reset_2) && (ns !== WAIT_TILL_EMPTY))
	ps <= DECODE_ADDRESS;
	else
	ps <= ns;
end

//Next State logic
always@(*)
begin
	ns <= DECODE_ADDRESS;
		case(ps)
		DECODE_ADDRESS : begin
							if((pkt_valid &&  (data_in == 2'b00) && fifo_empty_0) || (pkt_valid &&  (data_in == 2'b01) && fifo_empty_1) || (pkt_valid &&  (data_in == 2'b10) && fifo_empty_2))
							ns <= LOAD_FIRST_DATA;
							else if((pkt_valid &&  (data_in == 2'b00) && !fifo_empty_0) | (pkt_valid &&  (data_in == 2'b01) && !fifo_empty_1) | (pkt_valid &&  (data_in == 2'b10) && !fifo_empty_2))
							ns <= WAIT_TILL_EMPTY;
							else
							ns <= DECODE_ADDRESS;
							
						 end
		LOAD_FIRST_DATA : ns <= LOAD_DATA;
		LOAD_DATA : begin
						if(fifo_full)
						ns <= FIFO_FULL_STATE;
						else if(!fifo_full && !pkt_valid)
						ns <= LOAD_PARITY;
						else
						ns <= LOAD_DATA;						
					end
		FIFO_FULL_STATE : begin
							if(fifo_full)
							ns <= FIFO_FULL_STATE;
							else
							ns <= LOAD_AFTER_FULL;
						  end
		LOAD_PARITY : ns <= CHECK_PARITY_ERROR;
		LOAD_AFTER_FULL : begin
							if(parity_done)
							ns <= DECODE_ADDRESS;
							else
							begin
								if(low_pkt_valid)
								ns <= LOAD_PARITY;
								else
								ns <= LOAD_DATA;
							end
						  end
		CHECK_PARITY_ERROR : begin
								if(fifo_full)
								ns <= FIFO_FULL_STATE;
								else
								ns <= DECODE_ADDRESS;
							 end
		WAIT_TILL_EMPTY : begin
							if((fifo_empty_0 && (addr === 2'd0)) || (fifo_empty_1 && (addr === 2'd1)) || (fifo_empty_2 && (addr === 2'd2)))
							ns <= LOAD_FIRST_DATA;
 							else
							ns <= WAIT_TILL_EMPTY;
						  end
		default : ns <= DECODE_ADDRESS;		
		endcase

end

assign detect_add = (ps === DECODE_ADDRESS) ? 1'b1 :1'b0;
assign lfd_state = (ps === LOAD_FIRST_DATA) ? 1'b1 : 1'b0;
assign busy = (ps === LOAD_FIRST_DATA)|| (ps === LOAD_PARITY) || (ps === FIFO_FULL_STATE) || (ps === LOAD_AFTER_FULL) || (ps === WAIT_TILL_EMPTY) || (ps === CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
assign ld_state = (ps === LOAD_DATA) ? 1'b1 : 1'b0;
//assign write_enb_reg = ((ps === LOAD_DATA) || (ps === LOAD_PARITY) || ( (ps === LOAD_AFTER_FULL)))? 1'b1 : 1'b0;
assign write_enb_reg = (((ps === LOAD_DATA) || (ps === LOAD_PARITY) || (ps === LOAD_AFTER_FULL)) && ((ps!== FIFO_FULL_STATE)&&(ps!==WAIT_TILL_EMPTY)))? 1'b1 : 1'b0;
assign full_state = (ps === FIFO_FULL_STATE)? 1'b1 : 1'b0;
assign laf_state = (ps === LOAD_AFTER_FULL)? 1'b1 : 1'b0;
assign rst_int_reg = (ps === CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;

endmodule

