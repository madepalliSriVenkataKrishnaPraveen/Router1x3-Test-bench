//------------------------------------------
// DESTINATION TRANSACTION CLASS
//------------------------------------------

class dest_xtn extends uvm_sequence_item;

	//factory registration	
	`uvm_object_utils(dest_xtn)

	//declaration of parameters
	rand bit[5:0] no_of_cycle;
	bit[7:0] header;
	bit[7:0] payload[];
	bit[7:0] parity;

	//overriding constructor
	function new(string name="dest_xtn");
		super.new(name);
	endfunction

	//do_copy
	function void do_copy (uvm_object rhs);

    		// handle for overriding the variable
    		dest_xtn rhs_;

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
    		no_of_cycle= rhs_.no_of_cycle;
	
  	endfunction:do_copy
	
	//do_print
	function void  do_print (uvm_printer printer);
    		
		super.do_print(printer);

   		//                   srting name			bitstream value		size	radix for printing
    		printer.print_field( "header",				this.header, 	    	8,	UVM_DEC);
		foreach(payload[i])
    		printer.print_field( $sformatf("payload[%0d]",i),	this.payload[i],	8,	UVM_DEC);
    		printer.print_field( "parity", 				this.parity, 	    	8,	UVM_DEC);
    		printer.print_field( "no_of_cycle", 			this.no_of_cycle,     	6,	UVM_DEC);

  	endfunction:do_print


endclass

