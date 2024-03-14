//------------------------------------------
// DESTINATION BASE SEQUENCE CLASS
//------------------------------------------

class router_dest_sequence extends uvm_sequence#(dest_xtn);

	//factory registration
	`uvm_object_utils(router_dest_sequence)

	//overriding constructor
	function new(string name="router_dest_sequence");
		super.new(name);
	endfunction

endclass

//------------------------------------------
// DESTINATION IDEAL SEQUENCE CLASS
//------------------------------------------

class router_dest_ideal extends router_dest_sequence;

	//factory registration
	`uvm_object_utils(router_dest_ideal)

	//overriding constructor
	function new(string name="router_dest_ideal");
		super.new(name);
	endfunction

	//body
	task body();

		//create instance of transaction class
		req=dest_xtn::type_id::create("req");

		//wait for driver to request item
		start_item(req);

		//randomize 
		assert(req.randomize() with{no_of_cycle inside {[0:28]};});
		`uvm_info("ROUTER_DEST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)

		//send randomize items and wait for acknowledement
		finish_item(req);

	endtask

endclass

//------------------------------------------
// DESTINATION SOFT RESET SEQUENCE CLASS
//------------------------------------------

class router_dest_soft_rst extends router_dest_sequence;

	//factory registration
	`uvm_object_utils(router_dest_soft_rst)

	//overriding constructor
	function new(string name="router_dest_soft_rst");
		super.new(name);
	endfunction

	//body
	task body();

		//create instance of transaction class
		req=dest_xtn::type_id::create("req");

		//wait for driver to request item
		start_item(req);

		//randomize 
		assert(req.randomize() with{no_of_cycle == 30;});
		`uvm_info("ROUTER_DEST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)

		//send randomize items and wait for acknowledement
		finish_item(req);

	endtask

endclass

