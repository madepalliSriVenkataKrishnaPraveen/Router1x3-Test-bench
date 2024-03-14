//------------------------------------------
// DESTINATION CONFIG CLASS
//------------------------------------------

class router_dest_agent_config extends uvm_object;
	
	//factory registration
	`uvm_object_utils(router_dest_agent_config)

	uvm_active_passive_enum is_active = UVM_ACTIVE;
	virtual dst_if vif;
		
	//overriding constructor
	function new(string name="router_dest_agent_config");
		super.new(name);
	endfunction

endclass
