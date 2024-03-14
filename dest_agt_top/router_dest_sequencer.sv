class router_dest_sequencer extends uvm_sequencer#(dest_xtn);

	//factory registration
	`uvm_component_utils(router_dest_sequencer)

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass
