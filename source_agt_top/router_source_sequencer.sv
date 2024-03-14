//------------------------------------------
// SOURCE SEQUENCER CLASS
//------------------------------------------

class router_source_sequencer extends uvm_sequencer#(source_xtn);

	//factory registration
	`uvm_component_utils(router_source_sequencer)

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass
