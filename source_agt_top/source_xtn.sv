//------------------------------------------
// SOURCE TRANSACTION CLASS
//------------------------------------------

class source_xtn extends uvm_sequence_item;
	
	//factory registration
	`uvm_object_utils(source_xtn)
	
	//variable decleration
	rand bit[7:0] header;
	rand bit[7:0] payload[];
	bit[7:0] parity;
	bit error;	

	//overriding constructor
	function new(string name= "source_xtn");
		super.new(name);
	endfunction
	
	// constraints
	constraint address{header[1:0]!=2'b11;}
	constraint payload_len{header[7:2]!=0;}
	constraint payload_size{payload.size == header[7:2];}

	//do_copy
	function void do_copy (uvm_object rhs);

    		// handle for overriding the variable
    		source_xtn rhs_;

		//check the compatibility
    		if(!$cast(rhs_,rhs)) 
			begin
   				`uvm_fatal("do_copy","cast of the rhs object failed")
    			end

    		super.do_copy(rhs);

  		// Copy over data members:
  		// <var_name> = rhs_.<var_name>;
    		header= rhs_.header;
    		payload= new[header[7:2]];
		foreach(payload[i])
			payload[i]=rhs_.payload[i];
    		parity= rhs_.parity;
    		error= rhs_.error;
	
  	endfunction:do_copy
	
	//do_print
	function void  do_print (uvm_printer printer);
    		
		super.do_print(printer);

   		//                   srting name			bitstream value		size	radix for printing
    		printer.print_field( "header",				this.header, 	    	8,	UVM_DEC);
		foreach(payload[i])
    		printer.print_field( $sformatf("payload[%0d]",i),	this.payload[i],	8,	UVM_DEC);
    		printer.print_field( "parity", 				this.parity, 	    	8,	UVM_DEC);
    		printer.print_field( "error", 				this.error,     	1,	UVM_DEC);

  	endfunction:do_print

	//post randomize
	function void post_randomize();
	
		//parity is xor of header and all the payload
		parity = 0 ^ header;
		foreach(payload[i])
			parity = parity ^ payload[i];
	
	endfunction

endclass

//------------------------------------------
// BAD TRANSACTION CLASS
//------------------------------------------

class bad_xtn extends source_xtn;
	
	//factory registration
	`uvm_object_utils(bad_xtn)	

	//overriding constructor
	function new(string name= "bad_xtn");
		super.new(name);
	endfunction

	//post randomize
	function void post_randomize();
	
		//randomise parity 
		parity = $random;
	
	endfunction

endclass
